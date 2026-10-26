# Copy slide layouts between PowerPoint templates
# ------------------------------------------------------------------------------
# A study theme often ships only its content layout, while placeholder pages
# (cover, section dividers) use layouts from another template. officer can only
# add slides on layouts that exist in the deck it writes and cannot copy layouts
# between presentations, so `import_layouts()` edits the package XML directly to
# build a mixed template.

pptx_ns <- c(
  p = "http://schemas.openxmlformats.org/presentationml/2006/main",
  r = "http://schemas.openxmlformats.org/officeDocument/2006/relationships",
  pr = "http://schemas.openxmlformats.org/package/2006/relationships",
  a = "http://schemas.openxmlformats.org/drawingml/2006/main",
  ct = "http://schemas.openxmlformats.org/package/2006/content-types"
)

#' Import slide layouts from another PowerPoint template
#'
#' Copies one or more slide layouts, together with the images they use, from
#' `source` into `target` and writes the result to `outfile`. This builds a
#' mixed template: content slides keep the study theme's own layouts, and
#' placeholder pages can use layouts that only exist in another template, such
#' as a corporate theme with cover and divider layouts.
#'
#' Each imported layout is attached to the master in `target` with the same
#' name as its master in `source`, or to `master` when given. The layout keeps its own shapes, placeholders and
#' images; theme colors and fonts come from the target master. Layouts that
#' `target` already has are skipped, so the call is safe to repeat.
#'
#' Masters are not copied: a layout whose master is missing from `target`
#' raises an error unless `master` names a master that `target` does have.
#'
#' @param target Path to the template to extend (it is not modified).
#' @param source Path to the template holding the layouts to copy.
#' @param layouts Character vector of layout names to copy from `source`.
#' @param outfile Path of the `.pptx` to write. Defaults to a temporary file.
#' @param master Optional name of the master in `target` to attach the layouts
#'   to. By default each layout goes to the target master with the same name as
#'   its source master.
#'
#' @return The path to `outfile`, invisibly.
#'
#' @seealso [place_speclayout_placeholders()]
#'
#' @export
#'
#' @examples
#' \donttest{
#' # officer's default template lacks the "Content with Caption" layout that
#' # autoslider.core's basic.pptx has; both use the "Office Theme" master.
#' mixed <- import_layouts(
#'   target = system.file("template/template.pptx", package = "officer"),
#'   source = system.file("theme/basic.pptx", package = "autoslider.core"),
#'   layouts = "Content with Caption"
#' )
#' officer::layout_summary(officer::read_pptx(mixed))
#' }
#' @md
import_layouts <- function(target, source, layouts, outfile = tempfile(fileext = ".pptx"), master = NULL) {
  assert_that(is.string(target), is.readable(target), has_extension(target, "pptx"))
  assert_that(is.string(source), is.readable(source), has_extension(source, "pptx"))
  assert_that(is.character(layouts), length(layouts) > 0, noNA(layouts))
  assert_that(!anyDuplicated(layouts), msg = "`layouts` must not repeat a layout name.")
  assert_that(is.string(outfile), has_extension(outfile, "pptx"), is.writeable(dirname(outfile)))
  assert_that(is.null(master) || is.string(master), msg = "`master` must be NULL or a single string.")

  src <- tempfile("pptx_src_")
  dst <- tempfile("pptx_dst_")
  on.exit(unlink(c(src, dst), recursive = TRUE), add = TRUE)
  utils::unzip(source, exdir = src)
  utils::unzip(target, exdir = dst)

  src_layouts <- pptx_part_names(src, "slideLayouts", "/p:sldLayout/p:cSld")
  dst_layouts <- pptx_part_names(dst, "slideLayouts", "/p:sldLayout/p:cSld")
  dst_masters <- pptx_master_names(dst)

  missing <- setdiff(layouts, names(src_layouts))
  if (length(missing)) {
    stop(
      "Layout(s) ", paste0("\"", missing, "\"", collapse = ", "), " not found in `source`. Available: ",
      paste0("\"", names(src_layouts), "\"", collapse = ", "), ".",
      call. = FALSE
    )
  }
  present <- intersect(layouts, names(dst_layouts))
  if (length(present)) {
    message("Already in `target`, not imported: ", paste(present, collapse = ", "))
  }

  ct_file <- file.path(dst, "[Content_Types].xml")
  ct_doc <- xml2::read_xml(ct_file)
  src_ct <- xml2::read_xml(file.path(src, "[Content_Types].xml"))

  for (lay in setdiff(layouts, present)) {
    dst_master <- pptx_target_master(src, src_layouts[[lay]], dst_masters, master, lay)
    import_one_layout(src, dst, src_layouts[[lay]], dst_master, ct_doc, src_ct)
  }
  xml2::write_xml(ct_doc, ct_file)

  pptx_zip_dir(dst, outfile)
  invisible(outfile)
}

