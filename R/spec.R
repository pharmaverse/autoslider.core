#' Read yaml spec file
#'
#' Read yaml spec file and split according to filter lists
#'
#' @param spec_file `character`. Path to a yaml spec file
#' @param metadata Metadata of study
#'
#' @return
#' An object of class `spec` which is a `list` where each element corresponds
#' to one output, e.g. `t_dm_IT`.
#'
#' @author
#' - Liming Li (`Lil128`)
#' - Thomas Neitmann (`neitmant`)
#' - Joe Zhu
#'
#' @export
#'
#' @examples
#' spec_file <- system.file("spec.yml", package = "autoslider.core")
#'
#' ## Take a look at the 'raw' content of the spec file
#' cat(readLines(spec_file)[1:24], sep = "\n")
#'
#' ## This is how it looks once read into R
#' spec <- read_spec(spec_file)
#' spec[1:3]
#'
read_spec <- function(spec_file = "spec.yml",
                      metadata = NULL) {
  spec <- yaml::read_yaml(spec_file, eval.expr = TRUE)
  spec_obj <- check_and_flattern_suffix(spec, metadata = metadata)
  as_spec(spec_obj)
}

#' Flatten spec entries with multiple suffixes
#'
#' @description
#' Checks each entry of a raw spec (as read from a yaml file). When an entry's
#' `suffix` field is a list/vector of more than one value, the entry is
#' flattened into several entries that share the same `program`, `titles`,
#' `footnotes`, `args`, etc., differing only in their (scalar) `suffix`.
#' Optional `metadata` is appended to each resulting entry.
#'
#' @param spec A `list` of raw spec entries as returned by [yaml::read_yaml()].
#' @param metadata Metadata of study, appended to each flattened entry.
#'
#' @return
#' A flat `list` of spec entries, each with a single `suffix` value.
#'
#' @noRd
check_and_flattern_suffix <- function(spec, metadata = NULL) {
  ret <- lapply(spec, function(s) {
    lapply(s$suffix, function(su) {
      entry <- s
      entry$suffix <- su
      c(entry, metadata)
    })
  })
  unlist(ret, recursive = FALSE)
}

#' validate spec file
#' @description not implemented yet
#' @param spec specification
#' @noRd
validate_spec <- function(spec) {
  message <- NULL
  if (is.null(spec$dataset)) {
    message <- c(message, "Spec must not assign dataset argument!")
  }
  if (is.null(spec$func)) {
    message <- c(message, "Spec must include func argument!")
  }
  if (is.null(spec$outpath)) {
    message <- c(message, "Spec must include outpath argument!")
  }
}

#' Filter a spec object
#'
#' @param spec A `spec` object as returned by `read_spec()`
#' @param filter_expr A `logical` expression indicating outputs to keep
#' @param verbose Should a message about the number of outputs matching
#'        `filter_spec` be printed? Defaults to `TRUE`.
#'
#' @return
#' A `spec` object containing only the outputs matching `filter_expr`
#'
#' @author Thomas Neitmann (`neitmant`)
#'
#' @export
#'
#' @examples
#' library(dplyr)
#' spec_file <- system.file("spec.yml", package = "autoslider.core")
#' spec <- spec_file %>% read_spec()
#'
#' ## Keep only the t_dm_IT output
#' filter_spec(spec, output == "t_dm_IT")
#'
#' ## Same as above but more verbose
#' filter_spec(spec, program == "t_dm" && suffix == "IT")
#'
#' ## Keep all t_ae outputs
#' filter_spec(spec, program == "t_ae")
#'
#' ## Keep all output run on safety population
#' filter_spec(spec, "SE" %in% suffix)
#'
#' ## Keep t_dm_CHN_IT and t_dm_CHN_SE
#' filter_spec(spec, program == "t_dm" && suffix %in% c("CHN_IT", "CHN_SE"))
#'
#' ## Keep all tables
#' filter_spec(spec, grepl("^t_", program))
#'
filter_spec <- function(spec, filter_expr, verbose = TRUE) {
  if (is.character(substitute(filter_expr))) {
    warn_about_legacy_filtering(filter_expr)
    condition <- bquote(output == .(filter_expr))
  } else {
    condition <- substitute(filter_expr)
  }
  stopifnot(is_spec(spec), is.language(condition), is.logical(verbose))
  vars <- all.vars(condition)

  filtered_spec <- Filter(function(output) {
    assert_exists_in_spec_or_calling_env(vars, output)
    p <- eval(condition, envir = output)
    assert_is_valid_filter_result(p)
    p
  }, spec)

  if (verbose) {
    log_number_of_matched_records(spec, filtered_spec, condition)
  }

  as_spec(filtered_spec)
}

is_spec <- function(x) {
  "spec" %in% class(x)
}

as_spec <- function(x) {
  spec <- lapply(x, function(elem) {
    if (is.null(elem$suffix)) {
      elem$suffix <- ""
    }

    if (elem$suffix == "") {
      elem$output <- elem$program
    } else {
      elem$output <- paste(elem$program, elem$suffix, sep = "_")
    }

    if (is.null(elem$paper)) {
      elem$paper <- default_paper_size(elem$program)
    } else if (elem$paper == "a4r") {
      warn_about_legacy_paper_size("a4r", "L11")
      elem$paper <- "L11"
    } else if (elem$paper == "a4") {
      warn_about_legacy_paper_size("a4", "P11")
      elem$paper <- "P11"
    } else {
      validate_paper_size(elem$paper)
    }

    elem
  })

  structure(
    .Data = spec,
    names = map_chr(spec, `[[`, "output"),
    class = union("spec", class(x))
  )
}
