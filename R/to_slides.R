#' generate slides based on output
#'
#' @param outputs List of output
#' @param template Template file path
#' @param outfile Out file path
#' @param fig_width figure width in inch
#' @param fig_height figure height in inch
#' @param t_lpp An integer specifying the table lines per page \cr
#'    Specify this optional argument to modify the length of all of the table displays
#' @param t_cpp An integer specifying the table columns per page\cr
#'    Specify this optional argument to modify the width of all of the table displays
#' @param l_lpp An integer specifying the listing lines per page\cr
#'    Specify this optional argument to modify the length of all of the listings display
#' @param l_cpp An integer specifying the listing columns per page\cr
#'    Specify this optional argument to modify the width of all of the listings display
#' @param fig_editable whether we want the figure to be editable in pptx viewers, defaults to FALSE
#' @param ... arguments passed to program
#' @return No return value, called for side effects
#' @export
#' @examplesIf require(filters)
#'
#' # Example 1. When applying to the whole pipeline
#' library(dplyr)
#' data <- list(
#'   adsl = eg_adsl %>% dplyr::mutate(FASFL = SAFFL),
#'   adae = eg_adae
#' )
#'
#'
#' filters::load_filters(
#'   yaml_file = system.file("filters.yml", package = "autoslider.core"),
#'   overwrite = TRUE
#' )
#'
#'
#' spec_file <- system.file("spec.yml", package = "autoslider.core")
#' spec_file %>%
#'   read_spec() %>%
#'   filter_spec(program %in% c("t_dm_slide")) %>%
#'   generate_outputs(datasets = data) %>%
#'   decorate_outputs() %>%
#'   generate_slides()
#'
#' # Example 2. When applying to an rtable object or an rlisting object
#' adsl <- eg_adsl
#' t_dm_slide(adsl, "TRT01P", c("SEX", "AGE")) %>%
#'   generate_slides()
generate_slides <- function(outputs,
                            outfile = paste0(tempdir(), "/output.pptx"),
                            template = file.path(system.file(package = "autoslider.core"), "theme/basic.pptx"),
                            fig_width = 9, fig_height = 5, t_lpp = 20, t_cpp = 200,
                            l_lpp = 20, l_cpp = 150, fig_editable = FALSE, ...) {
  if (any(c(
    inherits(outputs, "VTableTree"),
    inherits(outputs, "listing_df")
  ))) {
    if (inherits(outputs, "listing_df")) {
      current_title <- main_title(outputs)
    } else {
      current_title <- outputs@main_title
    }
    outputs <- list(
      decorate(outputs, titles = current_title, footnotes = "Confidential and for internal use only")
    )
  } else if (any(c(
    inherits(outputs, "data.frame"),
    inherits(outputs, "ggplot"),
    inherits(outputs, "gtsummary"),
    inherits(outputs, "dVTableTree"),
    inherits(outputs, "dlisting"),
    inherits(outputs, "grob")
  ))) {
    if (inherits(outputs, "ggplot")) {
      current_title <- outputs$labels$title
      if (is.null(current_title)) {
        current_title <- ""
      }
      outputs <- decorate.ggplot(outputs, titles = current_title)
    } else if (inherits(outputs, "grob")) {
      outputs <- decorate.grob(outputs)
    } else if (inherits(outputs, "gtsummary") && !inherits(outputs, "dgtsummary")) {
      current_title <- tryCatch(outputs$table_styling$caption, error = function(e) NULL)
      if (is.null(current_title) || !nzchar(current_title)) current_title <- ""
      outputs <- decorate(outputs, titles = current_title)
    }

    outputs <- list(outputs)
  }

  assert_that(is.list(outputs))

  # ======== generate slides =======#
  # set slides layout
  ppt <- read_pptx(path = template)
  location_ <- officer::fortify_location(ph_location_fullsize(), doc = ppt)
  width <- location_$width
  height <- location_$height

  # add content to slides template
  for (x in outputs) {
    if (inherits(x, "dVTableTree") || inherits(x, "VTableTree")) {
      y <- to_flextable(x, lpp = t_lpp, cpp = t_cpp, ...)
      usernotes <- x@usernotes
      for (tt in y) {
        table_to_slide(ppt,
          content = tt,
          table_loc = center_table_loc(tt$ft, ppt_width = width, ppt_height = height),
          usernotes = usernotes, ...
        )
      }
    } else if (inherits(x, "dlisting")) {
      y <- to_flextable(x, cpp = l_cpp, lpp = l_lpp, ...)
      for (tt in y) {
        table_to_slide(ppt,
          content = tt,
          table_loc = center_table_loc(tt$ft, ppt_width = width, ppt_height = height), ...
        )
      }
    } else if (inherits(x, "data.frame")) { # this is dedicated for small data frames without pagination
      y <- to_flextable(x, ...)
      table_to_slide(ppt, content = y, decor = FALSE, ...)
    } else if (inherits(x, "dgtsummary")) {
      y <- to_flextable(x, lpp = t_lpp, ppt_height = height, ppt_width = width, ...)
      for (tt in y) {
        table_to_slide(ppt,
          content = tt,
          table_loc = center_gts_table_loc(tt$ft, ppt_width = width, ppt_height = height),
          ...
        )
      }
    } else if (inherits(x, "gtsummary")) {
      y <- to_flextable(x, ...)
      table_to_slide(ppt, content = y, decor = FALSE, ...)
    } else {
      if (any(class(x) %in% c("decoratedGrob", "decoratedGrobSet", "ggplot"))) {
        if (inherits(x, "ggplot")) {
          x <- decorate.ggplot(x)
        }

        assertthat::assert_that(inherits(x, "decoratedGrob") || inherits(x, "decoratedGrobSet"))

        figure_to_slide(ppt,
          content = x, fig_width = fig_width, fig_height = fig_height,
          figure_loc = center_figure_loc(fig_width, fig_height, ppt_width = width, ppt_height = 1.17 * height),
          fig_editable = fig_editable, ...
        )
      } else {
        if (inherits(x, "autoslider_error")) {
          message(x)
        } else {
          next
        }
      }
    }
  }
  print(ppt, target = outfile)
}

