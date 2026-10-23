# Placeholder slides
# ------------------------------------------------------------------------------
# Section dividers, cover pages and other non-TLG slides. Each slide is
# described by a layout *role* (which template layout to use and where its
# placeholders are) plus the text for each placeholder. A speclayout can then
# declare these slides inline, and place_speclayout_placeholders() inserts them
# at pages derived from their position among the TLG entries.
#
# Downstream packages (e.g. autoslideR for the SREP template) supply their own
# roles through `layouts =` and their own slide types through `types =`.

# --- input checks ---------------------------------------------------------------

#' Is `x` a list whose elements all have non-empty names?
#'
#' A `list()` with no elements passes. With `unique = TRUE` the names must also
#' be distinct.
#'
#' @noRd
has_entry_names <- function(x, unique = TRUE) {
  if (!is.list(x)) {
    return(FALSE)
  }
  if (length(x) == 0) {
    return(TRUE)
  }
  nms <- names(x)
  !is.null(nms) && !anyNA(nms) && all(nzchar(nms)) && (!unique || !anyDuplicated(nms))
}
assertthat::on_failure(has_entry_names) <- function(call, env) {
  unique <- if (is.null(call$unique)) TRUE else eval(call$unique, env)
  paste0(
    "`", deparse(call$x), "` must be a list whose elements all have ",
    if (unique) "unique, " else "", "non-empty names."
  )
}

# --- layout roles ---------------------------------------------------------------

#' Default placeholder layout roles
#'
#' Roles for the layouts of `inst/theme/basic.pptx` (and officer's default
#' template). Placeholders are found by their PowerPoint type, which is the same
#' in every Office-based template, rather than by label.
#'
#' @noRd
placeholder_layout_defaults <- function() {
  list(
    section = list(
      layout = "Section Header", master = "Office Theme",
      types = list(title = "title", text = "body"),
      fallbacks = list(subtitle = "text")
    ),
    title_slide = list(
      layout = "Title Slide", master = "Office Theme",
      types = list(title = "ctrTitle", subtitle = "subTitle"),
      fallbacks = list(text = "subtitle")
    ),
    title_content = list(
      layout = "Title and Content", master = "Office Theme",
      types = list(title = "title", content = "body"),
      fallbacks = list(subtitle = "content", text = "content")
    )
  )
}

#' Placeholder layout roles
#'
#' Returns the lookup that maps each layout *role* used by placeholder slides
#' (such as `section`) to a template layout and the placeholders it fills.
#'
#' Each role is a `list` with:
#' * `layout`, `master`: the template layout to add the slide on.
#' * `labels`: field name to placeholder label (`ph_label` in
#'   [officer::layout_properties()]), and/or
#' * `types`: field name to placeholder type (`type` in
#'   [officer::layout_properties()], e.g. `"title"`, `"body"`). A label wins
#'   over a type for the same field.
#' * `fallbacks`: field name to another field. Text for a field the layout has
#'   no placeholder for is added to the other field, before its own text. The
#'   default `section` role (the "Section Header" layout has a title and a text
#'   box, but no subtitle) sends `subtitle` to `text`, so a speclayout written
#'   for a template with a subtitle still renders without losing text.
#'
#' Overrides are merged per role, and `labels`, `types` and `fallbacks` per
#' field, so changing one layout name or one label keeps everything else. New
#' roles can be added the same way.
#'
#' @param overrides A named `list` of role overrides. Defaults to the option
#'   named by `option`.
#' @param defaults The roles to start from.
#' @param option Name of the option holding session-wide overrides.
#'
#' @return A named `list` of roles.
#'
#' @seealso [validate_placeholder_layouts()], [append_section_slides()]
#'
#' @export
#'
#' @examples
#' placeholder_layouts()$section
#'
#' # A template whose divider layout is called "Chapter divider"
#' placeholder_layouts(list(section = list(layout = "Chapter divider")))$section$layout
placeholder_layouts <- function(overrides = getOption(option, list()),
                                defaults = placeholder_layout_defaults(),
                                option = "autoslider.core.placeholder_layouts") {
  assert_that(has_entry_names(defaults))
  if (length(overrides) == 0) {
    return(defaults)
  }
  assert_that(has_entry_names(overrides),
    msg = paste0("`", option, "` must be a list whose elements all have unique, non-empty names.")
  )
  nested <- c("labels", "types", "fallbacks")
  for (role in names(overrides)) {
    base <- defaults[[role]] %||% list()
    ov <- overrides[[role]]
    merged <- utils::modifyList(base, ov[setdiff(names(ov), nested)])
    for (part in intersect(nested, names(ov))) {
      merged[[part]] <- utils::modifyList(base[[part]] %||% list(), ov[[part]])
    }
    defaults[[role]] <- merged
  }
  defaults
}

