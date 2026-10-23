basic_theme <- function() system.file("theme", "basic.pptx", package = "autoslider.core")
office_template <- function() system.file("template", "template.pptx", package = "officer")

# A deck of `n` numbered "Title and Content" slides on basic.pptx (whose own
# empty first slide is removed), saved to a temporary file.
numbered_deck <- function(n = 2) {
  doc <- officer::remove_slide(officer::read_pptx(basic_theme()), index = 1)
  for (i in seq_len(n)) {
    doc <- officer::add_slide(doc, layout = "Title and Content", master = "Office Theme")
    doc <- officer::ph_with(doc, paste("content", i), officer::ph_location_type("title"))
  }
  path <- tempfile(fileext = ".pptx")
  print(doc, path)
  path
}

# Slides in PowerPoint's order (presentation.xml; officer::slide_summary()
# follows file order instead). Each slide is a list: `layout`, plus the
# paragraphs of every placeholder, keyed by placeholder type.
deck_slides <- function(doc) {
  path <- tempfile(fileext = ".pptx")
  print(doc, path)
  ex <- tempfile()
  utils::unzip(path, exdir = ex)
  pres <- xml2::read_xml(file.path(ex, "ppt", "presentation.xml"))
  ns <- xml2::xml_ns(pres)
  rels <- xml2::read_xml(file.path(ex, "ppt", "_rels", "presentation.xml.rels"))
  rel <- xml2::xml_find_all(rels, "//*[local-name()='Relationship']")
  target <- stats::setNames(xml2::xml_attr(rel, "Target"), xml2::xml_attr(rel, "Id"))
  rid <- xml2::xml_attr(xml2::xml_find_all(pres, "//p:sldId"), "r:id", ns = ns)

  lapply(rid, function(id) {
    part <- target[[id]]
    slide <- xml2::read_xml(file.path(ex, "ppt", part))
    sn <- xml2::xml_ns(slide)
    srel <- xml2::read_xml(file.path(ex, "ppt", "slides", "_rels", paste0(basename(part), ".rels")))
    layout_part <- xml2::xml_attr(xml2::xml_find_first(srel, "//*[contains(@Type, '/slideLayout')]"), "Target")
    layout <- xml2::xml_attr(
      xml2::xml_find_first(xml2::read_xml(file.path(ex, "ppt", "slides", layout_part)), "//p:cSld", sn), "name"
    )
    out <- list(layout = layout)
    for (sp in xml2::xml_find_all(slide, "//p:sp[.//p:ph]", sn)) {
      type <- xml2::xml_attr(xml2::xml_find_first(sp, ".//p:ph", sn), "type")
      type <- if (is.na(type)) "body" else type
      paras <- xml2::xml_text(xml2::xml_find_all(sp, ".//a:p", sn))
      out[[type]] <- c(out[[type]], paras[nzchar(paras)])
    }
    out
  })
}

slide_titles <- function(doc) {
  vapply(deck_slides(doc), function(s) paste(c(s$title, s$ctrTitle), collapse = " "), character(1))
}

# --- layout roles -----------------------------------------------------------------

test_that("the default roles cover basic.pptx", {
  layouts <- placeholder_layouts(overrides = list())
  expect_named(layouts, c("section", "title_slide", "title_content"))
  expect_identical(layouts$section$layout, "Section Header")
  expect_identical(layouts$section$fallbacks$subtitle, "text")
  expect_true(validate_placeholder_layouts(basic_theme()))
  expect_true(validate_placeholder_layouts(office_template()))
})

test_that("overrides merge per role and per field", {
  layouts <- placeholder_layouts(list(
    section = list(layout = "Chapter divider", types = list(text = "subTitle")),
    banner = list(layout = "Title Only", master = "Office Theme", types = list(title = "title"))
  ))
  expect_identical(layouts$section$layout, "Chapter divider")
  expect_identical(layouts$section$master, "Office Theme")
  expect_identical(layouts$section$types, list(title = "title", text = "subTitle"))
  expect_identical(layouts$section$fallbacks, list(subtitle = "text"))
  expect_identical(layouts$banner$layout, "Title Only")
})

test_that("the autoslider.core.placeholder_layouts option applies session-wide", {
  withr::local_options(autoslider.core.placeholder_layouts = list(section = list(layout = "Title Only")))
  expect_identical(placeholder_layouts()$section$layout, "Title Only")
})

