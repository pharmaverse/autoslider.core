# Null report

Null report

## Usage

``` r
null_report()
```

## Value

An empty \`rtables\` object

## Details

This will create a null report similar as STREAM does. You can use it
inside output functions as shown in the example below.

## Author

Thomas Neitmann (\`neitmant\`)

## Examples

``` r
library(dplyr)
library(filters)
data <- list(
  adsl = eg_adsl,
  adae = eg_adae %>% mutate(AREL = "")
)

null_report()
#>                                                                                         
#> ————————————————————————————————————————————————————————————————————————————————————————
#>    Null Report: No observations met the reporting criteria for inclusion in this output.

## An example how to use the `null_report()` inside an output function
t_ae <- function(datasets) {
  trt <- "ACTARM"
  anl <- semi_join(
    datasets$adae,
    datasets$adsl,
    by = c("STUDYID", "USUBJID")
  )

  return(null_report())
}

data %>%
  filters::apply_filter("SER_SE") %>%
  t_ae()
#> Filter 'SE' matched target ADSL.
#> 400/400 records matched the filter condition `SAFFL == 'Y'`.
#> Filter 'SER' matched target ADAE.
#> 786/1934 records matched the filter condition `AESER == 'Y'`.
#>                                                                                         
#> ————————————————————————————————————————————————————————————————————————————————————————
#>    Null Report: No observations met the reporting criteria for inclusion in this output.
```
