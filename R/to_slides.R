confidential_footnote <- "Confidential and for internal use only"
default_footer_font_size <- 8L

make_footnote_value <- function(value, font_size = NULL) {
  if (is.null(font_size)) {
    return(as_paragraph(value))
  }

  assertthat::assert_that(
    is.numeric(font_size),
    length(font_size) == 1,
    !is.na(font_size)
  )
  as_paragraph(as_chunk(value, props = fp_text(font.size = font_size)))
}

#' generate slides based on output
#'
#' @param outputs List of output
#' @param template Template file path
#' @param outfile Out file path
#' @param fig_width figure width in inch
#' @param fig_height figure height in inch
#' @param t_lpp An integer specifying the table lines per page \cr
#'    Specify this optional argument to modify the length of all of the table displays.
#'    Defaults to `NULL`, which auto-fits the table to the slide height (for rtables,
#'    via [rtables::paginate_table()]; for gtsummary, via a row-height estimate).
#'    Overridden for an individual slide by an \code{lpp} field on its spec entry.
#' @param t_cpp An integer specifying the table columns per page\cr
#'    Specify this optional argument to modify the width of all of the table displays.
#'    Only honored for rtables output; gtsummary tables do not support column
#'    pagination and are instead scaled down to fit when too wide. Explicitly
#'    setting `t_cpp` also raises a warning for gtsummary tables that need scaling,
#'    since column pagination was requested but cannot be applied.
#'    Overridden for an individual slide by a \code{cpp} field on its spec entry.
#' @param l_lpp An integer specifying the listing lines per page\cr
#'    Specify this optional argument to modify the length of all of the listings display.
#'    Overridden for an individual slide by an \code{lpp} field on its spec entry.
#' @param l_cpp An integer specifying the listing columns per page\cr
#'    Specify this optional argument to modify the width of all of the listings display.
#'    Overridden for an individual slide by a \code{cpp} field on its spec entry.
#' @param fig_editable whether we want the figure to be editable in pptx viewers, defaults to FALSE
#' @param font_size Deck-wide default table font sizes, a named `list` with any
#'   of `body`, `header`, `footer` (point sizes). Per-slide sizes declared in the
#'   spec (a `font_size:` block on the entry) override these. Applied by wrapping
#'   the slide's `table_format` via [with_font_sizes()]. The footer defaults to
#'   the body size, or 8 pt when no body size is supplied; see Details.
#' @param ... arguments passed to program
#' @return No return value, called for side effects
#' @details
#' ## Per-slide font size
#' Each output carries its spec entry as an attribute (set by
#' [generate_outputs()]). `generate_slides()` reads two optional keys from it:
#' `table_format` (a formatter function) and `font_size` (a named list with
#' `body`/`header`/`footer`). The effective formatter for a slide is
#' `with_font_sizes(table_format, body, header, footer)`, so font sizes can be
#' set per slide directly in the spec, e.g.
#' \preformatted{
#' t_dm_slide_FAS:
#'   program: t_dm_slide
#'   suffix: FAS
#'   table_format: black_format_tb
#'   font_size:
#'     body: 6
#'     header: 6
#'     footer: 5
#' }
#' The `font_size` argument sets deck-wide defaults; per-slide values win.
#' When no footer size is supplied, the resolved body size is used, falling back
#' to 8 pt. This default is applied to the Confidential footnote on every
#' supported slide path, including `decor = FALSE`.
#'
#' \subsection{Per-slide pagination}{
#' Pagination density is resolved the same way. A spec entry may carry an
#' optional \code{lpp} (lines per page) and \code{cpp} (columns per page). When
#' present they override the deck-wide \code{t_lpp}/\code{t_cpp} (tables) or
#' \code{l_lpp}/\code{l_cpp} (listings) for that slide only, so a short
#' demographics table and a long adverse-event table can use different
#' densities in the same deck:
#' \preformatted{
#' t_dm_slide_FAS:
#'   program: t_dm_slide
#'   suffix: FAS
#'   lpp: 30
#'   cpp: 180
#' }
#' Entries without these fields keep the deck-wide value. Each must be a single
#' positive whole number; anything else is an error naming the offending entry.
#'
#' Note that pagination for \code{gtsummary} tables is recomputed from the
#' slide height, so a spec \code{lpp} does not change their pagination.
#' }
#' @export
#' @examplesIf require(filters)
#'
#' # Example 1. When applying to the whole pipeline
#' library(dplyr)
#' data <- list(
#'   adsl = eg_adsl |> dplyr::mutate(FASFL = SAFFL),
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
#' spec_file |>
#'   read_spec() |>
#'   filter_spec(program %in% c("t_dm_slide")) |>
#'   generate_outputs(datasets = data) |>
#'   decorate_outputs() |>
#'   generate_slides()
#'
#' # Example 2. When applying to an rtable object or an rlisting object
#' adsl <- eg_adsl
#' t_dm_slide(adsl, "TRT01P", c("SEX", "AGE")) |>
#'   generate_slides()
generate_slides <- function(outputs,
                            outfile = paste0(tempdir(), "/output.pptx"),
                            template = file.path(system.file(package = "autoslider.core"), "theme/basic.pptx"),
                            fig_width = 9, fig_height = 5, t_lpp = NULL, t_cpp = 200,
                            l_lpp = 20, l_cpp = 150, fig_editable = FALSE,
                            font_size = NULL, ...) {
  # gtsummary tables don't support column pagination; only warn about a too-wide
  # table when the caller explicitly asked for column pagination via `t_cpp`,
  # not for the default value (which is otherwise always forwarded).
  t_cpp_explicit <- !missing(t_cpp)

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
      decorate(outputs, titles = current_title, footnotes = confidential_footnote)
    )
  } else if (any(c(
    inherits(outputs, "data.frame"),
    inherits(outputs, "ggplot"),
    inherits(outputs, "gtsummary"),
    inherits(outputs, "tbl_roche_summary"),
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
    } else if (
      (inherits(outputs, "gtsummary") || inherits(outputs, "tbl_roche_summary")) &&
      !inherits(outputs, "dgtsummary")
    ) {
      current_title <- tryCatch(outputs$table_styling$caption, error = function(e) NULL)
      if (is.null(current_title) || !nzchar(current_title)) current_title <- ""
      outputs <- decorate(outputs, titles = current_title)
    }

    outputs <- list(outputs)
  }

  assert_that(is.list(outputs))

  # ======== generate slides =======#
  # Arguments forwarded to to_flextable()/table_to_slide(). `table_format` and
  # `font_size` are managed per-slide below, so they are pulled out of the
  # forwarded set to avoid clashing with the values we inject.
  dots <- list(...)
  fwd <- dots
  fwd$table_format <- NULL

  # Deck-wide default font sizes. Accept the tidy `font_size = list(...)` form
  # and, for backwards compatibility, scalar *_font_size passed via `...`.
  deck_fs <- font_size %||% list()
  deck_fs$body <- deck_fs$body %||% dots$body_font_size
  deck_fs$header <- deck_fs$header %||% dots$header_font_size
  deck_fs$footer <- deck_fs$footer %||% dots$footer_font_size
  fwd$body_font_size <- NULL
  fwd$header_font_size <- NULL
  fwd$footer_font_size <- NULL

  # Merge deck defaults with a slide's own spec `font_size` block (slide wins).
  slide_fs <- function(x) {
    sp <- attr(x, "spec")
    modifyList(deck_fs, (sp$font_size) %||% list())
  }
  # Effective pagination for a slide: the spec entry's `lpp`/`cpp` when set,
  # otherwise the deck-wide argument. Like the font sizes above, the slide wins.
  # Only spec-supplied values are validated: the arguments keep whatever
  # behaviour they had before, so existing callers are unaffected.
  slide_pag <- function(x, lpp, cpp) {
    sp <- attr(x, "spec")
    list(
      lpp = if (is.null(sp$lpp)) lpp else assert_is_valid_pagination(sp$lpp, "lpp", sp$output),
      cpp = if (is.null(sp$cpp)) cpp else assert_is_valid_pagination(sp$cpp, "cpp", sp$output)
    )
  }
  resolve_font_sizes <- function(x) {
    fs <- slide_fs(x)
    fs$footer <- fs$footer %||% fs$body %||% default_footer_font_size
    fs
  }
  resolve_footer_font_size <- function(x) {
    resolve_font_sizes(x)$footer
  }
  # Effective formatter for a slide: its spec `table_format` (else the deck-wide
  # one, else `default_fmt`), wrapped so the resolved font sizes are applied.
  resolve_format <- function(x, default_fmt) {
    sp <- attr(x, "spec")
    fs <- resolve_font_sizes(x)
    base_fmt <- (sp$table_format) %||% dots$table_format %||% default_fmt
    with_font_sizes(base_fmt, fs$body, fs$header, fs$footer)
  }
  # Arguments that belong to `table_to_slide()` (slide placement / decoration) but
  # are not accepted by `to_flextable()` or its formatter helpers. A spec may set
  # these (e.g. `layout = "08_TitleAndContent"`, `table_loc = ...`); they must reach
  # `call_slide()` but must be dropped before `to_flextable()`, otherwise they leak
  # through the formatter's `...` (e.g. `autoslider_format()`) and error with
  # "unused argument".
  slide_only_args <- c("decor", "layout", "table_loc", "usernotes", "footer_font_size")
  fwd_ft <- fwd[setdiff(names(fwd), slide_only_args)]
  call_ft <- function(x, more) {
    do.call(to_flextable, c(list(x = x), more, fwd_ft))
  }
  call_slide <- function(content, more) {
    do.call(table_to_slide, c(list(ppt = ppt, content = content), more, fwd))
  }

  # set slides layout
  ppt <- read_pptx(path = template)
  location_ <- officer::fortify_location(ph_location_fullsize(), doc = ppt)
  width <- location_$width
  height <- location_$height

  # add content to slides template
  for (x in outputs) {
    if (inherits(x, "dVTableTree") || inherits(x, "VTableTree")) {
      tf <- resolve_format(x, orange_format)
      footer_pt <- resolve_footer_font_size(x)
      pag <- slide_pag(x, t_lpp, t_cpp)
      y <- call_ft(x, list(lpp = pag$lpp, cpp = pag$cpp, table_format = tf))
      usernotes <- x@usernotes
      for (tt in y) {
        call_slide(tt, list(
          table_loc = center_table_loc(tt$ft, ppt_width = width, ppt_height = height),
          usernotes = usernotes, footer_font_size = footer_pt
        ))
      }
    } else if (inherits(x, "dlisting")) {
      footer_pt <- resolve_footer_font_size(x)
      pag <- slide_pag(x, l_lpp, l_cpp)
      y <- call_ft(x, list(cpp = pag$cpp, lpp = pag$lpp))
      for (tt in y) {
        call_slide(tt, list(
          table_loc = center_table_loc(tt$ft, ppt_width = width, ppt_height = height),
          footer_font_size = footer_pt
        ))
      }
    } else if (inherits(x, "data.frame")) { # this is dedicated for small data frames without pagination
      tf <- resolve_format(x, orange_format)
      footer_pt <- resolve_footer_font_size(x)
      y <- call_ft(x, list(table_format = tf))
      call_slide(y, list(decor = FALSE, footer_font_size = footer_pt))
    } else if (inherits(x, "dgtsummary")) {
      tf <- resolve_format(x, autoslider_format)
      footer_pt <- resolve_footer_font_size(x)
      # The `lpp` value is supplied here; `to_flextable.dgtsummary()` currently
      # recomputes `lpp` from `ppt_height`, so a per-slide `lpp` only takes effect
      # once #121 (gtsummary ignores t_lpp) is fixed. gtsummary has no column
      # pagination, so only forward `cpp` when it was explicitly requested -- via
      # the slide's spec `cpp`, or a deck-wide `t_cpp` -- to avoid warning on the
      # default.
      sp <- attr(x, "spec")
      lpp_val <- slide_pag(x, t_lpp, t_cpp)$lpp
      cpp_val <- if (!is.null(sp$cpp)) {
        assert_is_valid_pagination(sp$cpp, "cpp", sp$output)
      } else if (t_cpp_explicit) {
        t_cpp
      } else {
        NULL
      }
      y <- call_ft(x, list(
        lpp = lpp_val, cpp = cpp_val,
        ppt_height = height, ppt_width = width, table_format = tf
      ))
      for (tt in y) {
        call_slide(tt, list(
          table_loc = center_gts_table_loc(tt$ft, ppt_width = width, ppt_height = height),
          footer_font_size = footer_pt
        ))
      }
    } else if (inherits(x, "gtsummary") || inherits(x, "tbl_roche_summary")) {
      tf <- resolve_format(x, autoslider_format)
      footer_pt <- resolve_footer_font_size(x)
      y <- call_ft(x, list(table_format = tf))
      call_slide(y, list(decor = FALSE, footer_font_size = footer_pt))
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
#' t_dm_slide(adsl, "TRT01P", c("SEX", "AGE")) |> slides_preview()
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
#' @param footer_font_size Point size for the footnote text, defaulting to 8.
#'   `NULL` keeps the existing footnote size set on the flextable.
#' @param ... additional arguments
#' @return Slide with added content
table_to_slide <- function(ppt, content, decor = TRUE, layout = "Title and Content",
                           table_loc = ph_location_type("body"), usernotes = "",
                           footer_font_size = 8L, ...) {
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
      footnote_value <- make_footnote_value(content$footnotes, footer_font_size)
      out <- footnote(out,
        i = 1, j = 1,
        value = footnote_value,
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
      value = make_footnote_value(confidential_footnote, footer_font_size),
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
