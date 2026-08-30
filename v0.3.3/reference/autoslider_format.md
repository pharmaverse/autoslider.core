# Table color and font

Zebra themed color

## Usage

``` r
autoslider_format(
  ft,
  odd_header = "#0EAED5",
  odd_body = "#EBF5FA",
  even_header = "#0EAED5",
  even_body = "#D0E4F2",
  font_name = "arial",
  body_font_size = 12,
  header_font_size = 14
)

blue_format(ft, ...)

orange_format(ft, ...)

red_format(ft, ...)

purple_format(ft, ...)

autoslider_dose_format(ft, header_vals = names(ft$body$dataset))

black_format_tb(ft, body_font_size = 8, header_font_size = 8, ...)
```

## Arguments

- ft:

  flextable object

- odd_header:

  Hex color code, default to deep sky blue

- odd_body:

  Hex color code, default to alice blue

- even_header:

  Hex color code, default to slate gray

- even_body:

  Hex color code, default to slate gray

- font_name:

  Font name, default to arial

- body_font_size:

  Font size of the table content, default to 12

- header_font_size:

  Font size of the table header, default to 14

- ...:

  arguments passed to program

- header_vals:

  Header

## Value

A flextable with applied theme.

## Functions

- `autoslider_format()`: User defined color code and font size

- `blue_format()`: Blue color theme

- `orange_format()`: Orange color theme

- `red_format()`: Red color theme

- `purple_format()`: Purple color theme

- `autoslider_dose_format()`: \`AutoslideR\` dose formats

- `black_format_tb()`: Black color theme

## Author

Nina Qi and Jasmina Uzunovic