#' Map part names to their `name` attribute for one part folder
#'
#' @return A named character vector: names are layout/master names, values are
#'   package-relative part paths (e.g. `ppt/slideLayouts/slideLayout4.xml`).
#'
#' @noRd
pptx_part_names <- function(dir, sub, xpath) {
  files <- list.files(file.path(dir, "ppt", sub), pattern = "\\.xml$", full.names = TRUE)
  nm <- vapply(files, function(f) {
    xml2::xml_attr(xml2::xml_find_first(xml2::read_xml(f), xpath, pptx_ns), "name")
  }, character(1))
  stats::setNames(file.path("ppt", sub, basename(files)), nm)
}

#' Map master names to their parts, named the way officer names them
#'
#' officer's `layout_summary()` reports a master by the name of the theme it
#' uses (`<a:theme name=...>`), not by the master's own `cSld` name, which is
#' often empty or a leftover such as "simple-light-2". Use the same rule so
#' `master` matches what users see.
#'
#' @noRd
pptx_master_names <- function(dir) {
  files <- list.files(file.path(dir, "ppt", "slideMasters"), pattern = "\\.xml$", full.names = TRUE)
  parts <- file.path("ppt", "slideMasters", basename(files))
  nm <- vapply(parts, function(part) pptx_master_name(dir, part), character(1))
  stats::setNames(parts, nm)
}

#' officer-style name of one master part
#' @noRd
pptx_master_name <- function(dir, master_part) {
  rels <- xml2::read_xml(pptx_rels_path(dir, master_part))
  rel <- xml2::xml_find_first(rels, "//pr:Relationship[contains(@Type, '/theme')]", pptx_ns)
  theme <- normalizePath(file.path(dir, dirname(master_part), xml2::xml_attr(rel, "Target")))
  xml2::xml_attr(xml2::xml_find_first(xml2::read_xml(theme), "/a:theme", pptx_ns), "name")
}

#' Path of the `.rels` file belonging to a package part
#' @noRd
pptx_rels_path <- function(dir, part) {
  file.path(dir, dirname(part), "_rels", paste0(basename(part), ".rels"))
}

#' Resolve which target master a source layout attaches to
#' @noRd
pptx_target_master <- function(src, src_part, dst_masters, master, layout) {
  rels <- xml2::read_xml(pptx_rels_path(src, src_part))
  rel <- xml2::xml_find_first(rels, "//pr:Relationship[contains(@Type, '/slideMaster')]", pptx_ns)
  src_master_part <- file.path("ppt", "slideMasters", basename(xml2::xml_attr(rel, "Target")))
  want <- master %||% pptx_master_name(src, src_master_part)
  if (!want %in% names(dst_masters)) {
    stop(
      "Layout \"", layout, "\" needs master \"", want, "\", which `target` does not have. ",
      "Masters in `target`: ", paste0("\"", names(dst_masters), "\"", collapse = ", "),
      ". Set `master` to attach the layout to one of them.",
      call. = FALSE
    )
  }
  dst_masters[[want]]
}

