testthat::skip_if_not_installed("filters")

filters::load_filters(
  yaml_file = system.file("filters.yml", package = "autoslider.core"),
  overwrite = TRUE
)

# A spec entry whose suffix ("SE") is a known filter, reused with test programs.
error_spec <- read_spec(system.file("spec.yml", package = "autoslider.core"))$t_aesi_slide_SE

test_that("a failing program becomes an autoslider_error carrying the real message", {
  # tidyselect/rlang errors leave e$message empty; the text lives in the bullets.
  fails_with_tidyselect <- function(adsl) dplyr::select(adsl, PATIENT_NUM)
  assign("fails_with_tidyselect", fails_with_tidyselect, envir = globalenv())
  withr::defer(rm("fails_with_tidyselect", envir = globalenv()))

  out <- generate_output("fails_with_tidyselect", list(adsl = eg_adsl), error_spec, verbose_level = 0)

  expect_s3_class(out, "autoslider_error")
  expect_match(out, "Can't select columns that don't exist", fixed = TRUE)
  expect_match(out, "PATIENT_NUM", fixed = TRUE)
  expect_identical(attr(out, "step"), "user program")
})

test_that("an error with no message at all is still caught", {
  fails_silently <- function(adsl) stop(structure(class = c("odd_error", "error", "condition"), list(message = "")))
  assign("fails_silently", fails_silently, envir = globalenv())
  withr::defer(rm("fails_silently", envir = globalenv()))

  out <- generate_output("fails_silently", list(adsl = eg_adsl), error_spec, verbose_level = 0)

  expect_s3_class(out, "autoslider_error")
  expect_match(out, "Error of class `odd_error` with no message.", fixed = TRUE)
})

test_that("one failing program does not stop generate_outputs", {
  fails_with_tidyselect <- function(adsl) dplyr::select(adsl, PATIENT_NUM)
  assign("fails_with_tidyselect", fails_with_tidyselect, envir = globalenv())
  withr::defer(rm("fails_with_tidyselect", envir = globalenv()))

  spec <- read_spec(system.file("spec.yml", package = "autoslider.core"))
  spec <- filter_spec(spec, output %in% c("t_dm_slide_FAS", "t_aesi_slide_SE"))
  spec$t_aesi_slide_SE$program <- "fails_with_tidyselect"
  spec$t_aesi_slide_SE$args <- NULL

  adsl <- eg_adsl
  adsl$FASFL <- adsl$SAFFL
  outs <- generate_outputs(spec, datasets = list(adsl = adsl, adae = eg_adae), verbose_level = 0)

  # the shipped spec.yml has two t_dm_slide_FAS entries, so check by name
  expect_s3_class(outs[["t_aesi_slide_SE"]], "autoslider_error")
  dm <- outs[names(outs) == "t_dm_slide_FAS"]
  expect_gt(length(dm), 0)
  expect_false(any(vapply(dm, inherits, logical(1), "autoslider_error")))
})

test_that("generate_slides skips a single failed output instead of erroring", {
  err <- autoslider_error("Can't select columns that don't exist.", spec = error_spec, step = "user program")
  outfile <- withr::local_tempfile(fileext = ".pptx")

  expect_message(generate_slides(err, outfile = outfile), "Can't select columns that don't exist.", fixed = TRUE)
  # nothing is added beyond what the template already holds
  template <- system.file("theme/basic.pptx", package = "autoslider.core")
  expect_equal(length(officer::read_pptx(outfile)), length(officer::read_pptx(template)))
})
