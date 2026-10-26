# Figure placement (#143): figures are scaled to fit the free area of the slide,
# with even margins, and centred, whatever the template's size.

basic_theme <- function() system.file("theme", "basic.pptx", package = "autoslider.core")

# basic.pptx resized to 10 x 5.625 in, the size of the SREP dose themes, where
# the old fixed 9 x 5 in placement ran off the bottom of the slide.
small_theme <- function() {
  dir <- withr::local_tempdir(.local_envir = parent.frame())
  utils::unzip(basic_theme(), exdir = dir)
  pres_file <- file.path(dir, "ppt", "presentation.xml")
  pres <- xml2::read_xml(pres_file)
  size <- xml2::xml_find_first(pres, "//p:sldSz", xml2::xml_ns(pres))
  xml2::xml_set_attrs(size, c(cx = "9144000", cy = "5143500"))
  xml2::write_xml(pres, pres_file)
  out <- withr::local_tempfile(fileext = ".pptx", .local_envir = parent.frame())
  files <- list.files(dir, recursive = TRUE, all.files = TRUE)
  zip::zip(out, files = c("[Content_Types].xml", setdiff(files, "[Content_Types].xml")), root = dir)
  out
}

test_plot <- function() {
  ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
}

# Slide size and the position of the (single) picture on the last slide, in inches.
picture_box <- function(path) {
  ex <- withr::local_tempdir()
  utils::unzip(path, exdir = ex)
  pres <- xml2::read_xml(file.path(ex, "ppt", "presentation.xml"))
  size <- xml2::xml_find_first(pres, "//p:sldSz", xml2::xml_ns(pres))
  slides <- list.files(file.path(ex, "ppt", "slides"), pattern = "^slide[0-9]+\\.xml$", full.names = TRUE)
  slide <- xml2::read_xml(slides[order(as.integer(gsub("\\D", "", basename(slides))))][length(slides)])
  ns <- xml2::xml_ns(slide)
  xfrm <- xml2::xml_find_first(slide, "//p:pic/p:spPr/a:xfrm", ns)
  inch <- function(node, attr) as.numeric(xml2::xml_attr(xml2::xml_find_first(xfrm, node, ns), attr)) / 914400
  list(
    slide_width = as.numeric(xml2::xml_attr(size, "cx")) / 914400,
    slide_height = as.numeric(xml2::xml_attr(size, "cy")) / 914400,
    left = inch("./a:off", "x"), top = inch("./a:off", "y"),
    width = inch("./a:ext", "cx"), height = inch("./a:ext", "cy"),
    media = tools::file_ext(list.files(file.path(ex, "ppt", "media")))
  )
}

title_bottom <- function(theme, layout = "Title and Content") {
  props <- officer::layout_properties(officer::read_pptx(theme), layout = layout)
  title <- props[props$type == "title", ]
  title$offy + title$cy
}

test_that("figure_fit centres the figure below the title with even margins", {
  ppt <- officer::read_pptx(basic_theme())
  fit <- figure_fit(ppt, "Title and Content", "Office Theme", 9, 5, margin = 0.25)
  loc <- officer::fortify_location(fit$location, doc = ppt)
  size <- officer::slide_size(ppt)

  expect_equal(fit$width / fit$height, 9 / 5) # shape kept
  expect_equal(loc$left, size$width - loc$left - loc$width) # centred left-right
  expect_gte(loc$top, title_bottom(basic_theme()) + 0.25 - 1e-9) # clear of the title
  expect_gte(size$height - loc$top - loc$height, 0.25 - 1e-9) # bottom margin
  # Height-limited here, so it touches both vertical margins of the free area.
  expect_equal(loc$top, title_bottom(basic_theme()) + 0.25)
  expect_equal(loc$top + loc$height, size$height - 0.25)
})

test_that("a wide figure is limited by the width and centred vertically", {
  ppt <- officer::read_pptx(basic_theme())
  fit <- figure_fit(ppt, "Title and Content", "Office Theme", 20, 2, margin = 0.5)
  loc <- officer::fortify_location(fit$location, doc = ppt)
  size <- officer::slide_size(ppt)

  expect_equal(loc$left, 0.5)
  expect_equal(loc$width, size$width - 1)
  free_top <- title_bottom(basic_theme()) + 0.5
  free_bottom <- size$height - 0.5
  expect_equal(loc$top - free_top, free_bottom - (loc$top + loc$height))
})

