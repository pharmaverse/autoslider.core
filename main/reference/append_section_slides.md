# Append a section divider slide

Adds one slide on the \`section\` layout role ("Section Header" in
\`basic.pptx\`) with a title and text. That layout has no subtitle
placeholder: a \`subtitle\` is placed in the text box, above \`text\`,
so speclayouts written for templates that do have a subtitle keep all
their text. This backs the \`section\` placeholder type:

## Usage

``` r
append_section_slides(
  doc_o,
  title = NULL,
  subtitle = NULL,
  text = NULL,
  section_title = NULL,
  to_page = NA,
  doc_original = NULL,
  save_file = FALSE,
  layouts = placeholder_layouts(),
  metadata = NULL,
  role = "section"
)
```

## Arguments

- doc_o:

  Path to the \`.pptx\` file. Read when \`doc_original\` is \`NULL\`,
  and used to name the saved file.

- title, subtitle, text:

  Text for the slide. Each may be a character vector or a list, one
  paragraph per element. \`NULL\` leaves it out.

- section_title:

  Older name for \`title\`, used when \`title\` is \`NULL\`.

- to_page:

  Page for the first slide; the others follow it. \`NA\` appends after
  the last slide.

- doc_original:

  An optional \`officer::rpptx\` object to add to.

- save_file:

  If \`TRUE\`, the deck is saved next to \`doc_o\` with a \`\_\<type\>\`
  suffix.

- layouts:

  The role lookup, see \[placeholder_layouts()\].

- metadata:

  Optional named \`list\` of values for \`token\`s in the text, see
  \[apply_tokens()\].

- role:

  The layout role to use.

## Value

The modified \`officer::rpptx\` object.

## Details

“\`yaml sec_safety: type: section title: Safety Summary subtitle: "Data
cut-off: cutoff_date" text: - All treated patients “\`

## See also

\[append_section_header_slides()\] for the older title-only version.

## Examples

``` r
deck <- tempfile(fileext = ".pptx")
print(officer::read_pptx(system.file("theme/basic.pptx", package = "autoslider.core")), deck)
doc <- append_section_slides(deck, title = "Safety", subtitle = "Data cut-off: 01-JAN-2026")
officer::slide_summary(doc, index = length(doc))$text
#> [1] "Safety"                    "Data cut-off: 01-JAN-2026"
```