#' Look up one role
#' @noRd
resolve_placeholder_role <- function(role, layouts) {
  spec <- layouts[[role]]
  if (is.null(spec)) {
    stop(
      "Unknown placeholder layout role \"", role, "\". Known roles: ",
      paste(names(layouts), collapse = ", "), ".",
      call. = FALSE
    )
  }
  if (is.null(spec$layout) || is.null(spec$master)) {
    stop("Placeholder layout role \"", role, "\" must supply both `layout` and `master`.", call. = FALSE)
  }
  spec
}

#' Fields a role has a placeholder for
#' @noRd
role_fields <- function(spec) {
  union(names(spec$labels), names(spec$types))
}

#' officer location for one field of a role
#' @noRd
placeholder_location <- function(spec, key) {
  if (!is.null(spec$labels[[key]])) {
    return(officer::ph_location_label(spec$labels[[key]]))
  }
  officer::ph_location_type(type = spec$types[[key]])
}

#' Map text fields onto the placeholders a role has
#'
#' Drops `NULL` fields, sends fields without a placeholder to their fallback
#' (in field order, so `subtitle` lands before `text`), substitutes `{token}`s
#' when `metadata` is given, and flattens YAML lists to character vectors.
#'
#' @noRd
resolve_placeholder_fields <- function(fields, spec, role, metadata = NULL) {
  slots <- role_fields(spec)
  out <- list()
  for (key in names(fields)) {
    value <- fields[[key]]
    if (is.null(value)) {
      next
    }
    value <- as.character(unlist(value))
    if (!is.null(metadata)) {
      value <- vapply(value, apply_tokens, character(1), metadata = metadata, USE.NAMES = FALSE)
    }
    target <- if (key %in% slots) key else spec$fallbacks[[key]]
    if (is.null(target) || !target %in% slots) {
      fallback_note <- if (length(spec$fallbacks)) {
        paste0(" (", paste(names(spec$fallbacks), "goes into", unlist(spec$fallbacks), collapse = ", "), ")")
      } else {
        ""
      }
      stop(
        "Placeholder layout role \"", role, "\" (layout \"", spec$layout, "\") has no placeholder for `",
        key, "`. Available: ", paste0("`", slots, "`", collapse = ", "), fallback_note, ".",
        call. = FALSE
      )
    }
    out[[target]] <- c(out[[target]], value)
  }
  out
}

