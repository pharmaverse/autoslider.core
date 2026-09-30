# To flextable

Convert the dataframe into flextable, and merge the cells that have
colspan \> 1. align the columns to the middle, and the row.names to the
left. indent the row.names by 10 times indention.

## Usage

``` r
# S3 method for class 'Ddataframe'
to_flextable(x, lpp, table_format = table_format, ...)

# S3 method for class 'Ddataframe'
to_flextable(x, lpp, table_format = table_format, ...)
```

## Arguments

- x:

  dataframe

- lpp:

  {lpp} from {paginate_table}. numeric. Maximum lines per page

- table_format:

  Table format

- ...:

  arguments passed to program

## Details

convert the dataframe object into flextable, and merge the cells that
have colspan \> 1. align the columns to the middle, and the row.names to
the left. indent the row.names by 10 times indention. titles are added
in headerlines, footnotes are added in footer lines, The width of the
columns are aligned based on autofit() of officer function. For
paginated table, the width of the 1st column are set as the widest 1st
column among paginated tables
