# Describe one placeholder slide

Used with
[`append_placeholder_slides()`](https://pharmaverse.github.io/autoslider.core/reference/append_placeholder_slides.md)
to build placeholder slide types.

## Usage

``` r
placeholder_slide(role, ..., to_page = NULL)
```

## Arguments

- role:

  A layout role (see
  [`placeholder_layouts()`](https://pharmaverse.github.io/autoslider.core/reference/placeholder_layouts.md)).

- ...:

  Text for the role's fields, e.g. `title =`, `subtitle =`, `text =`.
  Each value may be a character vector or a list (one paragraph per
  element). `NULL` leaves that placeholder empty.

- to_page:

  A fixed page for this slide. `NULL` (the default) places it after the
  previous slide described in the same call.

## Value

A `list` describing the slide.

## Examples

``` r
placeholder_slide("section", title = "Safety", text = "Data cut-off: 01-JAN-2026")
#> $role
#> [1] "section"
#> 
#> $fields
#> $fields$title
#> [1] "Safety"
#> 
#> $fields$text
#> [1] "Data cut-off: 01-JAN-2026"
#> 
#> 
#> $to_page
#> NULL
#> 
```