#' Check that a template has the layouts and placeholders of some roles
#'
#' Confirms every requested role resolves to a layout that exists in the
#' template, and that each placeholder label or type the role writes into exists
#' in that layout. Problems are reported together, with the layouts the
#' template does have, before any slide is added.
#'
#' @param x An `officer::rpptx` object or a path to a `.pptx` file.
#' @param roles Roles to check. Defaults to all roles in `layouts`.
#' @param layouts The role lookup, see [placeholder_layouts()].
#'
#' @return Invisibly `TRUE`; otherwise an error.
#'
#' @export
#'
#' @examples
#' validate_placeholder_layouts(system.file("theme/basic.pptx", package = "autoslider.core"))
validate_placeholder_layouts <- function(x, roles = names(layouts), layouts = placeholder_layouts()) {
  doc <- if (inherits(x, "rpptx")) x else officer::read_pptx(x)
  available <- officer::layout_summary(doc)
  problems <- character(0)

  for (role in roles) {
    spec <- resolve_placeholder_role(role, layouts)
    if (!any(available$layout == spec$layout & available$master == spec$master)) {
      problems <- c(problems, sprintf(
        "  - role \"%s\": layout \"%s\" in master \"%s\" is missing", role, spec$layout, spec$master
      ))
      next
    }
    props <- officer::layout_properties(doc, layout = spec$layout, master = spec$master)
    absent_labels <- setdiff(unlist(spec$labels, use.names = FALSE), props$ph_label)
    absent_types <- setdiff(unlist(spec$types, use.names = FALSE), props$type)
    if (length(absent_labels)) {
      problems <- c(problems, sprintf(
        "  - role \"%s\" (layout \"%s\"): no placeholder labelled %s", role, spec$layout,
        paste0("\"", absent_labels, "\"", collapse = ", ")
      ))
    }
    if (length(absent_types)) {
      problems <- c(problems, sprintf(
        "  - role \"%s\" (layout \"%s\"): no placeholder of type %s", role, spec$layout,
        paste0("\"", absent_types, "\"", collapse = ", ")
      ))
    }
  }

  if (length(problems) == 0) {
    return(invisible(TRUE))
  }
  by_master <- split(available$layout, available$master)
  stop(
    "This template does not have the layouts the placeholder slides need:\n",
    paste(problems, collapse = "\n"), "\n\nAvailable layouts:\n",
    paste(sprintf("  [%s] %s", names(by_master), vapply(by_master, paste, "", collapse = " | ")), collapse = "\n"),
    "\n\nPoint the role at an existing layout with `layouts = placeholder_layouts(list(<role> = ",
    "list(layout = ...)))`, or the `autoslider.core.placeholder_layouts` option.",
    call. = FALSE
  )
}

# --- adding slides ----------------------------------------------------------------

#' Describe one placeholder slide
#'
#' Used with [append_placeholder_slides()] to build placeholder slide types.
#'
#' @param role A layout role (see [placeholder_layouts()]).
#' @param ... Text for the role's fields, e.g. `title =`, `subtitle =`,
#'   `text =`. Each value may be a character vector or a list (one paragraph per
#'   element). `NULL` leaves that placeholder empty.
#' @param to_page A fixed page for this slide. `NULL` (the default) places it
#'   after the previous slide described in the same call.
#'
#' @return A `list` describing the slide.
#'
#' @export
#'
#' @examples
#' placeholder_slide("section", title = "Safety", text = "Data cut-off: 01-JAN-2026")
placeholder_slide <- function(role, ..., to_page = NULL) {
  assert_that(is.string(role))
  list(role = role, fields = list(...), to_page = to_page)
}

#' Write text into placeholders
#' @param location Function turning a field name into an officer location.
#' @noRd
fill_placeholders <- function(doc, fields, location) {
  for (key in names(fields)) {
    if (!is.null(fields[[key]])) {
      doc <- officer::ph_with(doc, value = as.character(unlist(fields[[key]])), location = location(key))
    }
  }
  doc
}

#' Resolve `to_page` for slides being inserted
#'
#' `NA` means after the last slide. Unlike [initialize_to_page()], which returns
#' the page of the current last slide, the result is where the first new slide
#' ends up.
#'
#' @noRd
placeholder_start_page <- function(doc, to_page) {
  last <- length(doc) + 1L
  if (is.null(to_page) || is.na(to_page)) {
    return(last)
  }
  assert_that(is.count(to_page))
  if (to_page > last) {
    stop("`to_page` is ", to_page, " but the deck has only ", length(doc), " slide(s).", call. = FALSE)
  }
  as.integer(to_page)
}

