#' s3 method for to_flextable
#' @param x object to to_flextable
#' @param ... additional arguments passed to methods
to_flextable <- function(x, ...) {
  UseMethod("to_flextable")
}


#' default method to to_flextable
#' @param x object to to_flextable
#' @param ... additional arguments. not used.
#'
#' @export
to_flextable.default <- function(x, ...) {
  stop("default to_flextable function does not exist")
}


#' To flextable
#'
#' @details convert the dataframe object into flextable, and merge the cells
#' that have colspan > 1. align the columns to the middle, and the row.names to
#' the left. indent the row.names by 10 times indention. titles are added in headerlines,
#' footnotes are added in footer lines,
#' The width of the columns are aligned based on autofit() of officer function.
#' For paginated table, the width of the 1st column are set as the widest 1st column among paginated tables
#' @param x Decorated dataframe with title and footnote as attributes
#' @param lpp \{lpp\} from \{paginate_table\}. numeric. Maximum lines per page
#' @param ... arguments passed to program
#'
#' @export
#'
to_flextable.Ddataframe <- function(x, lpp, ...) {
  # paginate VTableTree
  Ddf <- x
  df <- Ddf@df

  page_max <- ceiling(nrow(df) / lpp)
  pag_df <- split(df, rep(1:page_max, each = lpp))

  ft_list <- lapply(1:length(pag_df), function(x) {
    ft <- to_flextable(pag_df[[x]], ...)
    list(
      ft = ft,
      header = ifelse(x == 1, Ddf@titles, paste(Ddf@titles, "(cont.)")),
      footnotes = Ddf@footnotes
    )
  })

  # force the width of the 1st column to be the widest of all paginated table
  ft_list_resize <- set_width_widest(ft_list)
  class(ft_list_resize) <- "dflextable"

  ft_list_resize
}

#' To flextable
#'
#' Convert the dataframe into flextable, and merge the cells
#' that have colspan > 1. align the columns to the middle, and the row.names to
#' the left. indent the row.names by 10 times indention.
#'
#' @param x dataframe
#' @param lpp \{lpp\} from \{paginate_table\}. numeric. Maximum lines per page
#' @param table_format Table format
#' @export
to_flextable.Ddataframe <- function(x, lpp, table_format = table_format, ...) {
  df <- x
  if (all(is.na(formatters::var_labels(df)))) {
    formatters::var_labels(df) <- names(df)
  }
  ft <- flextable(df)
  ft <- set_header_labels(ft, values = as.list(formatters::var_labels(df)))

  # if(!is.null(apply_theme)){
  #   ft <- ft %>%
  #     apply_theme()
  # }

  ft <- ft |>
    align_text_col(align = "center", header = TRUE) |>
    align(i = seq_len(nrow(df)), j = 1, align = "left") |> # row names align to left
    border(border = fp_border(color = border_color, width = 1), part = "all") |>
    padding(padding.top = 3, padding.bottom = 3, part = "all") |>
    autofit(add_h = 0) |>
    table_format()

  ft <- ft |>
    width(width = c(
      dim(ft)$widths[1],
      dim(ft)$widths[-1] - dim(ft)$widths[-1] + sum(dim(ft)$widths[-1]) / (ncol(df) - 1)
    )) # even the non-label column width

  if (flextable_dim(ft)$widths > 10) {
    pgwidth <- 10.5
    ft <- ft |>
      width(width = dim(ft)$widths * pgwidth / flextable_dim(ft)$widths)
    # adjust width of each column as percentage of total width
  }

  ft
}

#' convert gtsummary to flextable
#' @param x gtsummary object
#' @param table_format Function applied to the flextable for styling
#' @param ... additional arguments, not used
#' @export
to_flextable.gtsummary <- function(x, table_format = autoslider_format, ...) {
  gtsummary::as_flex_table(x) |> table_format()
}

#' convert tbl_roche_summary (NEST 2 gtsummary subclass) to flextable
#' @param x tbl_roche_summary object
#' @param ... arguments passed to \code{to_flextable.gtsummary}
#' @export
to_flextable.tbl_roche_summary <- function(x, ...) {
  # gtsummary v2 guards as_flex_table() with check_class(x, "gtsummary").
  # Restore the standard hierarchy if it was stripped.
  if (!inherits(x, "gtsummary")) {
    class(x) <- c(class(x), "tbl_summary", "gtsummary")
  }
  to_flextable.gtsummary(x, ...)
}