#' Generate flextable for preview first page
#'
#' @param x rtables or data.frame
#' @return A flextable or a ggplot object depending to the input.
#' @export
#' @examples
#' # Example 1. preview table
#' library(dplyr)
#' adsl <- eg_adsl
#' t_dm_slide(adsl, "TRT01P", c("SEX", "AGE")) %>% slides_preview()
slides_preview <- function(x) {
  if (inherits(x, "VTableTree")) {
    ret <- to_flextable(paginate_table(x, lpp = 20)[[1]])
  } else if (inherits(x, "listing_df")) {
    new_colwidth <- formatters::propose_column_widths(x)
    ret <- to_flextable(old_paginate_listing(x, cpp = 150, lpp = 20)[[1]],
      col_width = new_colwidth
    )
  } else if (inherits(x, "ggplot")) {
    ret <- x
  } else {
    stop("Unintended usage!")
  }
  ret
}

get_body_bottom_location <- function(ppt) {
  location_ <- officer::fortify_location(ph_location_fullsize(), doc = ppt)
  width <- location_$width
  height <- location_$height
  top <- 0.7 * height
  left <- 0.1 * width
  ph <- ph_location(left = left, top = top)
  ph
}


#' create location container to center the table
#'
#' @param ft Flextable object
#' @param ppt_width Powerpoint width
#' @param ppt_height Powerpoint height
#' @return Location for a placeholder
center_table_loc <- function(ft, ppt_width, ppt_height) {
  top <- (ppt_height - sum(dim(ft)$heights)) / 2
  left <- (ppt_width - sum(dim(ft)$widths)) / 2
  ph <- ph_location(left = left, top = top)
  ph
}

# Position table in the body area below the title placeholder.
# title_bottom marks where the title area ends; the table is centered
# in the remaining vertical space so it never overlaps the title or
# extends past the slide bottom.
center_gts_table_loc <- function(ft, ppt_width, ppt_height, title_bottom = 1.5) {
  ft_height <- flextable_dim(ft)$heights
  ft_width <- flextable_dim(ft)$widths
  body_height <- ppt_height - title_bottom
  top <- title_bottom + max(0, (body_height - ft_height) / 2)
  left <- max(0, (ppt_width - ft_width) / 2)
  ph_location(left = left, top = top, width = ft_width, height = ft_height)
}

#' Adjust title line break and font size
#'
#' @param title Character string
#' @param max_char Integer specifying the maximum number of characters in one line
#' @param title_color Title color
get_proper_title <- function(title, max_char = 60, title_color = "#1C2B39") {
  # cat(nchar(title), " ", as.integer(24-nchar(title)/para), "\n")
  title <- gsub("\\n", "\\s", title)
  new_title <- ""

  while (nchar(title) > max_char) {
    spaces <- gregexpr("\\s", title)
    new_title <- paste0(new_title, "\n", substring(title, 1, max(spaces[[1]][spaces[[1]] <= max_char])))
    title <- substring(title, max(spaces[[1]][spaces[[1]] <= max_char]) + 1, nchar(title))
  }

  new_title <- paste0(new_title, "\n", title)

  ftext(
    trimws(new_title),
    fp_text(
      font.size = floor(26 - nchar(title) / max_char),
      color = title_color
    )
  )
}