#' Insert placeholder slides
#'
#' The building block behind every placeholder slide type: checks the template
#' has the layouts the slides use, adds each slide described by
#' [placeholder_slide()], fills its placeholders and moves it into place, then
#' optionally saves the deck.
#'
#' @param doc_o Path to the `.pptx` file. Read when `doc_original` is `NULL`,
#'   and used to name the saved file.
#' @param slides A `list` of [placeholder_slide()] descriptions, inserted in
#'   order.
#' @param to_page Page for the first slide; the others follow it. `NA` appends
#'   after the last slide.
#' @param doc_original An optional `officer::rpptx` object to add to.
#' @param save_file If `TRUE`, the deck is saved next to `doc_o` with a
#'   `_<type>` suffix.
#' @param layouts The role lookup, see [placeholder_layouts()].
#' @param metadata Optional named `list` of values for `{token}`s in the text,
#'   see [apply_tokens()].
#' @param type Suffix for the saved file.
#'
#' @return The modified `officer::rpptx` object.
#'
#' @export
#'
#' @examples
#' deck <- tempfile(fileext = ".pptx")
#' print(officer::read_pptx(system.file("theme/basic.pptx", package = "autoslider.core")), deck)
#'
#' doc <- append_placeholder_slides(deck, list(
#'   placeholder_slide("section", title = "{study} safety", text = "Data cut-off: 01-JAN-2026"),
#'   placeholder_slide("title_content", title = "Key findings", content = c("Point 1", "Point 2"))
#' ), metadata = list(study = "BP12345"))
#' length(doc)
append_placeholder_slides <- function(doc_o,
                                      slides,
                                      to_page = NA,
                                      doc_original = NULL,
                                      save_file = FALSE,
                                      layouts = placeholder_layouts(),
                                      metadata = NULL,
                                      type = "placeholder") {
  assert_that(
    is.list(slides) && length(slides) > 0 && all(vapply(slides, is.list, logical(1))),
    msg = "`slides` must be a non-empty list of placeholder_slide() descriptions."
  )
  assert_that(is.flag(save_file), noNA(save_file))
  doc <- initialize_doc_original(doc_original, doc_o)

  roles <- unique(vapply(slides, function(sl) sl$role, character(1)))
  validate_placeholder_layouts(doc, roles = roles, layouts = layouts)
  # Resolve every slide's text before adding any, so a bad field fails cleanly.
  specs <- lapply(slides, function(sl) resolve_placeholder_role(sl$role, layouts))
  fields <- Map(function(sl, spec) resolve_placeholder_fields(sl$fields, spec, sl$role, metadata), slides, specs)
  start <- placeholder_start_page(doc, to_page)

  for (i in seq_along(slides)) {
    spec <- specs[[i]]
    doc <- officer::add_slide(doc, layout = spec$layout, master = spec$master)
    doc <- fill_placeholders(doc, fields[[i]], function(key) placeholder_location(spec, key))
    doc <- officer::move_slide(doc, to = slides[[i]]$to_page %||% (start + i - 1L))
  }

  postprocessing_doc(doc, save_file, doc_o, type = type)
}

#' Append a section divider slide
#'
#' Adds one slide on the `section` layout role ("Section Header" in
#' `basic.pptx`) with a title and text. That layout has no subtitle
#' placeholder: a `subtitle` is placed in the text box, above `text`, so
#' speclayouts written for templates that do have a subtitle keep all their
#' text. This backs the `section` placeholder type:
#'
#' ```yaml
#' sec_safety:
#'   type: section
#'   title: Safety Summary
#'   subtitle: "Data cut-off: {cutoff_date}"
#'   text:
#'     - All treated patients
#' ```
#'
#' @inheritParams append_placeholder_slides
#' @param title,subtitle,text Text for the slide. Each may be a character vector
#'   or a list, one paragraph per element. `NULL` leaves it out.
#' @param section_title Older name for `title`, used when `title` is `NULL`.
#' @param role The layout role to use.
#'
#' @return The modified `officer::rpptx` object.
#'
#' @seealso [append_section_header_slides()] for the older title-only version.
#'
#' @export
#'
#' @examples
#' deck <- tempfile(fileext = ".pptx")
#' print(officer::read_pptx(system.file("theme/basic.pptx", package = "autoslider.core")), deck)
#' doc <- append_section_slides(deck, title = "Safety", subtitle = "Data cut-off: 01-JAN-2026")
#' officer::slide_summary(doc, index = length(doc))$text
append_section_slides <- function(doc_o,
                                  title = NULL,
                                  subtitle = NULL,
                                  text = NULL,
                                  section_title = NULL,
                                  to_page = NA,
                                  doc_original = NULL,
                                  save_file = FALSE,
                                  layouts = placeholder_layouts(),
                                  metadata = NULL,
                                  role = "section") {
  slides <- list(placeholder_slide(role, title = title %||% section_title, subtitle = subtitle, text = text))
  append_placeholder_slides(doc_o, slides,
    to_page = to_page, doc_original = doc_original, save_file = save_file,
    layouts = layouts, metadata = metadata, type = "section"
  )
}

