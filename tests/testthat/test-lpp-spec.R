# Per-slide pagination: an `lpp:` / `cpp:` field on a spec entry overrides the
# deck-wide `t_lpp` / `t_cpp` / `l_lpp` / `l_cpp` arguments of generate_slides().
# See https://github.com/pharmaverse/autoslider.core/issues/126

# The shipped template already contains one slide, which generate_slides() adds
# to rather than replacing. Subtract it so a count is the number of *content*
# slides and counts from separate decks can be added together.
template_slides <- length(officer::read_pptx(
  file.path(system.file(package = "autoslider.core"), "theme/basic.pptx")
))

# Number of content slides in the deck produced by generate_slides().
n_slides <- function(outputs, ...) {
  outfile <- tempfile(fileext = ".pptx")
  on.exit(unlink(outfile), add = TRUE)
  generate_slides(outputs, outfile = outfile, ...)
  length(officer::read_pptx(outfile)) - template_slides
}

# Attach the spec attribute that generate_outputs()/decorate_outputs() would
# attach in the real pipeline. Returns a copy; the cached fixtures stay clean.
with_spec <- function(output, spec) {
  attr(output, "spec") <- spec
  output
}

# These tests prove the field bites by asking for *fewer, denser* pages rather
# than more. `formatters` refuses to paginate when the repeated header/footer
# material is taller than the requested page -- the demographics table carries
# 10 such lines and the AE listing 13, so a small `lpp` errors instead of
# splitting (8/10/12/14 all error on the table). Raising `lpp` can never hit
# that floor, so one constant is safe for every fixture.
#
# The deck-wide `t_lpp` now defaults to NULL (auto-fit to the slide height),
# which for these small fixtures also lands on a single page -- so the tests use
# an explicit `t_lpp`/`l_lpp` baseline (`base_lpp`) to get a multi-page deck to
# compare the per-slide override against.
# Measured on these fixtures: table 4 pages at lpp 20 -> 1 at 60;
# listing 5 pages at lpp 20 -> 1 at 60.
wide_lpp <- 60
base_lpp <- 20

# `cpp` is the opposite: widening it changes nothing (the table already fits at
# the default 200; 120/200/400 all give 4 pages), so it has to be narrowed to be
# observable. 80 splits the table into 8 pages; below ~60 it errors because the
# row labels alone are wider than the page.
narrow_cpp <- 80

# Fixtures are built once: the tables are cheap to reuse and rendering the pptx
# is what costs time. The AE listing is cut down to keep the deck small -- the
# tests compare slide counts, they do not need a long listing.
demog <- t_dm_slide(adsl, "TRT01A", c("SEX", "AGE", "RACE", "ETHNIC", "COUNTRY")) |>
  decorate(titles = "Demographics", footnotes = "footnote")

ae_listing <- l_ae_slide(adsl, adae[seq_len(30), ]) |>
  decorate(titles = "AE listing", footnotes = "footnote")

test_that("a spec `lpp` changes the pagination of that table", {
  skip_if_not_installed("filters")

  expect_lt(
    n_slides(list(with_spec(demog, list(lpp = wide_lpp))), t_lpp = base_lpp),
    n_slides(list(demog), t_lpp = base_lpp)
  )
})

test_that("a spec `lpp` applies to its own slide only, not the whole deck", {
  skip_if_not_installed("filters")

  # One deck, two outputs, only the first carries `lpp`. The total must be
  # exactly what each output contributes on its own -- proving the field
  # reached output A and did not leak into output B.
  a_wide <- n_slides(list(with_spec(demog, list(lpp = wide_lpp))), t_lpp = base_lpp)
  b_default <- n_slides(list(demog), t_lpp = base_lpp)

  both <- n_slides(list(with_spec(demog, list(lpp = wide_lpp)), demog), t_lpp = base_lpp)

  expect_equal(both, a_wide + b_default)
  expect_lt(both, 2 * b_default) # B kept the deck default, A did not
})

test_that("an output without a spec `lpp` follows the deck-wide argument", {
  skip_if_not_installed("filters")

  # No `lpp` in the spec must track the deck-wide `t_lpp`: a bare output and one
  # with an empty spec paginate identically at the same `t_lpp`, and both differ
  # from the auto-fit default -- proving the field, when absent, changes nothing.
  expect_equal(
    n_slides(list(demog), t_lpp = base_lpp),
    n_slides(list(with_spec(demog, list())), t_lpp = base_lpp)
  )
  expect_equal(
    n_slides(list(demog)),
    n_slides(list(demog), t_lpp = NULL)
  )
})

test_that("generate_slides(t_lpp =) still sets the deck-wide default", {
  skip_if_not_installed("filters")

  expect_lt(
    n_slides(list(demog), t_lpp = wide_lpp),
    n_slides(list(demog), t_lpp = 20)
  )
})

