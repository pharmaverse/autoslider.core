# Convert dates from \`yyyy-mm-dd\` format into 20APR2019 format \`Datetime\` format removes the time and outputs date in the same way Able to handle truncated dates as well (e.g. just the year or year and month)

\`dplyr::case_when()\` will check all RHS expressions on the input, this
means if these expressions return warnings, they will happen even then
the input doesn't doesn't satisfy the LHS. For this reason, I had to
'quiet' all \`lubridate\` functions. This \`format_date()\` function was
tested with the inputs in the examples, all gave the expected returned
value, so there should be no issues.

## Usage

``` r
format_date(x)
```

## Arguments

- x:

  vector of dates in character, in \`yyyy-mm-dd\` format

## Value

A vector.

## Examples

``` r
require(lubridate)

# expected to return "2019"
format_date("2019")
#> [1] "2019"

# expected to return "20APR2019"
format_date("2019-04-20")
#> [1] "20APR2019"

# expected to return ""
format_date("")
#> [1] ""

# expected to return "18JUN2019"
format_date("2019-06-18T10:32")
#> [1] "18JUN2019"

# expected to return "APR2019"
format_date("2019-04")
#> [1] "APR2019"
```
