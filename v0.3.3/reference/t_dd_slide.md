# Death table

Death table

## Usage

``` r
t_dd_slide(adsl, arm = "TRT01A", split_by_study = FALSE, side_by_side = NULL)
```

## Arguments

- adsl:

  ADSL data set, dataframe

- arm:

  Arm variable, character, "\`TRT01A" by default.

- split_by_study:

  Split by study, building structured header for tables

- side_by_side:

  used for studies in China. "GlobalAsia" or "GlobalAsiaChina" to define
  the side by side requirement.

## Value

rtables object

## Note

\* Default arm variables are set to \`"TRT01A"\` for safety output, and
\`"TRT01P"\` for efficacy output

## Examples

``` r
library(dplyr)
adsl <- eg_adsl %>% preprocess_t_dd()
out1 <- t_dd_slide(adsl, "TRT01A")
print(out1)
#> Death table
#> 
#> —————————————————————————————————————————————————————————————————————————————————
#> N (%)                    A: Drug X    B: Placebo    C: Combination   All Patients
#> —————————————————————————————————————————————————————————————————————————————————
#> All Deaths              25 (18.66%)   23 (17.16%)    22 (16.67%)     70 (17.50%) 
#>                                                                                  
#>   Progressive Disease     8 (32%)      6 (26.1%)      6 (27.3%)       20 (28.6%) 
#>   Adverse Events          9 (36%)      7 (30.4%)      10 (45.5%)      26 (37.1%) 
#>   Other                   8 (32%)     10 (43.5%)      6 (27.3%)       24 (34.3%) 
generate_slides(out1, paste0(tempdir(), "/dd.pptx"))
#> [1] "Death table"

out2 <- t_dd_slide(adsl, "TRT01A", split_by_study = TRUE)
print(out2)
#> Death table
#> 
#> ———————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>                                         AB12345-1                                    AB12345-2                 
#> N (%)                    A: Drug X    B: Placebo    C: Combination    A: Drug X    B: Placebo    C: Combination
#> ———————————————————————————————————————————————————————————————————————————————————————————————————————————————
#> All Deaths              12 (19.35%)   13 (17.57%)     7 (10.94%)     13 (18.06%)   10 (16.67%)    15 (22.06%)  
#>                                                                                                                
#>   Progressive Disease    4 (33.3%)     3 (23.1%)      3 (42.9%)       4 (30.8%)      3 (30%)        3 (20%)    
#>   Adverse Events         5 (41.7%)     5 (38.5%)      2 (28.6%)       4 (30.8%)      2 (20%)       8 (53.3%)   
#>   Other                   3 (25%)      5 (38.5%)      2 (28.6%)       5 (38.5%)      5 (50%)       4 (26.7%)   
```
