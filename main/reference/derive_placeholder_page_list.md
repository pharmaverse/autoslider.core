# Derive placeholder pages from speclayout order

Walks an ordered speclayout and, for every placeholder entry, computes
the page it must be inserted at so its position among the TLG slides
matches its position in the file: \`content slides so far + placeholder
slides already inserted + 1\`.

## Usage

``` r
derive_placeholder_page_list(
  speclayout,
  content_counts = NULL,
  types = placeholder_types()
)
```

## Arguments

- speclayout:

  A named, ordered \`list\` read from a speclayout yaml file.

- content_counts:

  Optional named list of the number of slides each TLG entry produced.
  When given, entries missing from it count as 0 slides (not generated);
  when \`NULL\`, every TLG entry counts as one slide.

- types:

  The placeholder types, see \[placeholder_types()\].

## Value

A \`list\` of placeholder entries in insertion order, each with its
\`name\` and resolved \`to_page\`.

## Examples

``` r
speclayout <- list(
  sec_a = list(type = "section", title = "Section A"),
  out1 = list(program = "t_dm_slide", suffix = "FAS"),
  out2 = list(program = "t_ae_slide", suffix = "SE"),
  sec_b = list(type = "section", title = "Section B")
)
vapply(derive_placeholder_page_list(speclayout), function(p) p$to_page, integer(1))
#> [1] 1 4
```
