output_dir <- tempdir()

test_that("save an output", {
  output <- t_dm_slide(adsl = testdata$adsl) %>% decorate(title = "test title", footnote = "")
  testthat::expect_no_error(
    save_output(
      output,
      file_name = file.path(output_dir, "t_dm_output"),
      save_rds = TRUE
    )
  )
})


test_that("Test save_output (Save an Output)", {
  library(dplyr)
  adsl <- eg_adsl %>%
    mutate(TRT01A = factor(TRT01A, levels = c("A: Drug X", "B: Placebo")))
  adae <- eg_adae %>%
    mutate(TRT01A = factor(TRT01A, levels = c("A: Drug X", "B: Placebo")))
  adae$ATOXGR <- adae$AETOXGR

  expect_snapshot(print(t_ae_pt_slide(adsl, adae, "TRT01A", 2) %>%
    decorate(
      title = "Serious Adverse Events, Safety-Evaluable Patients",
      footnote = "",
      paper = "P8",
      for_test = TRUE
    ) %>%
    save_output(
      file_name = file.path(output_dir, "t_ae_SER_SE"),
      save_rds = TRUE
    )))

  expect_no_error(slides_from_rds(file.path(output_dir, "t_ae_SER_SE.rds")))
})


test_that("save an output", {
  output <- t_ds_slide(adsl = testdata$adsl) %>% decorate(title = "test title", footnote = "")
  testthat::expect_no_error(
    save_output(
      output,
      file_name = file.path(output_dir, "t_ds_output"),
      save_rds = TRUE
    )
  )
  expect_no_error(slides_from_rds(file.path(output_dir, "t_ds_output.rds")))
})


# Coverage for save_outputs() (the plural, list-level saver). The only other
# test exercising it (test-srep_outputs.R) is gated on rsvg because it also
# renders figures; this one uses a table-only spec so it runs even without rsvg.
test_that("save_outputs writes rds files for a list of outputs", {
  testthat::skip_if_not_installed("filters")

  filters::load_filters(
    system.file("filters.yml", package = "autoslider.core"),
    overwrite = TRUE
  )

  outputs <- read_spec(system.file("spec.yml", package = "autoslider.core")) %>%
    filter_spec(program == "t_dm_slide") %>%
    generate_outputs(datasets = testdata) %>%
    decorate_outputs(version_label = NULL, for_test = TRUE)

  save_folder <- withr::local_tempdir()
  expect_no_error(
    saved <- save_outputs(outputs, outfolder = save_folder, save_rds = TRUE, verbose_level = 1)
  )
  # an .rds file is produced for the (first) output based on its spec$output name
  out_name <- attr(outputs[[1]], "spec")$output
  expect_true(file.exists(file.path(save_folder, paste0(out_name, ".rds"))))
  # outpath attribute is attached to each returned output
  expect_false(is.null(attr(saved[[1]], "outpath")))
})

test_that("save_outputs errors on a multi-element generic_suffix", {
  testthat::skip_if_not_installed("filters")

  filters::load_filters(
    system.file("filters.yml", package = "autoslider.core"),
    overwrite = TRUE
  )

  outputs <- read_spec(system.file("spec.yml", package = "autoslider.core")) %>%
    filter_spec(program == "t_dm_slide") %>%
    generate_outputs(datasets = testdata) %>%
    decorate_outputs(version_label = NULL, for_test = TRUE)

  save_folder <- withr::local_tempdir()
  expect_error(
    save_outputs(outputs, outfolder = save_folder, generic_suffix = c("a", "b")),
    "generic suffix must be length 1 character"
  )
})

test_that("save_outputs handles autoslider_error outputs gracefully", {
  err <- autoslider_error(
    "boom",
    spec = list(program = "t_dm_slide", suffix = "FAS", output = "err_out"),
    step = "generate"
  )
  save_folder <- withr::local_tempdir()
  expect_no_error(
    saved <- save_outputs(list(err_out = err), outfolder = save_folder, verbose_level = 1)
  )
  expect_true(is(saved[[1]], "autoslider_error"))
})