test_that("a spec `lpp` wins over the deck-wide argument", {
  skip_if_not_installed("filters")

  # Entry says 60, deck says 20: the entry wins, so this must be the denser
  # pagination, not the deck's.
  with_entry <- n_slides(list(with_spec(demog, list(lpp = wide_lpp))), t_lpp = 20)

  expect_equal(with_entry, n_slides(list(with_spec(demog, list(lpp = wide_lpp)))))
  expect_lt(with_entry, n_slides(list(demog), t_lpp = 20))
})

test_that("a spec `lpp` is honoured on the listing path", {
  skip_if_not_installed("filters")

  expect_lt(
    n_slides(list(with_spec(ae_listing, list(lpp = wide_lpp)))),
    n_slides(list(ae_listing))
  )
})

test_that("a spec `cpp` is honoured on the table path", {
  skip_if_not_installed("filters")

  # Narrower pages split the table into more column chunks.
  expect_gt(
    n_slides(list(with_spec(demog, list(cpp = narrow_cpp)))),
    n_slides(list(demog))
  )
})

test_that("assert_is_valid_pagination accepts positive whole numbers", {
  for (good in list(1, 20L, 30, 1e10)) {
    expect_equal(assert_is_valid_pagination(good, "lpp"), good)
  }
})

test_that("assert_is_valid_pagination rejects everything else", {
  # Covers the traps that would otherwise surface as `if (NA)` or as an opaque
  # error from deep inside paginate_table(): non-finite values, magnitudes past
  # .Machine$integer.max, wrong types, and wrong lengths.
  bad <- list(
    0, -1, 0.5, 2.5, "20", TRUE, c(10, 20), NA, NA_integer_, NA_real_,
    NaN, Inf, -Inf, NULL, list(1), character(0), integer(0)
  )
  for (value in bad) {
    expect_error(
      assert_is_valid_pagination(value, "lpp", "t_dm_slide_FAS"),
      "positive whole number"
    )
  }
})

test_that("the error names the field and the offending spec entry", {
  expect_error(
    assert_is_valid_pagination(0, "cpp", "t_dm_slide_FAS"),
    "`cpp` in spec entry 't_dm_slide_FAS'",
    fixed = TRUE
  )
})

test_that("an invalid spec `lpp` stops generate_slides()", {
  skip_if_not_installed("filters")

  expect_error(
    n_slides(list(with_spec(demog, list(lpp = 0)))),
    "positive whole number"
  )
})

test_that("an invalid spec `cpp` stops generate_slides()", {
  skip_if_not_installed("filters")

  expect_error(
    n_slides(list(with_spec(demog, list(cpp = -1)))),
    "positive whole number"
  )
})

test_that("`lpp` set in a yaml spec flows through the whole pipeline", {
  skip_if_not_installed("filters")

  filters::load_filters(
    yaml_file = system.file("filters.yml", package = "autoslider.core"),
    overwrite = TRUE
  )

  spec_yaml <- sprintf(
    '
- program: t_dm_slide
  titles: Demographics with lpp
  footnotes: "footnote"
  paper: L6
  suffix: FAS
  lpp: %d
  args:
    arm: "TRT01A"
    vars: ["SEX", "AGE", "RACE", "ETHNIC", "COUNTRY"]
- program: t_dm_slide
  titles: Demographics default
  footnotes: "footnote"
  paper: L6
  suffix: SE
  args:
    arm: "TRT01A"
    vars: ["SEX", "AGE", "RACE", "ETHNIC", "COUNTRY"]
',
    wide_lpp
  )
  spec_file <- tempfile(fileext = ".yml")
  on.exit(unlink(spec_file), add = TRUE)
  writeLines(spec_yaml, spec_file)

  spec <- read_spec(spec_file)
  expect_equal(spec[[1]]$lpp, wide_lpp) # the field survives read_spec()

  outputs <- spec |>
    generate_outputs(datasets = list(adsl = adsl, adae = adae)) |>
    decorate_outputs()

  # ... and survives decoration, which rebuilds the spec attribute
  expect_equal(attr(outputs[[1]], "spec")$lpp, wide_lpp)
  expect_null(attr(outputs[[2]], "spec")$lpp)

  # The entry with `lpp` needs fewer slides than the one without. Compare at an
  # explicit deck `t_lpp` so the default (`NULL`, auto-fit) does not collapse the
  # `lpp`-free entry onto a single page.
  n_both <- n_slides(outputs, t_lpp = base_lpp)
  n_default_only <- n_slides(outputs[2], t_lpp = base_lpp)
  expect_lt(n_both - n_default_only, n_default_only)
})
