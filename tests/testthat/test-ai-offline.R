# Offline coverage for R/ai.R.
# These tests deliberately avoid any LLM/network call (no ollama, no API key),
# so they run on CI (unlike test_ai.R which is skip_on_ci) and cover the pure
# helpers plus the early-return branches of get_ai_notes / get_ellmer_chat.

test_that("get_system_prompt returns its text", {
  expect_equal(autoslider.core:::get_system_prompt(), "you are a Clinical data scientist expert")
  expect_equal(autoslider.core:::get_system_prompt("custom"), "custom")
})

test_that("get_deepseek_key / get_portkey_key read a key file", {
  key_file <- withr::local_tempfile()
  writeLines("my-secret-key", key_file)
  expect_equal(autoslider.core:::get_deepseek_key(key_file), "my-secret-key")
  expect_equal(autoslider.core:::get_portkey_key(key_file), "my-secret-key")
})

test_that("get_prompt_list reads the packaged prompt.yml as a spec", {
  prompt_list <- get_prompt_list(system.file("prompt.yml", package = "autoslider.core"))
  expect_s3_class(prompt_list, "spec")
  expect_true(length(prompt_list) >= 1)
  # names are taken from each entry's `output` field
  expect_true(all(nzchar(names(prompt_list))))
})

test_that("integrate_prompt substitutes {table_text} with the table content", {
  adsl <- eg_adsl %>%
    dplyr::mutate(TRT01A = factor(TRT01A, levels = c("A: Drug X", "B: Placebo", "C: Combination")))
  out <- t_dm_slide(adsl = adsl) %>% decorate(title = "Demographic table", footnote = "")

  result <- autoslider.core:::integrate_prompt("PREFIX {table_text} SUFFIX", out@tbl)
  expect_type(result, "character")
  expect_true(grepl("PREFIX", result))
  expect_true(grepl("SUFFIX", result))
  # the {table_text} placeholder must be gone (replaced by the exported table)
  expect_false(grepl("\\{table_text\\}", result))
})

test_that("get_ellmer_chat returns NULL for an unknown platform", {
  expect_null(get_ellmer_chat(platform = "not-a-real-platform"))
})

test_that("get_ai_notes passes autoslider_error outputs through untouched", {
  err <- autoslider_error(
    "boom",
    spec = list(program = "t_dm_slide", suffix = "FAS", output = "err_out"),
    step = "generate"
  )
  # platform "none" makes get_ellmer_chat return NULL; the error branch returns
  # early, so no chat is ever invoked.
  res <- get_ai_notes(
    list(err_out = err),
    prompt_list = list(),
    platform = "none", base_url = "x", api_key = "x", model = "m"
  )
  expect_true(is(res[[1]], "autoslider_error"))
  expect_equal(names(res), "err_out")
})

test_that("get_ai_notes skips outputs whose name is not in the prompt list", {
  adsl <- eg_adsl %>%
    dplyr::mutate(TRT01A = factor(TRT01A, levels = c("A: Drug X", "B: Placebo", "C: Combination")))
  out <- t_dm_slide(adsl = adsl) %>% decorate(title = "Demographic table", footnote = "")
  outputs <- list(some_output = out)

  # empty prompt_list => no name matches => no chat call, outputs returned as-is
  res <- get_ai_notes(
    outputs,
    prompt_list = list(),
    platform = "none", base_url = "x", api_key = "x", model = "m"
  )
  expect_equal(names(res), names(outputs))
  expect_identical(res[["some_output"]], out)
})