test_that("validate_placeholder_layouts reports missing layouts, labels and types together", {
  bad <- placeholder_layouts(list(
    section = list(layout = "No Such Layout"),
    title_slide = list(labels = list(title = "No Such Label")),
    title_content = list(types = list(content = "pic"))
  ))
  err <- expect_error(validate_placeholder_layouts(basic_theme(), layouts = bad))
  expect_match(conditionMessage(err), "role \"section\": layout \"No Such Layout\"", fixed = TRUE)
  expect_match(conditionMessage(err), "no placeholder labelled \"No Such Label\"", fixed = TRUE)
  expect_match(conditionMessage(err), "no placeholder of type \"pic\"", fixed = TRUE)
  expect_match(conditionMessage(err), "Available layouts", fixed = TRUE)
  expect_error(validate_placeholder_layouts(basic_theme(), roles = "nope"), "Unknown placeholder layout role")
})

# --- section slides ---------------------------------------------------------------

test_that("a section slide puts the title and the text on Section Header", {
  doc <- append_section_slides(numbered_deck(), title = "Safety", text = c("Line 1", "Line 2"))
  last <- deck_slides(doc)[[3]]
  expect_identical(last$layout, "Section Header")
  expect_identical(last$title, "Safety")
  expect_identical(last$body, c("Line 1", "Line 2"))
})

test_that("a subtitle goes into the text box, before the text", {
  doc <- append_section_slides(numbered_deck(),
    title = "Safety", subtitle = "Data cut-off: 01-JAN-2026", text = list("All patients", "FAS")
  )
  expect_identical(deck_slides(doc)[[3]]$body, c("Data cut-off: 01-JAN-2026", "All patients", "FAS"))

  only_subtitle <- append_section_slides(numbered_deck(), title = "Safety", subtitle = "Subtitle only")
  expect_identical(deck_slides(only_subtitle)[[3]]$body, "Subtitle only")
})

test_that("`section_title` still works, and `title` wins over it", {
  expect_identical(slide_titles(append_section_slides(numbered_deck(), section_title = "Old"))[3], "Old")
  expect_identical(
    slide_titles(append_section_slides(numbered_deck(), title = "New", section_title = "Old"))[3],
    "New"
  )
})

test_that("tokens are filled from metadata, and text is left alone without it", {
  doc <- append_section_slides(numbered_deck(),
    title = "{study} Safety", subtitle = "Cut-off: {cutoff}",
    metadata = list(study = "BP12345", cutoff = "01-JAN-2026")
  )
  last <- deck_slides(doc)[[3]]
  expect_identical(last$title, "BP12345 Safety")
  expect_identical(last$body, "Cut-off: 01-JAN-2026")

  raw <- append_section_slides(numbered_deck(), title = "{not a token}")
  expect_identical(slide_titles(raw)[3], "{not a token}")
})

test_that("to_page places the slide; NA appends after the last slide", {
  deck <- numbered_deck(3)
  expect_identical(slide_titles(append_section_slides(deck, title = "S"))[4], "S")
  expect_identical(slide_titles(append_section_slides(deck, title = "S", to_page = 1))[1], "S")
  expect_identical(
    slide_titles(append_section_slides(deck, title = "S", to_page = 2))[1:3],
    c("content 1", "S", "content 2")
  )
  expect_error(append_section_slides(deck, title = "S", to_page = 9), "deck has only 3 slide")
})

test_that("a field the role has no placeholder for is an error, not dropped", {
  expect_error(
    append_placeholder_slides(numbered_deck(), list(placeholder_slide("section", title = "T", footer = "F"))),
    "has no placeholder for `footer`. Available: `title`, `text` \\(subtitle goes into text\\)"
  )
})

test_that("several slides are inserted together and keep their order", {
  doc <- append_placeholder_slides(numbered_deck(), list(
    placeholder_slide("section", title = "A"),
    placeholder_slide("title_content", title = "B", content = c("b1", "b2")),
    placeholder_slide("title_slide", title = "C", subtitle = "c", to_page = 1)
  ), to_page = 2)
  slides <- deck_slides(doc)
  expect_identical(
    vapply(slides, function(s) s$layout, ""),
    c("Title Slide", "Title and Content", "Section Header", "Title and Content", "Title and Content")
  )
  expect_identical(slide_titles(doc), c("C", "content 1", "A", "B", "content 2"))
  expect_identical(slides[[4]]$body, c("b1", "b2"))
  expect_identical(slides[[1]]$subTitle, "c")
})

