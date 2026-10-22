# convert dgtsummary to flextable

convert dgtsummary to flextable

## Usage

``` r
# S3 method for class 'dgtsummary'
to_flextable(
  x,
  lpp = NULL,
  cpp = NULL,
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

  Lines (rows) per page. If \`NULL\` (the default), auto-computed from
  \`ppt_height\`, falling back to a fixed default if that is also
  \`NULL\`. An explicit value always takes precedence over
  \`ppt_height\`.

- cpp:

  Columns per page. gtsummary tables do not support column pagination;
  this is accepted only so that a warning can be raised when the table
  is too wide for \`ppt_width\` and would otherwise be silently scaled
  down instead of split.

- ppt_height:

  Slide height in inches; used to auto-compute lpp

- ppt_width:

  Slide width in inches; used to scale table columns

- table_format:

  Function applied to the flextable for styling

- ...:

  additional arguments, not used