#' convert dgtsummary to flextable
#'
#' @param x dgtsummary object
#' @param lpp Lines (rows) per page; overridden when ppt_height is supplied
#' @param ppt_height Slide height in inches; used to auto-compute lpp
#' @param ppt_width Slide width in inches; used to scale table columns
#' @param table_format Function applied to the flextable for styling
#' @param ... additional arguments, not used
#' @export
to_flextable.dgtsummary <- function(x, lpp = 20, ppt_height = NULL, ppt_width = NULL,
                                    table_format = autoslider_format, ...) {
  ft_full <- gtsummary::as_flex_table(x) |> table_format()

  # Scale columns to fit slide width
  if (!is.null(ppt_width)) {
    total_width <- flextable_dim(ft_full)$widths
    if (total_width > ppt_width) {
      ft_full <- width(ft_full, width = dim(ft_full)$widths * ppt_width / total_width)
    }
  }

  # Compute lpp from actual row heights and available body area on slide.
  # flextable stores rowheights as minimum heights ("atleast" mode); apply a 1.3x
  # safety factor to account for padding expanding rows beyond the stored minimum.
  if (!is.null(ppt_height)) {
    header_height <- sum(ft_full$header$rowheights)
    available_body <- ppt_height - 1.5 - header_height # 1.5in for title + margins
    row_heights_est <- ft_full$body$rowheights * 1.3
    lpp <- max(sum(cumsum(row_heights_est) <= available_body), 1L)
  }

  n_body <- nrow(ft_full$body$dataset)
  header_text <- paste(attr(x, "titles"), collapse = "\n")
  footnotes_text <- paste(attr(x, "footnotes"), collapse = "\n")
  n_pages <- ceiling(n_body / lpp)
  ft_list <- lapply(seq_len(n_pages), function(pg) {
    rows_keep <- seq.int((pg - 1L) * lpp + 1L, min(pg * lpp, n_body))
    rows_delete <- setdiff(seq_len(n_body), rows_keep)
    ft_page <- if (length(rows_delete) > 0L) {
      delete_rows(ft_full, i = rows_delete, part = "body")
    } else {
      ft_full
    }
    list(
      ft = ft_page,
      header = if (pg == 1L) header_text else paste(header_text, "(cont.)"),
      footnotes = footnotes_text
    )
  })
  class(ft_list) <- "dflextable"
  ft_list
}




#' convert data.frame to flextable
#' @export
to_flextable.data.frame <- function(x, col_width = NULL, table_format = orange_format,
                                    dose_template = FALSE, font_size = 9, ...) {
  df <- x
  ft <- do_call(flextable, data = df, ...)

  if (dose_template) {
    ft <- ft |>
      autofit() |>
      fit_to_width(10)
  } else {
    if (all(is.na(formatters::var_labels(df)))) {
      formatters::var_labels(df) <- names(df)
    }

    ft <- set_header_labels(ft, values = as.list(formatters::var_labels(df)))
    ft <- ft |> width(width = col_width)
    if (flextable_dim(ft)$widths > 10) {
      pgwidth <- 10.5
      ft <- ft |>
        width(width = dim(ft)$widths * pgwidth / flextable_dim(ft)$widths)
      # adjust width of each column as percentage of total width
    }
  }

  ft |>
    table_format(...) |>
    fontsize(size = font_size, part = "all")
}


