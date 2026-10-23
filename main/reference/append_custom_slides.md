# Append a slide on any layout

Adds one slide on \`layout\` and fills the placeholders named in
\`placeholders\` (by label, the \`ph_label\` column of
\[officer::layout_properties()\]). This backs the \`custom\` placeholder
type, so a study can add its own slide without writing R code:

## Usage

``` r
append_custom_slides(
  doc_o,
  layout,
  master = NULL,
  placeholders = list(),
  to_page = NA,
  doc_original = NULL,
  save_file = FALSE
)
```

## Arguments

- doc_o:

  Path to the \`.pptx\` file.

- layout:

  Name of the layout to use.

- master:

  Name of the slide master. Only needed when the layout name exists in
  more than one master.

- placeholders:

  A named list mapping placeholder labels to text. Each value may be a
  character vector or a list (one paragraph per element).

- to_page:

  Page to move the new slide to. \`NA\` appends at the end.

- doc_original:

  An optional existing \`officer::rpptx\` object. If \`NULL\`, the
  document is read from \`doc_o\`.

- save_file:

  A logical. If \`TRUE\`, the deck is written next to \`doc_o\`.

## Value

The modified \`officer::rpptx\` object.

## Details

“\`yaml sec_rationale: type: custom layout: Section Header placeholders:
Title 1: Dose Rationale Text Placeholder 2: - Cohort 3 opened at 20 mg
QW “\`

## Examples

``` r
deck <- tempfile(fileext = ".pptx")
print(officer::read_pptx(system.file("theme/basic.pptx", package = "autoslider.core")), deck)
doc <- append_custom_slides(deck,
  layout = "Section Header",
  placeholders = list("Title 1" = "Dose Rationale", "Text Placeholder 2" = "Cohort 3")
)
length(doc)
#> [1] 2
```
