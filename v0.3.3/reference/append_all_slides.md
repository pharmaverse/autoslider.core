# Append All Predefined Slides to a PowerPoint Document

This function orchestrates the appending of a series of predefined
slides (including title and section header slides) to a PowerPoint
document based on a provided page list.

## Usage

``` r
append_all_slides(
  doc_o,
  page_list = list(),
  doc_original = NULL,
  save_file = FALSE
)
```

## Arguments

- doc_o:

  Path to a PowerPoint (\`.pptx\`) file. Used to initialize the document
  if \`doc_original\` is \`NULL\`, and for final post-processing.

- page_list:

  A list of slide definitions. Each element in the list should be
  another list containing: - \`type\`: A character string indicating the
  type of slide ("title" or "section"). - \`to_page\`: An integer
  specifying the target page number for the slide. - Other arguments
  specific to the slide type (e.g., \`study_id\` for "title" slides,
  \`section_title\` for "section" slides).

- doc_original:

  An optional existing \`officer::rpptx\` object. If \`NULL\`, the
  document is initialized from \`doc_o\`.

- save_file:

  A logical value. If \`TRUE\`, the final modified document is saved to
  a file after all slides have been appended.

## Value

An \`officer::rpptx\` object with all specified slides appended.

## Examples

``` r
tmp <- tempfile(fileext = ".pptx")
doc <- officer::read_pptx()
print(doc, target = tmp)

my_page_list <- list(
  list(type = "title", to_page = 1, study_id = "My Project"),
  list(type = "section", to_page = 2, section_title = "Introduction"),
  list(type = "title", to_page = 3, study_id = "Mid-Term Review"),
  list(type = "section", to_page = 4, section_title = "Key Findings")
)

# Append all slides using the dynamic page_list
doc <- append_all_slides(
  doc_o = tmp,
  page_list = my_page_list,
  save_file = TRUE
)
```