#' Append a slide on any layout
#'
#' Adds one slide on `layout` and fills the placeholders named in
#' `placeholders` (by label, the `ph_label` column of
#' [officer::layout_properties()]). This backs the `custom` placeholder type,
#' so a study can add its own slide without writing R code:
#'
#' ```yaml
#' sec_rationale:
#'   type: custom
#'   layout: Section Header
#'   placeholders:
#'     Title 1: Dose Rationale
#'     Text Placeholder 2:
#'       - Cohort 3 opened at 20 mg QW
#' ```
#'
#' @param doc_o Path to the `.pptx` file.
#' @param layout Name of the layout to use.
#' @param master Name of the slide master. Only needed when the layout name
#'   exists in more than one master.
#' @param placeholders A named list mapping placeholder labels to text. Each
#'   value may be a character vector or a list (one paragraph per element).
#' @param to_page Page to move the new slide to. `NA` appends at the end.
#' @param doc_original An optional existing `officer::rpptx` object. If `NULL`,
#'   the document is read from `doc_o`.
#' @param save_file A logical. If `TRUE`, the deck is written next to `doc_o`.
#'
#' @return The modified `officer::rpptx` object.
#'
#' @export
#'
#' @examples
#' deck <- tempfile(fileext = ".pptx")
#' print(officer::read_pptx(system.file("theme/basic.pptx", package = "autoslider.core")), deck)
#' doc <- append_custom_slides(deck,
#'   layout = "Section Header",
#'   placeholders = list("Title 1" = "Dose Rationale", "Text Placeholder 2" = "Cohort 3")
#' )
#' length(doc)
append_custom_slides <- function(doc_o,
                                 layout,
                                 master = NULL,
                                 placeholders = list(),
                                 to_page = NA,
                                 doc_original = NULL,
                                 save_file = FALSE) {
  doc <- initialize_doc_original(doc_original, doc_o)
  master <- validate_custom_placeholder(doc, layout, master, placeholders)
  to_page <- placeholder_start_page(doc, to_page)

  doc <- officer::add_slide(doc, layout = layout, master = master)
  doc <- fill_placeholders(doc, placeholders, officer::ph_location_label)
  doc <- officer::move_slide(doc, to = to_page)

  postprocessing_doc(doc, save_file, doc_o, type = "custom")
}

