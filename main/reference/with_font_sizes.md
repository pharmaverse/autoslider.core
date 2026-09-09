# Wrap a table formatter so it applies fixed font sizes

Returns a new table-format function that behaves like \`table_format\`
but with the supplied font sizes injected. This is the generic mechanism
used by \[generate_slides()\] to honor per-slide \`font_size\` settings
declared in the spec: a single \`table_format\` symbol can carry
body/header/footer sizes.

Sizes are only forwarded to arguments the underlying formatter actually
declares. A formatter with an explicit
\`body_font_size\`/\`header_font_size\`/ \`footer_font_size\` argument
(or a \`...\`) receives the corresponding size; sizes a formatter cannot
accept are dropped rather than raising an "unused argument" error. When
no sizes are supplied the original formatter is returned unchanged.

## Usage

``` r
with_font_sizes(
  table_format,
  body_font_size = NULL,
  header_font_size = NULL,
  footer_font_size = NULL
)
```

## Arguments

- table_format:

  A function taking a flextable as its first argument and returning a
  flextable (e.g. \[autoslider_format()\], \[black_format_tb()\]).

- body_font_size, header_font_size, footer_font_size:

  Point sizes. \`NULL\` (the default) leaves that part to the underlying
  formatter default.

## Value

A function \`function(ft, ...)\` returning a styled flextable.

## Examples

``` r
small <- with_font_sizes(black_format_tb, body_font_size = 6, header_font_size = 6)
ft <- flextable::flextable(head(mtcars))
small(ft)


.cl-3e800f50{}.cl-3e7881e0{font-family:'DejaVu Sans';font-size:6pt;font-weight:bold;font-style:normal;text-decoration:none;color:rgba(0, 0, 255, 1.00);background-color:transparent;}.cl-3e7881f4{font-family:'DejaVu Sans';font-size:6pt;font-weight:normal;font-style:normal;text-decoration:none;color:rgba(0, 0, 0, 1.00);background-color:transparent;}.cl-3e7bb52c{margin:0;text-align:right;border-bottom: 0 solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);padding-bottom:5pt;padding-top:5pt;padding-left:5pt;padding-right:5pt;line-height: 1;background-color:transparent;}.cl-3e7bda3e{width:0.75in;background-color:transparent;vertical-align: middle;border-bottom: 2pt solid rgba(0, 0, 0, 1.00);border-top: 2pt solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-3e7bda48{width:0.75in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(0, 0, 0, 1.00);border-top: 0 solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-3e7bda52{width:0.75in;background-color:transparent;vertical-align: middle;border-bottom: 1pt solid rgba(0, 0, 0, 1.00);border-top: 1pt solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}.cl-3e7bda53{width:0.75in;background-color:transparent;vertical-align: middle;border-bottom: 2pt solid rgba(0, 0, 0, 1.00);border-top: 1pt solid rgba(0, 0, 0, 1.00);border-left: 0 solid rgba(0, 0, 0, 1.00);border-right: 0 solid rgba(0, 0, 0, 1.00);margin-bottom:0;margin-top:0;margin-left:0;margin-right:0;}


mpg
```
