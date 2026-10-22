# Build table header, a utility function to help with construct structured header for table layout

Build table header, a utility function to help with construct structured
header for table layout

## Usage

``` r
build_table_header(anl, arm, split_by_study, side_by_side)
```

## Arguments

- anl:

  analysis data object

- arm:

  Arm variable for column split

- split_by_study, :

  if true, construct structured header with the study ID

- side_by_side:

  A logical value indicating whether to display the data side by side.

## Value

A \`rtables\` layout with desired header.