#' Check a custom placeholder definition against the template
#' @return The resolved master name.
#' @noRd
validate_custom_placeholder <- function(doc, layout, master = NULL, placeholders = list(), name = NULL) {
  where <- if (is.null(name)) "custom placeholder" else paste0("custom placeholder '", name, "'")
  if (!is.string(layout) || is.na(layout)) {
    stop("The ", where, " needs a `layout` (the name of a layout in the template).", call. = FALSE)
  }
  if (length(placeholders) && !has_entry_names(placeholders)) {
    stop(
      "`placeholders` in the ", where, " must map placeholder labels to text, ",
      "e.g. `Title 1: My title`.",
      call. = FALSE
    )
  }

  available <- officer::layout_summary(doc)
  masters <- available$master[available$layout == layout]
  if (!is.null(master)) {
    masters <- intersect(masters, master)
  }
  if (length(masters) == 0) {
    by_master <- split(available$layout, available$master)
    stop(
      "Layout \"", layout, "\"", if (!is.null(master)) paste0(" in master \"", master, "\""),
      " used by the ", where, " is not in the template. Available layouts:\n",
      paste(sprintf("  [%s] %s", names(by_master), vapply(by_master, paste, "", collapse = " | ")),
        collapse = "\n"
      ),
      call. = FALSE
    )
  }
  if (length(masters) > 1) {
    stop(
      "Layout \"", layout, "\" used by the ", where, " exists in several masters (",
      paste0("\"", masters, "\"", collapse = ", "), "). Set `master` to choose one.",
      call. = FALSE
    )
  }

  labels <- officer::layout_properties(doc, layout = layout, master = masters)$ph_label
  absent <- setdiff(names(placeholders), labels)
  if (length(absent)) {
    stop(
      "Placeholder label(s) ", paste0("\"", absent, "\"", collapse = ", "),
      " used by the ", where, " are not in layout \"", layout, "\". Available labels: ",
      paste0("\"", labels, "\"", collapse = ", "), ".",
      call. = FALSE
    )
  }

  masters
}

# --- placeholder types and the speclayout engine -----------------------------------

#' Built-in placeholder types
#' @noRd
placeholder_type_defaults <- function() {
  list(
    section = list(fn = append_section_slides, n = 1L, roles = "section"),
    title = list(fn = append_title_slides, n = 1L, roles = character(0)),
    custom = list(fn = append_custom_slides, n = 1L, roles = character(0))
  )
}

#' Placeholder slide types
#'
#' Maps each placeholder `type:` used in a speclayout to the function that
#' inserts it (`fn`), the number of slides it adds (`n`, used to place later
#' slides) and the layout roles it uses (`roles`, checked before any slide is
#' inserted).
#'
#' Add types for a session through the option named by `option`, or pass them
#' as `extra`. Each entry is a function or `list(fn = , n = , roles = )`;
#' `n` defaults to 1. The function must accept `doc_o`, `doc_original`,
#' `to_page` and `save_file`, and return the `officer::rpptx` object. Other
#' fields of the speclayout entry are passed on when the function has an
#' argument of that name, as are `layouts` and `metadata`. A type with the
#' same name as a built-in one replaces it.
#'
#' @param extra A named `list` of additional types. Defaults to the option
#'   named by `option`.
#' @param builtin The types to start from.
#' @param option Name of the option holding session-wide types.
#'
#' @return A named `list` of types, each `list(fn, n, roles)`.
#'
#' @export
#'
#' @examples
#' names(placeholder_types())
#'
#' # A study type that adds two section slides
#' two_sections <- function(doc_o, label = "Part", to_page = NA, doc_original = NULL, save_file = FALSE) {
#'   append_placeholder_slides(doc_o, list(
#'     placeholder_slide("section", title = paste(label, "A")),
#'     placeholder_slide("section", title = paste(label, "B"))
#'   ), to_page = to_page, doc_original = doc_original, save_file = save_file)
#' }
#' names(placeholder_types(list(two_sections = list(fn = two_sections, n = 2, roles = "section"))))
placeholder_types <- function(extra = getOption(option, list()),
                              builtin = placeholder_type_defaults(),
                              option = "autoslider.core.placeholder_types") {
  if (length(extra) == 0) {
    return(builtin)
  }
  assert_that(has_entry_names(extra),
    msg = paste0("`", option, "` must be a list whose elements all have unique, non-empty names.")
  )
  for (type in names(extra)) {
    entry <- extra[[type]]
    if (is.function(entry)) {
      entry <- list(fn = entry)
    }
    if (!is.list(entry) || !is.function(entry$fn)) {
      stop(
        "`", option, "$", type, "` must be a function or a ",
        "list(fn = <function>, n = <slides added>).",
        call. = FALSE
      )
    }
    entry$n <- as.integer(entry$n %||% 1L)
    entry$roles <- entry$roles %||% character(0)
    builtin[[type]] <- entry
  }
  builtin
}