test_that("a role can address placeholders by label", {
  layouts <- placeholder_layouts(list(
    section = list(labels = list(title = "Text Placeholder 2"), types = list(title = NULL))
  ))
  doc <- append_section_slides(numbered_deck(), title = "In the text box", layouts = layouts)
  expect_identical(deck_slides(doc)[[3]]$body, "In the text box")
})

test_that("save_file writes the deck with a suffix", {
  deck <- numbered_deck(1)
  append_section_slides(deck, title = "Saved", save_file = TRUE)
  saved <- sub("\\.pptx$", "_section.pptx", deck)
  expect_true(file.exists(saved))
  expect_identical(slide_titles(officer::read_pptx(saved))[2], "Saved")
})

# --- custom slides ----------------------------------------------------------------

test_that("append_custom_slides fills placeholders by label on any layout", {
  doc <- append_custom_slides(numbered_deck(),
    layout = "Section Header", to_page = 1,
    placeholders = list("Title 1" = "Custom", "Text Placeholder 2" = list("x", "y"))
  )
  first <- deck_slides(doc)[[1]]
  expect_identical(first$layout, "Section Header")
  expect_identical(first$title, "Custom")
  expect_identical(first$body, c("x", "y"))
})

test_that("append_custom_slides reports a bad layout or label", {
  deck <- numbered_deck()
  expect_error(append_custom_slides(deck, layout = "Nope"), "Layout \"Nope\" used by the custom placeholder")
  expect_error(
    append_custom_slides(deck, layout = "Section Header", placeholders = list("Titel 1" = "typo")),
    "\"Titel 1\" used by the custom placeholder are not in layout \"Section Header\". Available labels"
  )
})

# --- types and the speclayout engine ------------------------------------------------

test_that("placeholder_types lists the built-in types and merges extra ones", {
  expect_named(placeholder_types(extra = list()), c("section", "title", "custom"))
  f <- function(doc_o, to_page = NA, doc_original = NULL, save_file = FALSE) doc_original
  types <- placeholder_types(list(mine = f, pair = list(fn = f, n = 2)))
  expect_identical(types$mine$n, 1L)
  expect_identical(types$pair$n, 2L)
  expect_identical(types$pair$roles, character(0))

  withr::local_options(autoslider.core.placeholder_types = list(mine = f))
  expect_true("mine" %in% names(placeholder_types()))
  expect_error(
    placeholder_types(list(bad = list(n = 1))),
    "`autoslider.core.placeholder_types$bad` must be a function",
    fixed = TRUE
  )
})

test_that("split_speclayout partitions content, placeholders and other entries", {
  parts <- split_speclayout(list(
    defaults = list(common = list(layout = "Title and Content")),
    sec = list(type = "section", title = "S"),
    t_dm = list(program = "t_dm_slide", suffix = "FAS")
  ))
  expect_named(parts$content, "t_dm")
  expect_named(parts$placeholders, "sec")
  expect_named(parts$other, "defaults")
})

test_that("pages follow file order, slide counts and multi-slide types", {
  lyt <- list(
    sec_a = list(type = "section", title = "A"),
    out1 = list(program = "t_dm_slide", suffix = "FAS"),
    out2 = list(program = "t_ae_slide", suffix = "SE"),
    sec_b = list(type = "section", title = "B"),
    defaults = list(common = list())
  )
  pages <- function(...) vapply(derive_placeholder_page_list(lyt, ...), function(p) p$to_page, integer(1))
  expect_identical(pages(), c(1L, 4L))
  expect_identical(pages(content_counts = list(out1 = 3, out2 = 1)), c(1L, 6L))
  expect_identical(pages(content_counts = list(out1 = 1)), c(1L, 3L)) # out2 not generated

  two <- placeholder_types(list(section = list(fn = append_section_slides, n = 2L, roles = "section")))
  expect_identical(pages(types = two), c(1L, 5L))

  expect_error(
    derive_placeholder_page_list(list(x = list(type = "nope"))),
    "Unknown placeholder type 'nope' in speclayout entry 'x'. Known types: section, title, custom."
  )
})

test_that("place_speclayout_placeholders inserts section and custom slides in order", {
  lyt <- list(
    sec_dm = list(type = "section", title = "Demographics", subtitle = "{study}"),
    t_dm = list(program = "t_dm_slide", suffix = "FAS"),
    sec_ae = list(type = "section", section_title = "Adverse Events"),
    t_ae = list(program = "t_ae_slide", suffix = "SE"),
    closing = list(type = "custom", layout = "Section Header", placeholders = list("Title 1" = "Backup"))
  )
  doc <- place_speclayout_placeholders(numbered_deck(), lyt, metadata = list(study = "BP12345"))
  expect_identical(slide_titles(doc), c("Demographics", "content 1", "Adverse Events", "content 2", "Backup"))
  expect_identical(deck_slides(doc)[[1]]$body, "BP12345")
})

