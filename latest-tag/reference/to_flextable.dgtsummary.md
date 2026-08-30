# convert dgtsummary to flextable

convert dgtsummary to flextable

## Usage

``` r
# S3 method for class 'dgtsummary'
to_flextable(
  x,
  lpp = 20,
  ppt_height = NULL,
  ppt_width = NULL,
  table_format = autoslider_format,
  ...
)
```

## Arguments

- x:

  dgtsummary object

- lpp:

  Lines (rows) per page; overridden when ppt_height is supplied

- ppt_height:

  Slide height in inches; used to auto-compute lpp

- ppt_width:

  Slide width in inches; used to scale table columns

- table_format:

  Function applied to the flextable for styling

- ...:

  additional arguments, not used
