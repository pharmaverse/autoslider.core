test_that("Test listing creation of l_vs_slide (Vital Signs Listing)", {
  library(dplyr)
  library(rlistings)
  adsl <- eg_adsl
  advs <- eg_advs %>% filter(SUBJID %in% c("id-236", "id-65", "id-93"))

  expect_snapshot(l_vs_slide(adsl = adsl, advs = advs, trt_var = "TRT01A"))
})

test_that("l_vs_slide works without a treatment variable", {
  library(dplyr)
  library(rlistings)
  adsl <- eg_adsl
  advs <- eg_advs %>% filter(SUBJID %in% c("id-236", "id-65", "id-93"))

  expect_snapshot(l_vs_slide(adsl = adsl, advs = advs, trt_var = NULL))
})

test_that("l_vs_slide is generated correctly from the spec.yml", {
  testthat::skip_if_not_installed("filters")

  filters::load_filters(
    file.path(system.file(package = "autoslider.core"), "filters.yml"),
    overwrite = TRUE
  )

  spec_file <- file.path(system.file(package = "autoslider.core"), "spec.yml")

  outputs <- spec_file %>%
    read_spec() %>%
    filter_spec(program == "l_vs_slide") %>%
    generate_outputs(datasets = testdata)

  expect_snapshot(outputs)
})
