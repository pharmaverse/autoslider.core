# Append Title Slides to a PowerPoint Document

This function adds a new title slide using a "Title and Content" layout
from the "Office Theme".

## Usage

``` r
append_title_slides(
  doc_o,
  study_id = "XXXX change me",
  to_page = NA,
  doc_original = NULL,
  save_file = FALSE
)
```

## Arguments

- doc_o:

  Path to a PowerPoint (\`.pptx\`) file. Used to initialize the document
  if \`doc_original\` is \`NULL\`.

- study_id:

  A character string that represent your study identifier.

- to_page:

  An integer specifying the page number where the new slide should be
  moved.

- doc_original:

  An optional existing \`officer::rpptx\` object. If \`NULL\`, the
  document is initialized from \`doc_o\`.

- save_file:

  A logical value. If \`TRUE\`, the modified document is saved to a file
  after adding the slide.

## Value

An \`officer::rpptx\` object with the new title slide appended.

## Examples

``` r

tmp <- tempfile(fileext = ".pptx")
doc <- officer::read_pptx()
doc <- officer::add_slide(doc, layout = "Title Slide", master = "Office Theme")
print(doc, target = tmp)

doc <- append_title_slides(
  doc_o = tmp,
  study_id = "My Study #13",
  to_page = 1,
  save_file = TRUE
)
```
