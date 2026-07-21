#' Save an Output
#'
#' @param output Output object, e.g. an `rtable` or `grob`
#' @param file_name Full path of the new file *excluding* the extension
#' @param save_rds Saved as an `.rds` files
#' @details
#' Tables are saved as RDS file
#'
#' @return The input `object` invisibly
#' @export
#'
#' @examples
#' library(dplyr)
#' adsl <- eg_adsl %>%
#'   filter(SAFFL == "Y") %>%
#'   mutate(TRT01P = factor(TRT01P, levels = c("A: Drug X", "B: Placebo")))
#' output_dir <- tempdir()
#' t_dm_slide(adsl, "TRT01P", c("SEX", "AGE", "RACE", "ETHNIC", "COUNTRY")) %>%
#'   decorate(
#'     title = "Demographic table",
#'     footnote = ""
#'   ) %>%
#'   save_output(
#'     file_name = file.path(output_dir, "t_dm_SE"),
#'     save_rds = TRUE
#'   )
#'
setGeneric("save_output", function(output, file_name, save_rds) {
  standardGeneric("save_output")
})

#' @rdname save_output
save_output <- function(output, file_name, save_rds = TRUE) {
  UseMethod("save_output")
}

#' @rdname save_output
#' @return No return value, called for side effects
#' @export
save_output.autoslider_error <- function(output,
                                         file_name,
                                         save_rds = TRUE) {
  output
}

#' @rdname save_output
#' @aliases save_output, dVTableTree, dVTableTree-method
setMethod("save_output", "dVTableTree", save_output.dVTableTree <- function(output, file_name, save_rds = TRUE) {
  if (save_rds) {
    saveRDS(output, file = paste0(file_name, ".rds"))
  }

  invisible(output)
})

#' @rdname save_output
#' @return The input `object` invisibly
#' @export
save_output.decoratedGrob <- function(output,
                                      file_name,
                                      save_rds = TRUE) {
  if (save_rds) {
    saveRDS(output, file = paste0(file_name, ".rds"))
  }

  invisible(output)
}

#' @rdname save_output
#' @return The input `object` invisibly
#' @export
save_output.decoratedGrobSet <- function(output, file_name, save_rds = TRUE) {
  if (save_rds) {
    saveRDS(output, file = paste0(file_name, ".rds"))
  }

  invisible(output)
}


#' @rdname save_output
#' @return The input `object` invisibly
#' @export
save_output.dgtsummary <- function(output, file_name, save_rds = TRUE) {
  if (save_rds) {
    saveRDS(output, file = paste0(file_name, ".rds"))
  }

  invisible(output)
}

#' @rdname save_output
#' @return The input `object` invisibly
#' @export
save_output.dlisting <- function(output, file_name, save_rds = TRUE) {
  if (save_rds) {
    saveRDS(output, file = paste0(file_name, ".rds"))
  }

  invisible(output)
}


#' Save a list of outputs
#'
#' @param outputs `list` of outputs as created by `generate_outputs`
#' @param outfolder Folder in which to store the `outputs``
#' @param verbose_level Level of verbose information displayed.
#'        Default set to `1`.
#' @param save_rds Should the input `outputs` be saved as `.rds` files in
#'        in addition to `.out` or `.pdf` files? Defaults to `FALSE`.
#' @param generic_suffix generic suffix. must be length 1 character or NULL.
#' @export
#' @return The input `object` invisibly
#' @examplesIf require(filters)
#' ## As `save_outputs` is the last step in the pipeline we have to run
#' ## the 'whole machinery' in order to show its functionality.
#' library(dplyr, warn.conflicts = FALSE)
#'
#' data <- list(
#'   adsl = eg_adsl,
#'   adae = eg_adae,
#'   adtte = eg_adtte
#' )
#'
#' filters::load_filters(
#'   yaml_file = system.file("filters.yml", package = "autoslider.core"),
#'   overwrite = TRUE
#' )
#'
#' ## For this example the outputs will be saved in a temporary directory. In a
#' ## production run this should be the reporting event's 'output' folder instead.
#' output_dir <- tempdir()
#'
#' spec_file <- system.file("spec.yml", package = "autoslider.core")
#' read_spec(spec_file) %>%
#'   filter_spec(program == "t_dm_slide") %>%
#'   generate_outputs(datasets = data) %>%
#'   decorate_outputs() %>%
#'   save_outputs(outfolder = output_dir)
#'
save_outputs <- function(outputs,
                         outfolder = file.path("output"),
                         generic_suffix = NULL,
                         save_rds = TRUE,
                         verbose_level = 1) {
  stopifnot(is.list(outputs))

  if (!dir.exists(outfolder)) {
    dir.create(outfolder)
  }
  if (!is.null(generic_suffix)) {
    if (!(is.character(generic_suffix) & length(generic_suffix) == 1)) {
      stop("generic suffix must be length 1 character!")
    }
  }
  ret <- lapply(outputs, function(output) {
    spec <- attr(output, "spec")
    file_path <- file.path(outfolder, spec$output)
    file_path <- paste0(c(file_path, generic_suffix), collapse = "_")
    output <- save_output(
      output = output,
      file_name = file_path,
      save_rds = save_rds
    )

    if (verbose_level > 0) {
      if (inherits(output, "autoslider_error")) {
        cat_bullet(
          "Saving output ",
          attr(output, "spec")$output,
          " failed in step ",
          attr(output, "step"),
          " with error message: ",
          toString(output),
          bullet = "cross",
          bullet_col = "red"
        )
      } else {
        cat_bullet(
          "Output saved in path ",
          file_path,
          bullet = "tick",
          bullet_col = "green"
        )
      }
    }

    attr(output, "outpath") <- get_output_file_ext(output, file_path)
    output
  })

  if (verbose_level > 0) {
    total_number <- length(ret)
    fail_number <- sum(map_lgl(ret, is, class2 = "autoslider_error"))
    log_success_infomation(total_number - fail_number, fail_number)
  }

  ret
}


#' Generate slides from rds files
#' @param filenames List of file names
#' @param template Template file path
#' @param outfile Out file path
#' @return No return value, called for side effects
#'
#' @export
#' @examplesIf require(filters)
#' library(dplyr, warn.conflicts = FALSE)
#'
#' data <- list(
#'   adsl = eg_adsl,
#'   adae = eg_adae,
#'   adtte = eg_adtte
#' )
#'
#' filters::load_filters(
#'   yaml_file = system.file("filters.yml", package = "autoslider.core"),
#'   overwrite = TRUE
#' )
#'
#' ## For this example the outputs will be saved in a temporary directory. In a
#' ## production run this should be the reporting event's 'output' folder instead.
#' output_dir <- tempdir()
#'
#' spec_file <- system.file("spec.yml", package = "autoslider.core")
#' read_spec(spec_file) %>%
#'   filter_spec(program == "t_dm_slide") %>%
#'   generate_outputs(datasets = data) %>%
#'   decorate_outputs() %>%
#'   save_outputs(outfolder = output_dir)
#'
#' slides_from_rds(list.files(file.path(output_dir, "t_dm_slide_FAS.rds")))
slides_from_rds <- function(filenames, outfile = paste0(tempdir(), "/output.pptx"),
                            template = file.path(system.file(package = "autoslider.core"), "theme/basic.pptx")) {
  outputs <- lapply(filenames, readRDS)
  generate_slides(outputs, outfile, template)
}
