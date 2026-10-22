# To flextable

To flextable

## Usage

``` r
# S3 method for class 'dVTableTree'
to_flextable(x, lpp, cpp, ...)
```

## Arguments

- x:

  decorated rtable(dVTableTree) object

- lpp:

  {lpp} from
  [paginate_table](https://insightsengineering.github.io/rtables/latest-tag/reference/paginate.html).
  numeric. Maximum lines per page

- ...:

  argument parameters

## Details

convert the VTableTree object into flextable, and merge the cells that
have colspan \> 1. align the columns to the middle, and the row.names to
the left. indent the row.names by 10 times indention. titles are added
in headerlines, footnotes are added in footer lines, The width of the
columns are aligned based on autofit() of officer function. For
paginated table, the width of the 1st column are set as the widest 1st
column among paginated tables