old_paginate_listing <- function(lsting,
                                 page_type = "letter",
                                 font_family = "Courier",
                                 font_size = 8,
                                 lineheight = 1,
                                 landscape = FALSE,
                                 pg_width = NULL,
                                 pg_height = NULL,
                                 margins = c(top = .5, bottom = .5, left = .75, right = .75),
                                 lpp = NA_integer_,
                                 cpp = NA_integer_,
                                 colwidths = formatters::propose_column_widths(lsting),
                                 tf_wrap = !is.null(max_width),
                                 max_width = NULL,
                                 verbose = FALSE) {
  checkmate::assert_class(lsting, "listing_df")
  checkmate::assert_numeric(colwidths, lower = 0, len = length(listing_dispcols(lsting)), null.ok = TRUE)
  checkmate::assert_flag(tf_wrap)
  checkmate::assert_count(max_width, null.ok = TRUE)
  checkmate::assert_flag(verbose)

  indx <- formatters::paginate_indices(lsting,
    page_type = page_type,
    font_family = font_family,
    font_size = font_size,
    lineheight = lineheight,
    landscape = landscape,
    pg_width = pg_width,
    pg_height = pg_height,
    margins = margins,
    lpp = lpp,
    cpp = cpp,
    colwidths = colwidths,
    tf_wrap = tf_wrap,
    max_width = max_width,
    rep_cols = length(get_keycols(lsting)),
    verbose = verbose
  )

  vert_pags <- lapply(
    indx$pag_row_indices,
    function(ii) lsting[ii, ]
  )
  dispnames <- listing_dispcols(lsting)
  full_pag <- lapply(
    vert_pags,
    function(onepag) {
      if (!is.null(indx$pag_col_indices)) {
        lapply(
          indx$pag_col_indices,
          function(jj) {
            res <- onepag[, dispnames[jj], drop = FALSE]
            listing_dispcols(res) <- intersect(dispnames, names(res))
            res
          }
        )
      } else {
        list(onepag)
      }
    }
  )

  ret <- unlist(full_pag, recursive = FALSE)
  ret
}


#' convert listing to flextable
#' @export
to_flextable.dlisting <- function(x, cpp, lpp, ...) {
  ddf <- x
  df <- ddf@lst
  col_width <- ddf@width
  pag_df <- old_paginate_listing(df, cpp = cpp, lpp = lpp)
  ft_list <- lapply(1:length(pag_df), function(x) {
    ft <- to_flextable(pag_df[[x]], col_width = col_width, ...)
    if (length(prov_footer(df)) == 0) {
      cat_foot <- main_footer(df)
    } else {
      cat_foot <- paste0(prov_footer(df), "\n", main_footer(df))
    }

    if (length(cat_foot) == 0) {
      cat_foot <- ""
    }
    list(
      ft = ft,
      header = ifelse(x == 1, main_title(df), paste(main_title(df), "(cont.)")),
      footnotes = cat_foot
    )
  })
  # force the width of the 1st column to be the widest of all paginated table
  # ft_list_resize <- set_width_widest(ft_list)
  class(ft_list) <- "dflextable"

  ft_list
}



#' Covert rtables object to flextable
#'
#' @param x rtable(VTableTree) object
#' @param table_format a function that decorate a flextable and return a flextable
#' @export
to_flextable.VTableTree <- function(x, table_format = orange_format, ...) {
  tbl <- x
  mf <- formatters::matrix_form(tbl, indent_rownames = TRUE)
  nr_header <- attr(mf, "nrow_header")
  non_total_coln <- c(TRUE, !grepl("All Patients", names(tbl)))
  df <- as.data.frame(mf$strings[(nr_header + 1):(nrow(mf$strings)), , drop = FALSE])

  header_df <- as.data.frame(mf$strings[1:(nr_header), , drop = FALSE])

  # if(concat_header){
  #   header_df <- lapply(header_df, function(x) {paste0(x, collapse = "\n")}) %>% as.data.frame
  # }

  # if(!total_col){
  #   df <- df[non_total_coln]
  #   header_df <- header_df[non_total_coln]
  # }
  ft <- do_call(flextable, data = df, ...)
  ft <- ft |>
    delete_part(part = "header") |>
    add_header(values = header_df)

  # if(!is.null(apply_theme)){
  #   ft <- ft |>
  #     apply_theme()
  # }

  ft <- do_call(table_format, ft = ft, ...)
  ft <- ft |>
    merge_at_indice(lst = get_merge_index(mf$spans[(nr_header + 1):nrow(mf$spans), , drop = FALSE]), part = "body") |>
    merge_at_indice(lst = get_merge_index(mf$spans[1:nr_header, , drop = FALSE]), part = "header") |>
    align_text_col(align = "center", header = TRUE) |>
    align(i = seq_len(nrow(tbl)), j = 1, align = "left") |> # row names align to left
    padding_lst(mf$row_info$indent) |>
    padding(padding.top = 3, padding.bottom = 3, part = "all") |>
    autofit(add_h = 0)


  ft <- ft |>
    width(width = c(
      dim(ft)$widths[1],
      dim(ft)$widths[-1] - dim(ft)$widths[-1] + sum(dim(ft)$widths[-1]) / (ncol(mf$strings) - 1)
    )) # even the non-label column width

  if (flextable_dim(ft)$widths > 10) {
    pgwidth <- 10.5
    ft <- ft |>
      width(width = dim(ft)$widths * pgwidth / flextable_dim(ft)$widths)
    # adjust width of each column as percentage of total width
  }

  ft
}


