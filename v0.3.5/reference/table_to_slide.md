# Add decorated flextable to slides

Add decorated flextable to slides

## Usage

``` r
table_to_slide(
  ppt,
  content,
  decor = TRUE,
  layout = "Title and Content",
  table_loc = ph_location_type("body"),
  usernotes = "",
  footer_font_size = 8L,
  ...
)
```

## Arguments

- ppt:

  Slide

- content:

  Content to be added

- decor:

  Should table be decorated

- layout:

  layout from theme

- table_loc:

  Table location

- usernotes:

  User notes

- footer_font_size:

  Point size for the footnote text, defaulting to 8. \`NULL\` keeps the
  existing footnote size set on the flextable.

- ...:

  additional arguments

## Value

Slide with added content
