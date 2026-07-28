#' decorate generic
#' @param x object to decorate
#' @param ... additional arguments passed to methods
#' @export
decorate <- function(x, ...) {
  UseMethod("decorate")
}

#' default method to decorate
#' @param x object to decorate
#' @param ... additional arguments. not used.
#' @return No return value, called for side effects
#' @export
decorate.default <- function(x, ...) {
  stop("default decorate function does not exist")
}

#' decorate method for autoslider_error class
#' @param x object to decorate
#' @param ... additional arguments. not used.
#' @return No return value, called for side effects
#' @export
decorate.autoslider_error <- function(x, ...) {
  x
}

#' Decorate TableTree
#'
#' @param x A VTableTree object representing the data to be decorated.
#' @param titles Title to be added to the table.
#' @param footnotes Footnote to be added to the table
#' @param paper Orientation and font size as string, e.g. "P8"; "L11"
#' @param for_test `logic` CICD parameter
#' @param ... Additional arguments passed to the decoration function.
#' @return No return value, called for side effects
#' @method decorate VTableTree
#' @export
decorate.VTableTree <- function(x, titles = "", footnotes = "", paper = "P8", for_test = FALSE, ...) {
  width_set <- attr(x, "width")
  tmp_x <- formatters::matrix_form(x)

  if (is.null(width_set)) {
    width <- formatters::propose_column_widths(tmp_x)
  } else {
    width <- ifelse(is.na(width_set), formatters::propose_column_widths(tmp_x), width_set)
  }

  glued_title <- glue::glue(paste(titles, collapse = "\n"))
  main_title(x) <- glued_title

  git_fn <- git_footnote(for_test)
  glued_footnotes <- glue::glue(paste(c(footnotes, git_fn), collapse = "\n"))
  main_footer(x) <- glued_footnotes

  new(
    "dVTableTree",
    tbl = x,
    titles = glued_title,
    footnotes = footnotes,
    usernotes = "",
    paper = paper,
    width = width
  )
}


#' Decorate ggplot object
#'
#' @param x An object to decorate
#' @param titles Plot titles
#' @param footnotes Plot footnotes
#' @param paper Paper size, by default "L11"
#' @param for_test `logic` CICD parameter
#' @param ... additional arguments. not used.
#' @return No return value, called for side effects
#' @export
#' @details
#' The paper default paper size, `L11`, indicate that the fontsize is 11.
#' The fontsize of the footnotes, is the fontsize of the titles minus 2.
decorate.ggplot <- function(x, titles = "", footnotes = "", paper = "L11", for_test = FALSE, ...) {
  glued_title <- glue::glue(paste(titles, collapse = "\n"))
  # main_title(x) <- glued_title

  git_fn <- git_footnote(for_test)
  glued_footnotes <- glue::glue(paste(c(footnotes, git_fn), collapse = "\n"))
  # main_footer(x) <- glued_footnotes

  ret <- list(
    grob = ggplot2::ggplotGrob(x),
    titles = glued_title,
    footnotes = footnotes,
    usernotes = "",
    paper = paper,
    for_test = for_test
  )
  class(ret) <- "decoratedGrob"
  ret
}


#' decorate listing
#'
#' @param x A listing_df object representing the data to be decorated.
#' @param titles Title to be added to the table.
#' @param footnotes Footnote to be added to the table
#' @param paper Orientation and font size as string, e.g. "P8"; "L11"
#' @param for_test `logic` CICD parameter
#' @param ... Additional arguments. not used.
#' @return No return value, called for side effects
#' @method decorate listing_df
#' @export
decorate.listing_df <- function(x, titles = "", footnotes = "", paper = "P8", for_test = FALSE, ...) {
  width_set <- attr(x, "width")
  tmp_x <- formatters::matrix_form(x)

  if (is.null(width_set)) {
    width <- formatters::propose_column_widths(tmp_x)
  } else {
    width <- ifelse(is.na(width_set), formatters::propose_column_widths(tmp_x), width_set)
  }

  glued_title <- glue::glue(paste(titles, collapse = "\n"))
  main_title(x) <- glued_title

  git_fn <- git_footnote(for_test)
  glued_footnotes <- glue::glue(paste(c(footnotes, git_fn), collapse = "\n"))
  main_footer(x) <- glued_footnotes
  new(
    "dlisting",
    lst = x,
    titles = glued_title,
    footnotes = footnotes,
    usernotes = "",
    paper = paper,
    width = width
  )
}