#' To flextable
#'
#' @param x decorated rtable(dVTableTree) object
#' @param lpp \{lpp\} from \link[rtables]{paginate_table}. numeric. Maximum lines per page
#' @param ... argument parameters
#' @details convert the VTableTree object into flextable, and merge the cells
#' that have colspan > 1. align the columns to the middle, and the row.names to
#' the left. indent the row.names by 10 times indention. titles are added in headerlines,
#' footnotes are added in footer lines,
#' The width of the columns are aligned based on autofit() of officer function.
#' For paginated table, the width of the 1st column are set as the widest 1st column among paginated tables
#' @export
to_flextable.dVTableTree <- function(x, lpp, cpp, ...) {
  dtbl <- x
  # paginate VTableTree
  pag_tbl <- paginate_table(dtbl@tbl, lpp = lpp, cpp = cpp)
  ft_list <- lapply(1:length(pag_tbl), function(x) {
    ft <- to_flextable(pag_tbl[[x]], ...)
    if (length(dtbl@tbl@provenance_footer) == 0) {
      cat_foot <- dtbl@footnotes
    } else {
      cat_foot <- paste0(dtbl@tbl@provenance_footer, "\n", dtbl@footnotes)
    }

    list(
      ft = ft,
      header = ifelse(x == 1, dtbl@titles, paste(dtbl@titles, "(cont.)")),
      footnotes = cat_foot
    )
  })
  # force the width of the 1st column to be the widest of all paginated table
  ft_list_resize <- set_width_widest(ft_list)
  class(ft_list_resize) <- "dflextable"

  ft_list_resize
}

g_export <- function(decorated_p) {
  ret <- list()

  ret$dml <- rvg::dml(
    ggobj = ggpubr::as_ggplot(decorated_p$grob),
    bg = "white",
    pointsize = 12,
    editable = TRUE
  )
  ret$footnote <- decorated_p$footnotes
  ret$spec <- attributes(decorated_p)$spec

  ret
}

set_width_widest <- function(ft_list) {
  width1st <- max(unlist(lapply(ft_list, function(x) {
    x$ft$body$colwidths[1]
  })))
  for (i in 1:length(ft_list)) {
    ft_list[[i]]$ft <- width(ft_list[[i]]$ft, 1, width = width1st)
  }

  ft_list
}

get_merge_index_single <- function(span) {
  ret <- list()
  j <- 1
  while (j < length(span)) {
    if (span[j] != 1) {
      ret <- c(ret, list(j:(j + span[j] - 1)))
    }
    j <- j + span[j]
  }

  ret
}

get_merge_index <- function(spans) {
  ret <- lapply(seq_len(nrow(spans)), function(i) {
    ri <- spans[i, ]
    r <- get_merge_index_single(ri)
    lapply(r, function(s) {
      list(j = s, i = i)
    })
  })
  unlist(ret, recursive = FALSE, use.names = FALSE)
}

merge_at_indice <- function(ft, lst, part) {
  Reduce(function(ft, ij) {
    merge_at(ft, i = ij$i, j = ij$j, part = part)
  }, lst, ft)
}

padding_lst <- function(ft, indents) {
  Reduce(function(ft, s) {
    padding(ft, s, 1, padding.left = (indents[s] + 1) * 10)
  }, seq_len(length(indents)), ft)
}
