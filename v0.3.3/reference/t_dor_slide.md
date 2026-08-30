# DOR table

DOR table

## Usage

``` r
t_dor_slide(adsl, adtte, arm = "TRT01P", refgroup = NULL)
```

## Arguments

- adsl:

  ADSL dataset

- adtte:

  ADTTE dataset

- arm:

  Arm variable, character, "\`TRT01P" by default.

- refgroup:

  Reference group

## Value

An \`rtables\` object

## Note

\* Default arm variables are set to \`"TRT01A"\` for safety output, and
\`"TRT01P"\` for efficacy output

## Examples

``` r
library(dplyr)
adsl <- eg_adsl %>%
  dplyr::mutate(TRT01P = factor(TRT01P, levels = c("A: Drug X", "B: Placebo", "C: Combination")))
adtte <- eg_adtte %>%
  dplyr::filter(PARAMCD == "OS") %>%
  dplyr::mutate(TRT01P = factor(TRT01P, levels = c("A: Drug X", "B: Placebo", "C: Combination")))
out <- t_dor_slide(adsl, adtte)
print(out)
#> DOR slide
#> 
#> ——————————————————————————————————————————————————————————————————————————
#>                                A: Drug X      B: Placebo    C: Combination
#>                                 (N=134)        (N=134)         (N=132)    
#> ——————————————————————————————————————————————————————————————————————————
#> Responders                        134            134             132      
#>   With subsequent event (%)    58 (43.3%)     58 (43.3%)      69 (52.3%)  
#>   Median (Months, 95% CI)     NA (9.3, NA)   NA (9.4, NA)   9.4 (7.6, NA) 
generate_slides(out, paste0(tempdir(), "/dor.pptx"))
#> [1] "DOR slide"
```