test_that("place_speclayout_placeholders checks every layout before inserting", {
  deck <- numbered_deck()
  bad <- placeholder_layouts(list(section = list(layout = "No Such Layout")))
  expect_error(
    place_speclayout_placeholders(deck, list(sec = list(type = "section", title = "S")), layouts = bad),
    "role \"section\": layout \"No Such Layout\""
  )
  expect_error(
    place_speclayout_placeholders(deck, list(
      sec = list(type = "section", title = "S"),
      bad = list(type = "custom", layout = "Section Header", placeholders = list("Nope" = "x"))
    )),
    "custom placeholder 'bad'"
  )
})

test_that("a study type registered for the session is placed like a built-in one", {
  two_sections <- function(doc_o, label = "Part", to_page = NA, doc_original = NULL, save_file = FALSE) {
    append_placeholder_slides(doc_o, list(
      placeholder_slide("section", title = paste(label, "A")),
      placeholder_slide("section", title = paste(label, "B"))
    ), to_page = to_page, doc_original = doc_original, save_file = save_file)
  }
  withr::local_options(autoslider.core.placeholder_types = list(
    two = list(fn = two_sections, n = 2, roles = "section")
  ))
  lyt <- list(
    t_dm = list(program = "t_dm_slide", suffix = "FAS"),
    pair = list(type = "two", label = "Annex"),
    t_ae = list(program = "t_ae_slide", suffix = "SE"),
    end = list(type = "section", title = "End")
  )
  doc <- place_speclayout_placeholders(numbered_deck(), lyt)
  expect_identical(slide_titles(doc), c("content 1", "Annex A", "Annex B", "content 2", "End"))
})

# --- import_layouts -----------------------------------------------------------------

test_that("import_layouts copies a layout into another template", {
  out <- import_layouts(office_template(), basic_theme(), "Content with Caption")
  layouts <- officer::layout_summary(officer::read_pptx(out))
  expect_true("Content with Caption" %in% layouts$layout)
  expect_true(all(officer::layout_summary(officer::read_pptx(office_template()))$layout %in% layouts$layout))

  dir <- withr::local_tempdir()
  utils::unzip(out, exdir = dir)
  ns <- c(p = "http://schemas.openxmlformats.org/presentationml/2006/main")
  master <- xml2::read_xml(file.path(dir, "ppt", "slideMasters", "slideMaster1.xml"))
  pres <- xml2::read_xml(file.path(dir, "ppt", "presentation.xml"))
  ids <- c(
    xml2::xml_attr(xml2::xml_find_all(master, "//p:sldLayoutId", ns), "id"),
    xml2::xml_attr(xml2::xml_find_all(pres, "//p:sldMasterId", ns), "id")
  )
  expect_false(anyDuplicated(ids) > 0)
})

test_that("a slide on an imported layout can be filled and saved", {
  mixed <- import_layouts(office_template(), basic_theme(), "Content with Caption")
  doc <- append_custom_slides(mixed,
    layout = "Content with Caption",
    placeholders = list("Title 1" = "Imported")
  )
  saved <- withr::local_tempfile(fileext = ".pptx")
  print(doc, saved)
  expect_identical(slide_titles(officer::read_pptx(saved)), "Imported")
})

test_that("import_layouts skips existing layouts and reports missing ones", {
  expect_message(
    out <- import_layouts(basic_theme(), basic_theme(), "Section Header"),
    "Already in `target`, not imported: Section Header"
  )
  expect_identical(
    nrow(officer::layout_summary(officer::read_pptx(out))),
    nrow(officer::layout_summary(officer::read_pptx(basic_theme())))
  )
  expect_error(import_layouts(office_template(), basic_theme(), "Nope"), "\"Nope\" not found in `source`")
  expect_error(
    import_layouts(office_template(), basic_theme(), "Content with Caption", master = "Nope"),
    "needs master \"Nope\", which `target` does not have"
  )
})

test_that("import_layouts leaves the target file unchanged", {
  target <- withr::local_tempfile(fileext = ".pptx")
  file.copy(office_template(), target)
  before <- unname(tools::md5sum(target))
  import_layouts(target, basic_theme(), "Content with Caption")
  expect_identical(unname(tools::md5sum(target)), before)
})
