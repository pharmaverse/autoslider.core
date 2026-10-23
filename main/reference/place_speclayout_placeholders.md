# Place placeholder slides by their order in a speclayout

Inserts the placeholder entries of a speclayout (those with a \`type:\`,
such as \`section\` or \`custom\`) into an already generated deck, at
pages derived from their position among the TLG entries. No page numbers
need to be typed.

## Usage

``` r
place_speclayout_placeholders(
  doc_o,
  speclayout,
  content_counts = NULL,
  doc_original = NULL,
  save_file = FALSE,
  layouts = placeholder_layouts(),
  types = placeholder_types(),
  metadata = NULL
)
```

## Arguments

- doc_o:

  Path to the \`.pptx\` holding the generated TLG slides.

- speclayout:

  A named, ordered \`list\` read from a speclayout yaml file, with
  placeholder entries between the TLG entries.

- content_counts:

  Optional slides per TLG entry, see \[derive_placeholder_page_list()\].

- doc_original:

  An optional \`officer::rpptx\` object. If \`NULL\`, the deck is read
  from \`doc_o\`.

- save_file:

  If \`TRUE\`, the finished deck is written next to \`doc_o\`.

- layouts:

  The role lookup, see \[placeholder_layouts()\].

- types:

  The placeholder types, see \[placeholder_types()\].

- metadata:

  Optional named \`list\` of values for \`token\`s, passed to
  placeholder functions that accept \`metadata\`.

## Value

The \`officer::rpptx\` object with the placeholder slides inserted.

## Details

The deck at \`doc_o\` must hold exactly the TLG slides of the
speclayout, in order (the shipped \`basic.pptx\` theme has one empty
slide; remove it or include it in \`content_counts\`).

## Examples

``` r
deck <- officer::read_pptx(system.file("theme/basic.pptx", package = "autoslider.core"))
deck <- officer::remove_slide(deck, index = 1)
for (i in 1:2) {
  deck <- officer::add_slide(deck, layout = "Title and Content", master = "Office Theme")
}
content <- tempfile(fileext = ".pptx")
print(deck, content)

speclayout <- list(
  sec_dm = list(type = "section", title = "Demographics", subtitle = "{study}"),
  t_dm_slide_FAS = list(program = "t_dm_slide", suffix = "FAS"),
  sec_ae = list(type = "section", title = "Adverse Events"),
  t_ae_slide_SE = list(program = "t_ae_slide", suffix = "SE")
)
doc <- place_speclayout_placeholders(content, speclayout, metadata = list(study = "BP12345"))
length(doc)
#> [1] 4
```