#' Add decorated flextable to slides
#'
#' @param ppt Slide
#' @param content Content to be added
#' @param table_loc Table location
#' @param usernotes User notes
#' @param decor Should table be decorated
#' @param layout layout from theme
#' @param ... additional arguments
#' @return Slide with added content
table_to_slide <- function(ppt, content, decor = TRUE, layout = "Title and Content",
                           table_loc = ph_location_type("body"), usernotes = "", ...) {
  layt_summary <- layout_summary(ppt)
  assertthat::assert_that(layout %in% layt_summary$layout)
  ppt_master <- layt_summary$master[1]
  args <- list(...)
  ppt <- layout_default(ppt, layout)

  if (decor) {
    print(content$header)
    out <- content$ft

    if (length(content$footnotes) > 1) {
      content$footnotes <- paste(content$footnotes, collapse = "\n")
    }
    # print(content_footnotes)
    if (content$footnotes != "") {
      out <- footnote(out,
        i = 1, j = 1,
        value = as_paragraph(content$footnotes),
        ref_symbols = " ", part = "header", inline = TRUE
      )
    }

    args$arg_header <- list(
      value = fpar(get_proper_title(content$header)),
      location = ph_location_type("title")
    )
  } else {
    out <- content
    out <- footnote(out,
      i = 1, j = 1,
      value = as_paragraph("Confidential and for internal use only"),
      ref_symbols = " ", part = "header", inline = TRUE
    )
  }

  ppt <- do_call(add_slide, x = ppt, master = ppt_master, ...)
  ppt <- ph_with(ppt, value = out, location = table_loc)
  ppt <- set_notes(ppt, value = usernotes,
                   location = notes_location_type("body"))
  ph_with_args <- args[unlist(lapply(args, function(x) all(c("location", "value") %in% names(x))))]
  res <- lapply(ph_with_args, function(x) {
    ppt <- ph_with(ppt, value = x$value, location = x$location)
  })

  res
}

#' Create location container to center the figure, based on ppt size and
#' user specified figure size
#'
#' @param fig_width Figure width
#' @param fig_height Figure height
#' @param ppt_width Slide width
#' @param ppt_height Slide height
#'
#' @return Location for a placeholder from scratch
center_figure_loc <- function(fig_width, fig_height, ppt_width, ppt_height) {
  # center figure
  top <- (ppt_height - fig_height) / 2
  left <- (ppt_width - fig_width) / 2
  ph_location(top = top, left = left)
}

#' Placeholder for ph_with_img
#'
#' @param ppt power point file
#' @param figure image object
#' @param fig_width width of figure
#' @param fig_height height of figure
#' @param figure_loc location of figure
#' @return Location for a placeholder
#' @export
ph_with_img <- function(ppt, figure, fig_width, fig_height, figure_loc) {
  file_name <- tempfile(fileext = ".svg")
  svg(filename = file_name, width = fig_width, height = fig_height, onefile = TRUE)
  grid.draw(figure$grob)
  dev.off()
  on.exit(unlink(file_name))
  ext_img <- external_img(file_name, width = fig_width, height = fig_height)

  ppt |> ph_with(value = ext_img, location = figure_loc, use_loc_size = FALSE)
}

#' Add figure to slides
#'
#' @param ppt slide page
#' @param content content to be added
#' @param decor should decoration be added
#' @param fig_width user specified figure width
#' @param fig_height user specified figure height
#' @param figure_loc location of the figure. Defaults to `ph_location_type("body")`
#' @param layout theme layout
#' @param fig_editable whether we want the figure to be editable in pptx viewers
#' @param ... arguments passed to program
#'
#' @return slide with the added content
figure_to_slide <- function(ppt, content,
                            decor = TRUE,
                            fig_width,
                            fig_height,
                            layout = "Title and Content",
                            figure_loc = ph_location_type("body"),
                            fig_editable = FALSE,
                            ...) {
  layt_summary <- layout_summary(ppt)
  assertthat::assert_that(layout %in% layt_summary$layout)
  ppt_master <- layt_summary$master[1]
  ppt <- layout_default(ppt, layout)
  args <- list(...)


  if (decor) {
    args$arg_header <- list(
      value = fpar(get_proper_title(content$titles)),
      location = ph_location_type("title")
    )
  }

  if ("decoratedGrob" %in% class(content)) {
    ppt <- do_call(add_slide, x = ppt, master = ppt_master, ...)
    if (fig_editable) {
      content_list <- g_export(content)
      ppt <- ph_with(ppt, content_list$dml, location = ph_location_type(type = "body"))
    } else {
      ppt <- ph_with_img(ppt, content, fig_width, fig_height, figure_loc)
    }

    ph_with_args <- args[unlist(lapply(args, function(x) all(c("location", "value") %in% names(x))))]
    res <- lapply(ph_with_args, function(x) {
      ppt <- ph_with(ppt, value = x$value, location = x$location)
    })
    res
  } else if ("decoratedGrobSet" %in% class(content)) { # for decoratedGrobSet, a list of figures are created and added
    # revisit, to make more efficent
    for (figure in content) {
      ppt <- do_call(add_slide, x = ppt, master = ppt_master, ...)
      ppt <- ph_with_img(ppt, figure, fig_width, fig_height, figure_loc)
    }
    ppt
  } else {
    stop("Should not reach here")
  }
}