#' decorate grob
#' @param x object to decorate
#' @param titles graph titles
#' @param footnotes graph footnotes
#' @param paper paper size. default is "L8".
#' @param for_test `logic` CICD parameter
#' @param ... Additional arguments. not used.
#' @return No return value, called for side effects
#' @details
#' The paper default paper size, `L11`, indicate that the fontsize is 11.
#' The fontsize of the footnotes, is the fontsize of the titles minus 2.
#' @export
#'
decorate.grob <-
  function(x, titles = "", footnotes = "", paper = "L11", for_test = FALSE, ...) {
    size <- fs(paper)
    grob <- tern::decorate_grob(
      grob = x,
      titles = glue::glue(paste(titles, collapse = "\n")),
      footnotes = c(glue::glue(paste(footnotes, collapse = "\n")), git_footnote(for_test), datetime()),
      border = FALSE,
      gp_titles = gpar(fontsize = size$fontsize),
      gp_footnotes = gpar(fontsize = size$fontsize - 2)
    )
    attr(grob, "paper") <- ifelse(size$orientation == "P", "a4", "a4r")
    grob
  }

#' decorate gtsummary
#'
#' @param x gtsummary object to decorate
#' @param titles graph titles
#' @param footnotes graph footnotes
#' @param paper paper size. default is "L8".
#' @param for_test `logic` CICD parameter
#' @param ... Additional arguments. not used.
#' @return No return value, called for side effects
#' @details
#' The paper default paper size, `L11`, indicate that the fontsize is 11.
#' The fontsize of the footnotes, is the fontsize of the titles minus 2.#'
#' @method decorate gtsummary
#' @export
decorate.gtsummary <-
  function(x, titles = "", footnotes = "", paper = "L11", for_test = FALSE, ...) {
    size <- fs(paper)
    glued_title <- glue::glue(paste(titles, collapse = "\n"))
    x <- x |> modify_caption(caption = "")
    structure(
      .Data = x,
      titles = glued_title,
      paper = paper,
      class = union("dgtsummary", class(x))
    )
  }
# )

#' decorate list of grobs
#' @param x object to decorate
#' @param titles graph titles
#' @param footnotes graph footnotes
#' @param paper paper size. default is "L11".
#' @param for_test `logic` CICD parameter
#' @param ... additional arguments. not used
#' @details
#' The paper default paper size, `L11`, indicate that the fontsize is 11.
#' The fontsize of the footnotes, is the fontsize of the titles minus 2.
#' @return No return value, called for side effects
#' @export
#'
decorate.list <-
  function(x, titles, footnotes, paper = "L11", for_test = FALSE, ...) {
    stopifnot(all(vapply(x, function(x) {
      "grob" %in% class(x) || "ggplot" %in% class(x)
    }, FUN.VALUE = TRUE)))
    size <- fs(paper)
    x <- lapply(x, function(g) {
      ret <- g
      if ("ggplot" %in% class(g)) {
        ret <- ggplot2::ggplotGrob(g)
      }
      ret
    })
    grobs <- decorate_grob_set(
      grobs = x,
      titles = glue::glue(paste(titles, collapse = "\n")),
      footnotes = c(glue::glue(paste(footnotes, collapse = "\n")), git_footnote(for_test), datetime()),
      border = FALSE,
      gp_titles = gpar(fontsize = size$fontsize),
      gp_footnotes = gpar(fontsize = size$fontsize - 2)
    )
    structure(
      .Data = grobs,
      paper = ifelse(size$orientation == "P", "a4", "a4r"),
      class = union("decoratedGrobSet", class(grobs))
    )
  }