#' Split an ordered speclayout into content and placeholder entries
#'
#' Partitions a speclayout (as read by [yaml::read_yaml()]) into the TLG
#' entries (those with a `program`) and the placeholder entries (those with a
#' `type` and no `program`), keeping file order. Anything else (e.g. a
#' `defaults:` block) is returned under `other`.
#'
#' @param speclayout A named `list` read from a speclayout yaml file.
#'
#' @return A `list` with named-list elements `content`, `placeholders` and
#'   `other`.
#'
#' @export
#'
#' @examples
#' speclayout <- list(
#'   sec_overview = list(type = "section", title = "Overview"),
#'   t_dm_slide_FAS = list(program = "t_dm_slide", suffix = "FAS"),
#'   defaults = list(common = list(layout = "Title and Content"))
#' )
#' split_speclayout(speclayout)
split_speclayout <- function(speclayout) {
  assert_that(has_entry_names(speclayout, unique = FALSE))
  is_placeholder <- vapply(
    speclayout,
    function(e) is.list(e) && !is.null(e$type) && is.null(e$program),
    logical(1)
  )
  is_content <- vapply(speclayout, function(e) is.list(e) && !is.null(e$program), logical(1))
  list(
    content = speclayout[is_content],
    placeholders = speclayout[is_placeholder],
    other = speclayout[!is_placeholder & !is_content]
  )
}

#' Derive placeholder pages from speclayout order
#'
#' Walks an ordered speclayout and, for every placeholder entry, computes the
#' page it must be inserted at so its position among the TLG slides matches its
#' position in the file:
#' `content slides so far + placeholder slides already inserted + 1`.
#'
#' @param speclayout A named, ordered `list` read from a speclayout yaml file.
#' @param content_counts Optional named list of the number of slides each TLG
#'   entry produced. When given, entries missing from it count as 0 slides
#'   (not generated); when `NULL`, every TLG entry counts as one slide.
#' @param types The placeholder types, see [placeholder_types()].
#'
#' @return A `list` of placeholder entries in insertion order, each with its
#'   `name` and resolved `to_page`.
#'
#' @export
#'
#' @examples
#' speclayout <- list(
#'   sec_a = list(type = "section", title = "Section A"),
#'   out1 = list(program = "t_dm_slide", suffix = "FAS"),
#'   out2 = list(program = "t_ae_slide", suffix = "SE"),
#'   sec_b = list(type = "section", title = "Section B")
#' )
#' vapply(derive_placeholder_page_list(speclayout), function(p) p$to_page, integer(1))
derive_placeholder_page_list <- function(speclayout, content_counts = NULL, types = placeholder_types()) {
  assert_that(has_entry_names(speclayout, unique = FALSE))
  content_slides <- 0L
  placeholder_slides <- 0L
  page_list <- list()

  for (nm in names(speclayout)) {
    entry <- speclayout[[nm]]
    if (!is.list(entry)) {
      next
    }
    if (!is.null(entry$type) && is.null(entry$program)) {
      if (is.null(types[[entry$type]])) {
        stop(
          "Unknown placeholder type '", entry$type, "' in speclayout entry '", nm,
          "'. Known types: ", paste(names(types), collapse = ", "), ".",
          call. = FALSE
        )
      }
      entry$name <- nm
      entry$to_page <- content_slides + placeholder_slides + 1L
      page_list[[length(page_list) + 1L]] <- entry
      placeholder_slides <- placeholder_slides + types[[entry$type]]$n
    } else if (!is.null(entry$program)) {
      # With counts, a missing entry was not generated (0 slides); without
      # counts, each TLG entry is assumed to produce one slide.
      count <- content_counts[[nm]] %||% if (is.null(content_counts)) 1L else 0L
      content_slides <- content_slides + as.integer(count)
    }
  }
  page_list
}

