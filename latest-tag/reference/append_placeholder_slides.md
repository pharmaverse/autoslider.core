# Insert placeholder slides

The building block behind every placeholder slide type: checks the
template has the layouts the slides use, adds each slide described by
[`placeholder_slide()`](https://pharmaverse.github.io/autoslider.core/reference/placeholder_slide.md),
fills its placeholders and moves it into place, then optionally saves
the deck.

## Usage

``` r
append_placeholder_slides(
  doc_o,
  slides,
  to_page = NA,
  doc_original = NULL,
  save_file = FALSE,
  layouts = placeholder_layouts(),
  metadata = NULL,
  type = "placeholder"
)
```

## Arguments

- doc_o:

  Path to the `.pptx` file. Read when `doc_original` is `NULL`, and used
  to name the saved file.

- slides:

  A `list` of
  [`placeholder_slide()`](https://pharmaverse.github.io/autoslider.core/reference/placeholder_slide.md)
  descriptions, inserted in order.

- to_page:

  Page for the first slide; the others follow it. `NA` appends after the
  last slide.

- doc_original:

  An optional `officer::rpptx` object to add to.

- save_file:

  If `TRUE`, the deck is saved next to `doc_o` with a `_<type>` suffix.

- layouts:

  The role lookup, see
  [`placeholder_layouts()`](https://pharmaverse.github.io/autoslider.core/reference/placeholder_layouts.md).

- metadata:

  Optional named `list` of values for `{token}`s in the text, see
  [`apply_tokens()`](https://pharmaverse.github.io/autoslider.core/reference/apply_tokens.md).

- type:

  Suffix for the saved file.

## Value

The modified `officer::rpptx` object.

## Examples

``` r
deck <- tempfile(fileext = ".pptx")
print(officer::read_pptx(system.file("theme/basic.pptx", package = "autoslider.core")), deck)

doc <- append_placeholder_slides(deck, list(
  placeholder_slide("section", title = "{study} safety", text = "Data cut-off: 01-JAN-2026"),
  placeholder_slide("title_content", title = "Key findings", content = c("Point 1", "Point 2"))
), metadata = list(study = "BP12345"))
length(doc)
#> [1] 3
```