#' Decorate outputs
#'
#' Decorate outputs with titles and footnotes
#'
#' @param outputs `list` of output objects as created by `generate_outputs`
#' @param generic_title `character` vector of titles
#' @param generic_footnote `character` vector of footnotes
#' @param version_label `character`. A version label to be added to the title.
#' @param for_test `logic` CICD parameter
#' @return No return value, called for side effects
#' @details
#' `generic_title` and `generic_footnote` will be added to *all* outputs. The use
#' case is to add information such as protocol number and snapshot date defined
#' in a central place (e.g. metadata.yml) to *every* output.
#'
#' `version_label` must be either `"DRAFT"`, `"APPROVED"` or `NULL`. By default,
#' when outputs are created on the master branch it is set to `NULL`, i.e. no
#' version label will be displayed. Otherwise `"DRAFT"` will be added. To add
#' `"APPROVED"` to the title you will need to explicitly set `version_label = "APPROVED"`.
#'
#' @export
decorate_outputs <- function(outputs,
                             generic_title = NULL,
                             generic_footnote = "Confidential and for internal use only",
                             version_label = get_version_label_output(),
                             for_test = FALSE) {
  assert_is_valid_version_label(version_label)

  lapply(outputs, function(output) {
    if (inherits(output, "autoslider_error")) {
      return(output)
    }

    spec <- attr(output, "spec")

    filter_titles <- function(...) {
      if (length(c(...)) == 0 || "all" %in% c(...)) {
        r <- vapply(
          filters::get_filters(spec$suffix),
          FUN = `[[`,
          FUN.VALUE = character(1L),
          "title"
        )
      } else {
        r <- vapply(
          Filter(
            f = function(x) any(x$target %in% toupper(c(...))),
            x = filters::get_filters(spec$suffix)
          ),
          FUN = `[[`,
          FUN.VALUE = character(1L),
          "title"
        )
      }
      paste(r, collapse = ", ")
    }

    pattern <- "\\{filter_titles\\(((\"\\w+\")(,\\s*\"\\w+\")*){0,1}\\)\\}"
    if (grepl(pattern, spec$titles)) {
      m <- regmatches(spec$titles, regexpr(pattern, spec$titles))
      full_title <- paste(
        version_label,
        sub(pattern = pattern, eval(parse(text = m)), spec$titles)
      )
    } else {
      full_title <- paste(
        paste(version_label, spec$titles),
        filter_titles("ADSL"),
        sep = ", "
      )
    }

    if ("ggplot" %in% class(output)) {
      decorate.ggplot(output, titles = full_title)
    } else if ("grob" %in% class(output)) {
      decorate.grob(output)
    } else {
      structure(
        .Data = decorate(
          x = output,
          title = c(full_title, generic_title),
          footnotes = c(spec$footnotes, generic_footnote),
          paper = spec$paper,
          for_test = for_test
        ),
        spec = modifyList(spec, list(titles = glue::glue(paste0(c(full_title, generic_title), collapse = "\n"))))
      )
    }
  })
}

#' Print decorated grob
#'
#' @param x An object of class `decoratedGrob`
#' @param ... not used.
#' @return No return value, called for side effects
#' @export
print.decoratedGrob <- function(x, ...) {
  grid::grid.newpage()
  grid::grid.draw(x)
}

#' Print decorated grob set
#'
#' @param x An object of class `decoratedGrobSet`
#' @param ... not used.
#' @return No return value, called for side effects
#' @export
print.decoratedGrobSet <- function(x, ...) {
  for (plot in x) {
    grid::grid.newpage()
    grid::grid.draw(plot)
  }
}
