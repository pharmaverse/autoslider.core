pptx_run_sizes <- function(path, text) {
  exdir <- withr::local_tempdir()
  utils::unzip(path, exdir = exdir)
  slide_files <- list.files(
    file.path(exdir, "ppt", "slides"),
    pattern = "^slide[0-9]+\\.xml$",
    full.names = TRUE
  )

  sizes <- unlist(lapply(slide_files, function(slide_file) {
    xml <- paste(readLines(slide_file, warn = FALSE), collapse = "\n")
    runs <- regmatches(
      xml,
      gregexpr("(?s)<a:r(?:\\s[^>]*)?>.*?</a:r>", xml, perl = TRUE)
    )[[1]]
    matching_runs <- runs[grepl(text, runs, fixed = TRUE)]
    sub(
      '(?s).*<a:rPr[^>]*sz="([0-9]+)"[^>]*>.*',
      "\\1",
      matching_runs,
      perl = TRUE
    )
  }), use.names = FALSE)

  as.integer(sizes)
}

test_that("with_font_sizes returns the formatter unchanged when no sizes given", {
  expect_identical(with_font_sizes(black_format_tb), black_format_tb)
})

test_that("with_font_sizes forwards sizes a formatter with explicit args declares", {
  seen <- list()
  rec_fmt <- function(ft, body_font_size = NA, header_font_size = NA,
                      footer_font_size = NA, ...) {
    seen <<- list(body = body_font_size, header = header_font_size, footer = footer_font_size)
    ft
  }
  ft <- flextable::flextable(head(iris))
  out <- with_font_sizes(rec_fmt, body_font_size = 7, header_font_size = 6, footer_font_size = 5)(ft)

  expect_s3_class(out, "flextable")
  expect_equal(seen, list(body = 7, header = 6, footer = 5))
})

test_that("with_font_sizes drops sizes a formatter (no dots) cannot accept", {
  # rec_fmt only knows body_font_size and has no `...`: footer must be dropped,
  # not passed through (which would raise an 'unused argument' error).
  seen <- NA
  rec_fmt <- function(ft, body_font_size = NA) {
    seen <<- body_font_size
    ft
  }
  ft <- flextable::flextable(head(iris))
  expect_silent(
    out <- with_font_sizes(rec_fmt, body_font_size = 8, footer_font_size = 5)(ft)
  )
  expect_s3_class(out, "flextable")
  expect_equal(seen, 8)
})

test_that("with_font_sizes only injects the sizes that are supplied", {
  seen <- list()
  rec_fmt <- function(ft, body_font_size = "unset", footer_font_size = "unset", ...) {
    seen <<- list(body = body_font_size, footer = footer_font_size)
    ft
  }
  ft <- flextable::flextable(head(iris))
  with_font_sizes(rec_fmt, body_font_size = 9)(ft)
  expect_equal(seen$body, 9)
  expect_identical(seen$footer, "unset") # left to the formatter's own default
})

test_that("with_font_sizes forwards non-font arguments", {
  seen <- list()
  rec_fmt <- function(ft, marker = NULL, body_font_size = NULL, ...) {
    seen <<- list(marker = marker, body = body_font_size)
    ft
  }
  ft <- flextable::flextable(head(iris))
  with_font_sizes(rec_fmt, body_font_size = 8)(ft, marker = "kept")

  expect_equal(seen, list(marker = "kept", body = 8))
})

test_that("built-in formatters accept footer_font_size", {
  ft <- flextable::flextable(head(iris))
  expect_s3_class(autoslider_format(ft, footer_font_size = 6), "flextable")
  expect_s3_class(black_format_tb(ft, footer_font_size = 6), "flextable")
})

test_that("Confidential footnote defaults to 8 pt on the decor = FALSE path", {
  data <- head(iris, 3)
  outfile <- withr::local_tempfile(fileext = ".pptx")
  generate_slides(
    data,
    outfile = outfile,
    col_width = rep(1, ncol(data))
  )

  expect_equal(pptx_run_sizes(outfile, "Confidential and for internal use only"), 800L)
})

