# Tests demonstrating that decorate() dispatches correctly through the
# gtsummary S3 class hierarchy, including the tbl_roche_summary subclass
# used in NEST 2 environments.

tbl <- gtsummary::tbl_summary(
  trial[, c("age", "trt")],
  by = trt
)

test_that("decorate dispatches to decorate.gtsummary for plain tbl_summary", {
  expect_true(inherits(tbl, "tbl_summary"))
  expect_true(inherits(tbl, "gtsummary"))

  result <- decorate(tbl, titles = "Demographics", footnotes = "Source: trial")

  expect_true(inherits(result, "dgtsummary"))
  expect_true(inherits(result, "gtsummary"))
  expect_equal(attr(result, "titles"), "Demographics")
  expect_equal(attr(result, "footnotes"), "Source: trial")
})

test_that("decorate dispatches to decorate.gtsummary for tbl_roche_summary class", {
  # Simulate NEST 2 class hierarchy: tbl_roche_summary extends tbl_summary extends gtsummary
  tbl_roche <- tbl
  class(tbl_roche) <- c("tbl_roche_summary", class(tbl))

  expect_true(inherits(tbl_roche, "tbl_roche_summary"))
  expect_true(inherits(tbl_roche, "tbl_summary"))
  expect_true(inherits(tbl_roche, "gtsummary"))

  # S3 dispatch: tbl_roche_summary -> tbl_summary -> gtsummary (found: decorate.gtsummary)
  result <- expect_no_error(
    decorate(tbl_roche, titles = "Roche Demographics", footnotes = "Note: simulated class")
  )

  expect_true(inherits(result, "dgtsummary"))
  expect_true(inherits(result, "tbl_roche_summary"))
  expect_true(inherits(result, "tbl_summary"))
  expect_true(inherits(result, "gtsummary"))
  expect_equal(attr(result, "titles"), "Roche Demographics")
})

test_that("to_flextable returns structured list with title for dgtsummary", {
  tbl_roche <- tbl
  class(tbl_roche) <- c("tbl_roche_summary", class(tbl))

  decorated <- decorate(tbl_roche,
    titles = "Roche Demographics",
    footnotes = "Source: trial data"
  )

  result <- expect_no_error(to_flextable(decorated))

  expect_named(result, c("ft", "header", "footnotes"))
  expect_equal(result$header, "Roche Demographics")
  expect_equal(result$footnotes, "Source: trial data")
  expect_s3_class(result$ft, "flextable")
})

test_that("gt_t_dm_slide output can be decorated", {
  result <- gt_t_dm_slide(eg_adsl, arm = "TRT01P", vars = c("SEX", "AGE"))

  expect_true(inherits(result, "gtsummary"))

  decorated <- expect_no_error(
    decorate(result, titles = "Demographic Table", footnotes = "Source: ADSL")
  )

  expect_true(inherits(decorated, "dgtsummary"))
})
