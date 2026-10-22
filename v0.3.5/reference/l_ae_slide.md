# Adverse Events listing adapted from https://insightsengineering.github.io/tlg-catalog/stable/listings/adverse-events/ael02.html

Adverse Events listing adapted from
https://insightsengineering.github.io/tlg-catalog/stable/listings/adverse-events/ael02.html

## Usage

``` r
l_ae_slide(adsl, adae)
```

## Arguments

- adsl:

  ADSL data

- adae:

  ADAE data

## Examples

``` r
library(dplyr)
library(rlistings)
#> Loading required package: formatters
#> 
#> Attaching package: ‘formatters’
#> The following object is masked from ‘package:base’:
#> 
#>     %||%
#> Loading required package: tibble
adsl <- eg_adsl
adae <- eg_adae

out <- l_ae_slide(adsl = adsl, adae = adae)
head(out)
#>                                         Date of                                                             
#>                        Adverse        First Study               Caused by                             Action
#>                      Event MedDRA         Drug                    Study                               Taken 
#> Center/Patient ID   Preferred Term   Administration   Serious     Drug      Analysis Toxicity Grade    (2)  
#> ————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>   BRA-1/id-134      dcd B.2.1.2.1      04NOV2020        No         No                  3                2   
#>                     dcd D.1.1.4.2      04NOV2020        No         No                  3                2   
#>                     dcd A.1.1.1.2      04NOV2020        Yes        No                  2                2   
#>                     dcd A.1.1.1.2      04NOV2020        Yes        No                  2                5   
#>   BRA-1/id-141      dcd B.2.1.2.1      25JUL2020        No         No                  3                1   
#>                     dcd D.2.1.5.3      25JUL2020        No         Yes                 1                1   
```