test_that("explicit footer_font_size is honoured on the decor = FALSE path", {
  data <- head(iris, 3)
  outfile <- withr::local_tempfile(fileext = ".pptx")
  generate_slides(
    data,
    outfile = outfile,
    col_width = rep(1, ncol(data)),
    font_size = list(footer = 6)
  )

  expect_equal(pptx_run_sizes(outfile, "Confidential and for internal use only"), 600L)
})

test_that("footer_font_size falls back to body size", {
  data <- head(iris, 3)
  outfile <- withr::local_tempfile(fileext = ".pptx")
  generate_slides(
    data,
    outfile = outfile,
    col_width = rep(1, ncol(data)),
    font_size = list(body = 7)
  )

  expect_equal(pptx_run_sizes(outfile, "Confidential and for internal use only"), 700L)
})

test_that("Confidential footnote defaults to 8 pt on the decorated path", {
  skip_if_not_installed("filters")

  out <- t_dm_slide(adsl, "TRT01A", c("SEX", "AGE")) |>
    decorate(
      titles = "Demographics",
      footnotes = "Confidential and for internal use only"
    )

  outfile <- withr::local_tempfile(fileext = ".pptx")
  generate_slides(list(out), outfile = outfile)

  expect_equal(pptx_run_sizes(outfile, "Confidential and for internal use only"), 800L)
})

test_that("footnote separator matches footer_font_size on the decor = FALSE path", {
  data <- head(iris, 3)
  outfile <- withr::local_tempfile(fileext = ".pptx")
  generate_slides(
    data,
    outfile = outfile,
    col_width = rep(1, ncol(data)),
    font_size = list(footer = 6)
  )

  # flextable adds the inline "; " separator as its own run; it must not fall
  # back to the table default size next to the 6 pt note.
  expect_equal(pptx_run_sizes(outfile, "<a:t>; </a:t>"), 600L)
})

test_that("footnote separator matches footer_font_size on the decorated path", {
  skip_if_not_installed("filters")

  out <- t_dm_slide(adsl, "TRT01A", c("SEX", "AGE")) |>
    decorate(titles = "Demographics", footnotes = "Source: ADSL")

  outfile <- withr::local_tempfile(fileext = ".pptx")
  generate_slides(list(out), outfile = outfile, font_size = list(footer = 6))

  expect_equal(unique(pptx_run_sizes(outfile, "<a:t>; </a:t>")), 600L)
  expect_equal(unique(pptx_run_sizes(outfile, "Source: ADSL")), 600L)
})

test_that("generate_slides honours a per-slide font_size block from the spec", {
  skip_if_not_installed("filters")

  out <- t_dm_slide(adsl, "TRT01A", c("SEX", "AGE")) |>
    decorate(titles = "Demographics", footnotes = "footnote")
  # emulate what generate_outputs()/decorate_outputs() attach
  attr(out, "spec") <- list(
    table_format = black_format_tb,
    font_size = list(body = 6, header = 6, footer = 5)
  )

  outfile <- withr::local_tempfile(fileext = ".pptx")
  expect_no_error(generate_slides(list(out), outfile = outfile))
  expect_true(file.exists(outfile))
  expect_equal(pptx_run_sizes(outfile, "footnote"), 500L)
})

test_that("generate_slides deck-wide font_size default works without a spec", {
  skip_if_not_installed("filters")

  out <- t_dm_slide(adsl, "TRT01A", c("SEX", "AGE")) |>
    decorate(titles = "Demographics", footnotes = "footnote")

  outfile <- withr::local_tempfile(fileext = ".pptx")
  expect_no_error(
    generate_slides(
      list(out),
      outfile = outfile,
      table_format = black_format_tb,
      font_size = list(body = 7, header = 7, footer = 6)
    )
  )
  expect_true(file.exists(outfile))
  expect_equal(pptx_run_sizes(outfile, "footnote"), 600L)
})
