# Append Section Header Slides to a PowerPoint Document

This function adds a new section header slide to an existing PowerPoint
document using a "Section Header" layout from the "Office Theme". It
populates the title placeholder with the provided section title.

## Usage

``` r
append_section_header_slides(
  doc_o,
  section_title = "New Section",
  to_page = NA,
  doc_original = NULL,
  save_file = FALSE
)
```

## Arguments

- doc_o:

  Path to a PowerPoint (\`.pptx\`) file. Used to initialize the document
  if \`doc_original\` is \`NULL\`, and for post-processing.

- section_title:

  A character string for the title of the section header slide. Defaults
  to "New Section".

- to_page:

  An integer specifying the page number where the new slide should be
  moved. If \`NA\`, the slide is added at the end and
  \`initialize_to_page\` determines its final position.

- doc_original:

  An optional existing \`officer::rpptx\` object. If \`NULL\`, the
  document is initialized from \`doc_o\`.

- save_file:

  A logical value. If \`TRUE\`, the modified document is saved to a file
  after adding the slide.

## Value

An \`officer::rpptx\` object with the new section header slide appended.

## Examples

``` r

tmp <- tempfile(fileext = ".pptx")
doc <- officer::read_pptx()
print(doc, target = tmp)

append_section_header_slides(
  doc_o = tmp,
  section_title = "My Section",
  to_page = 1,
  save_file = TRUE
)
#> pptx document with 1 slide
#> Available layouts and their associated master(s):
#>              layout       master
#> 1       Title Slide Office Theme
#> 2 Title and Content Office Theme
#> 3    Section Header Office Theme
#> 4       Two Content Office Theme
#> 5        Comparison Office Theme
#> 6        Title Only Office Theme
#> 7             Blank Office Theme
```