#' Copy one layout part (and the files it references) into the target package
#'
#' Modifies the extracted target folder `dst` in place and adds content types to
#' `ct_doc` (an xml2 document, modified by reference).
#'
#' @noRd
import_one_layout <- function(src, dst, src_part, dst_master_part, ct_doc, src_ct) {
  rel_layout <- "http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout"
  layout_ct <- "application/vnd.openxmlformats-officedocument.presentationml.slideLayout+xml"

  # 1. Copy the layout part under the next free slideLayoutN.xml name.
  existing <- list.files(file.path(dst, "ppt", "slideLayouts"), pattern = "^slideLayout[0-9]+\\.xml$")
  n_next <- max(c(0L, as.integer(gsub("\\D", "", existing)))) + 1L
  new_part <- file.path("ppt", "slideLayouts", paste0("slideLayout", n_next, ".xml"))
  file.copy(file.path(src, src_part), file.path(dst, new_part))

  # 2. Rewrite its relationships: the master link points at the target master,
  #    every other internal file (images, ...) is copied under a unique name so
  #    it cannot overwrite a file of the same name in the target.
  rels <- xml2::read_xml(pptx_rels_path(src, src_part))
  prefix <- paste0("imported_", tools::file_path_sans_ext(basename(new_part)), "_")
  for (rel in xml2::xml_children(rels)) {
    if (identical(xml2::xml_attr(rel, "TargetMode"), "External")) {
      next
    }
    if (grepl("/slideMaster$", xml2::xml_attr(rel, "Type"))) {
      xml2::xml_set_attr(rel, "Target", paste0("../slideMasters/", basename(dst_master_part)))
      next
    }
    from <- normalizePath(file.path(src, dirname(src_part), xml2::xml_attr(rel, "Target")))
    folder <- basename(dirname(from))
    new_name <- paste0(prefix, basename(from))
    dir.create(file.path(dst, "ppt", folder), showWarnings = FALSE)
    file.copy(from, file.path(dst, "ppt", folder, new_name))
    xml2::xml_set_attr(rel, "Target", paste0("../", folder, "/", new_name))
    pptx_ensure_default_ct(ct_doc, src_ct, tools::file_ext(from))
  }
  dir.create(dirname(pptx_rels_path(dst, new_part)), showWarnings = FALSE)
  xml2::write_xml(rels, pptx_rels_path(dst, new_part))

  # 3. Register the layout with the master: a relationship plus a sldLayoutId.
  m_rels_file <- pptx_rels_path(dst, dst_master_part)
  m_rels <- xml2::read_xml(m_rels_file)
  rid_nums <- as.integer(sub("^rId", "", xml2::xml_attr(xml2::xml_children(m_rels), "Id")))
  rid <- paste0("rId", max(c(0L, rid_nums), na.rm = TRUE) + 1L)
  xml2::xml_add_child(m_rels, "Relationship",
    Id = rid, Type = rel_layout, Target = paste0("../slideLayouts/", basename(new_part))
  )
  xml2::write_xml(m_rels, m_rels_file)

  m_file <- file.path(dst, dst_master_part)
  m_doc <- xml2::read_xml(m_file)
  node <- xml2::xml_add_child(
    xml2::xml_find_first(m_doc, "//p:sldLayoutIdLst", pptx_ns),
    "p:sldLayoutId",
    id = sprintf("%.0f", pptx_max_layout_id(dst) + 1)
  )
  xml2::xml_set_attr(node, "r:id", rid)
  xml2::write_xml(m_doc, m_file)

  # 4. Declare the new part's content type.
  xml2::xml_add_child(ct_doc, "Override", PartName = paste0("/", new_part), ContentType = layout_ct)
  invisible(new_part)
}

#' Largest slide master / layout id in an extracted package
#'
#' Master and layout ids share one number space and must be unique, so a new
#' layout takes the largest one plus one.
#'
#' @noRd
pptx_max_layout_id <- function(dir) {
  masters <- list.files(file.path(dir, "ppt", "slideMasters"), pattern = "\\.xml$", full.names = TRUE)
  ids <- unlist(lapply(masters, function(m) {
    xml2::xml_attr(xml2::xml_find_all(xml2::read_xml(m), "//p:sldLayoutId", pptx_ns), "id")
  }))
  pres <- xml2::read_xml(file.path(dir, "ppt", "presentation.xml"))
  ids <- c(ids, xml2::xml_attr(xml2::xml_find_all(pres, "//p:sldMasterId", pptx_ns), "id"))
  max(as.numeric(ids))
}

#' Make sure the target declares a content type for a file extension
#' @noRd
pptx_ensure_default_ct <- function(ct_doc, src_ct, ext) {
  # Extensions are case-insensitive ("png" vs "PNG"), so compare lower-cased.
  lower <- "translate(@Extension, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"
  xpath <- sprintf("//ct:Default[%s='%s']", lower, tolower(ext))
  if (length(xml2::xml_find_all(ct_doc, xpath, pptx_ns))) {
    return(invisible(ct_doc))
  }
  def <- xml2::xml_find_first(src_ct, xpath, pptx_ns)
  if (!inherits(def, "xml_missing")) {
    xml2::xml_add_child(ct_doc, def, .where = 0)
  }
  invisible(ct_doc)
}

#' Zip an extracted package folder back into a .pptx
#'
#' Uses the `zip` package (no external zip program needed) and writes
#' `[Content_Types].xml` first, as Office expects.
#'
#' @noRd
pptx_zip_dir <- function(dir, outfile) {
  files <- list.files(dir, recursive = TRUE, all.files = TRUE, no.. = TRUE)
  files <- c("[Content_Types].xml", setdiff(files, "[Content_Types].xml"))
  out_abs <- file.path(normalizePath(dirname(outfile)), basename(outfile))
  if (file.exists(out_abs)) {
    unlink(out_abs)
  }
  zip::zip(zipfile = out_abs, files = files, root = dir, mode = "mirror")
  invisible(out_abs)
}
