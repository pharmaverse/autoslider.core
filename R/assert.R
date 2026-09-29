abort <- function(...) {
  stop(..., call. = FALSE)
}

assert_is_character_scalar <- function(x) {
  if (length(x) != 1L || is.na(x) || !is.character(x) || x == "") {
    abort("`", deparse(substitute(x)), "` must be a character scalar.")
  }
}

assert_is_valid_version_label <- function(x) {
  if (!(x %in% c("DRAFT", "APPROVED") || is.null(x))) {
    abort("Version label must be 'DRAFT', 'APPROVED' or `NULL` but is '", x, "'.")
  }
}


assert_exists_in_spec_or_calling_env <- function(vars, output, env = parent.frame()) {
  exist_in_spec <- vars %in% names(output)
  # explicitly define env to use, better practice for testing
  exist_in_calling_env <- map_lgl(vars, exists, envir = env)

  non_existing_vars <- vars[!(exist_in_spec | exist_in_calling_env)]


  n <- length(non_existing_vars)
  if (n >= 1L) {
    err_msg <- sprintf(
      paste(
        "Cannot filter based upon the %s %s as %s not contained in",
        "`spec` or the surrounding environment."
      ),
      if (n == 1L) "variable" else "variables",
      enumerate(non_existing_vars),
      if (n == 1L) "it is" else "they are"
    )
    stop(err_msg, call. = FALSE)
  }
}

assert_is_valid_filter_result <- function(x) {
  if (length(x) != 1L || is.na(x) || !is.logical(x)) {
    stop(
      "`filter_expr` must evaluate to a logical scalar but returned `",
      deparse(x), "`.",
      call. = FALSE
    )
  }
}

assert_is_valid_pagination <- function(x, field, output = NULL) {
  # `is.finite()` covers NA, NaN and both infinities in one go, and `x %% 1`
  # avoids as.integer(), which turns a value beyond .Machine$integer.max into
  # NA and would land the comparison in `if (NA)` instead of reporting it.
  if (length(x) != 1L || !is.numeric(x) || !is.finite(x) || x < 1 || x %% 1 != 0) {
    abort(
      "`", field, "`",
      if (is.null(output)) "" else paste0(" in spec entry '", output, "'"),
      " must be a single positive whole number but is `", deparse(x), "`."
    )
  }
  x
}