test_that("content written at the bottom of the slide is kept clear", {
  ppt <- officer::read_pptx(basic_theme())
  footer <- officer::ph_location_label("Footer Placeholder 4")
  fit <- figure_fit(ppt, "Title and Content", "Office Theme", 9, 5, margin = 0.25, targets = list(footer))
  loc <- officer::fortify_location(fit$location, doc = ppt)
  props <- officer::layout_properties(ppt, layout = "Title and Content")
  footer_top <- props$offy[props$ph_label == "Footer Placeholder 4"]
  expect_equal(loc$top + loc$height, footer_top - 0.25)
})

test_that("a layout with almost no free room falls back to the whole slide", {
  ppt <- officer::read_pptx(basic_theme())
  fit <- figure_fit(ppt, "Section Header", "Office Theme", 9, 5, margin = 1)
  loc <- officer::fortify_location(fit$location, doc = ppt)
  expect_gte(loc$top, 1 - 1e-9)
  expect_lte(loc$top + loc$height, officer::slide_size(ppt)$height - 1 + 1e-9)
})

test_that("generate_slides keeps a figure inside a 10 x 5.625 in slide (#143)", {
  skip_if_not_installed("rsvg")
  theme <- small_theme()
  out <- withr::local_tempfile(fileext = ".pptx")
  generate_slides(list(test_plot()), outfile = out, template = theme)
  box <- picture_box(out)

  expect_gte(box$left, 0.25 - 1e-6)
  expect_equal(box$left, box$slide_width - box$left - box$width, tolerance = 1e-4)
  expect_gte(box$top, title_bottom(theme) + 0.25 - 1e-6)
  expect_lte(box$top + box$height, box$slide_height - 0.25 + 1e-6)
  expect_equal(box$width / box$height, 9 / 5, tolerance = 1e-3)
})

test_that("fig_margin sets the margin", {
  skip_if_not_installed("rsvg")
  out <- withr::local_tempfile(fileext = ".pptx")
  generate_slides(list(test_plot()), outfile = out, fig_margin = 0.6)
  box <- picture_box(out)
  expect_equal(box$slide_height - box$top - box$height, 0.6, tolerance = 1e-4)
  expect_equal(box$top, title_bottom(basic_theme()) + 0.6, tolerance = 1e-4)
})

test_that("fig_format = 'png' embeds a PNG at the same place", {
  skip_if_not_installed("rsvg")
  svg_out <- withr::local_tempfile(fileext = ".pptx")
  png_out <- withr::local_tempfile(fileext = ".pptx")
  generate_slides(list(test_plot()), outfile = svg_out)
  generate_slides(list(test_plot()), outfile = png_out, fig_format = "png", fig_dpi = 150)

  svg_box <- picture_box(svg_out)
  png_box <- picture_box(png_out)
  expect_true("svg" %in% svg_box$media)
  expect_false("svg" %in% png_box$media)
  expect_true("png" %in% png_box$media)
  for (k in c("left", "top", "width", "height")) {
    expect_equal(png_box[[k]], svg_box[[k]], tolerance = 1e-4)
  }
})

test_that("a study's own five-argument ph_with_img() replacement still works", {
  seen <- NULL
  local_mocked_bindings(ph_with_img = function(ppt, figure, fig_width, fig_height, figure_loc) {
    seen <<- c(fig_width, fig_height)
    ppt
  })
  generate_slides(list(test_plot()), outfile = withr::local_tempfile(fileext = ".pptx"))
  expect_length(seen, 2)
  expect_equal(seen[1] / seen[2], 9 / 5) # it receives the fitted size
  expect_false(isTRUE(all.equal(seen, c(9, 5))))
})

test_that("bad figure arguments are rejected", {
  expect_error(generate_slides(list(test_plot()), fig_format = "jpeg"), "should be one of")
  expect_error(generate_slides(list(test_plot()), fig_margin = -1), "fig_margin")
  expect_error(generate_slides(list(test_plot()), fig_dpi = 0), "fig_dpi")
})