#' Insert one placeholder from the page list
#' @noRd
append_placeholder <- function(doc, doc_o, placeholder, types, layouts, metadata) {
  fn <- types[[placeholder$type]]$fn
  fn_args <- names(formals(fn))

  control_keys <- c("type", "name", "program", "suffix", "to_page")
  forwarded <- placeholder[setdiff(names(placeholder), control_keys)]
  call_args <- forwarded[names(forwarded) %in% fn_args]

  call_args$doc_o <- doc_o
  call_args$doc_original <- doc
  call_args$to_page <- placeholder$to_page
  call_args$save_file <- FALSE
  if ("layouts" %in% fn_args) {
    call_args$layouts <- layouts
  }
  if ("metadata" %in% fn_args && !is.null(metadata)) {
    call_args$metadata <- metadata
  }
  do.call(fn, call_args)
}

#' Place placeholder slides by their order in a speclayout
#'
#' Inserts the placeholder entries of a speclayout (those with a `type:`, such
#' as `section` or `custom`) into an already generated deck, at pages derived
#' from their position among the TLG entries. No page numbers need to be typed.
#'
#' The deck at `doc_o` must hold exactly the TLG slides of the speclayout, in
#' order (the shipped `basic.pptx` theme has one empty slide; remove it or
#' include it in `content_counts`).
#'
#' @param doc_o Path to the `.pptx` holding the generated TLG slides.
#' @param speclayout A named, ordered `list` read from a speclayout yaml file,
#'   with placeholder entries between the TLG entries.
#' @param content_counts Optional slides per TLG entry, see
#'   [derive_placeholder_page_list()].
#' @param doc_original An optional `officer::rpptx` object. If `NULL`, the deck
#'   is read from `doc_o`.
#' @param save_file If `TRUE`, the finished deck is written next to `doc_o`.
#' @param layouts The role lookup, see [placeholder_layouts()].
#' @param types The placeholder types, see [placeholder_types()].
#' @param metadata Optional named `list` of values for `{token}`s, passed to
#'   placeholder functions that accept `metadata`.
#'
#' @return The `officer::rpptx` object with the placeholder slides inserted.
#'
#' @export
#'
#' @examples
#' deck <- officer::read_pptx(system.file("theme/basic.pptx", package = "autoslider.core"))
#' deck <- officer::remove_slide(deck, index = 1)
#' for (i in 1:2) {
#'   deck <- officer::add_slide(deck, layout = "Title and Content", master = "Office Theme")
#' }
#' content <- tempfile(fileext = ".pptx")
#' print(deck, content)
#'
#' speclayout <- list(
#'   sec_dm = list(type = "section", title = "Demographics", subtitle = "{study}"),
#'   t_dm_slide_FAS = list(program = "t_dm_slide", suffix = "FAS"),
#'   sec_ae = list(type = "section", title = "Adverse Events"),
#'   t_ae_slide_SE = list(program = "t_ae_slide", suffix = "SE")
#' )
#' doc <- place_speclayout_placeholders(content, speclayout, metadata = list(study = "BP12345"))
#' length(doc)
place_speclayout_placeholders <- function(doc_o,
                                          speclayout,
                                          content_counts = NULL,
                                          doc_original = NULL,
                                          save_file = FALSE,
                                          layouts = placeholder_layouts(),
                                          types = placeholder_types(),
                                          metadata = NULL) {
  assert_that(is.string(doc_o))
  assert_that(has_entry_names(speclayout, unique = FALSE))
  assert_that(is.flag(save_file), noNA(save_file))

  doc <- initialize_doc_original(doc_original, doc_o)
  page_list <- derive_placeholder_page_list(speclayout, content_counts, types = types)

  # Check every layout the placeholders need before inserting any slide.
  needed_roles <- unique(unlist(lapply(page_list, function(p) types[[p$type]]$roles)))
  if (length(needed_roles) > 0) {
    validate_placeholder_layouts(doc, roles = needed_roles, layouts = layouts)
  }
  for (p in page_list) {
    if (identical(p$type, "custom")) {
      validate_custom_placeholder(doc, p$layout, p$master, p$placeholders %||% list(), name = p$name)
    }
  }

  for (placeholder in page_list) {
    doc <- append_placeholder(doc, doc_o, placeholder, types = types, layouts = layouts, metadata = metadata)
  }

  postprocessing_doc(doc, save_file, doc_o, type = "final")
}
