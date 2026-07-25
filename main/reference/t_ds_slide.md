# Discontinue table

Discontinue table

## Usage

``` r
t_ds_slide(adsl, arm = "TRT01P", split_by_study = FALSE, side_by_side = NULL)
```

## Arguments

- adsl:

  ADSL data

- arm:

  Arm variable, character, "\`TRT01P" by default.

- split_by_study:

  Split by study, building structured header for tables

- side_by_side:

  "GlobalAsia" or "GlobalAsiaChina" to define the side by side
  requirement

## Note

\* Default arm variables are set to \`"TRT01A"\` for safety output, and
\`"TRT01P"\` for efficacy output

## Examples

``` r
library(dplyr)
adsl <- eg_adsl %>%
  mutate(DISTRTFL = sample(c("Y", "N"), size = nrow(eg_adsl), replace = TRUE, prob = c(.1, .9))) %>%
  preprocess_t_ds()
out1 <- t_ds_slide(adsl, "TRT01P")
print(out1)
#> Discontinue table
#> 
#> ————————————————————————————————————————————————————————————————————————————————————————————————
#>                                     A: Drug X      B: Placebo     C: Combination   All Patients 
#> ————————————————————————————————————————————————————————————————————————————————————————————————
#> Received Treatment                134 (100.00%)   134 (100.00%)   132 (100.00%)    400 (100.00%)
#> On-study Status                     1 (0.7%)        5 (3.7%)         1 (0.8%)        7 (1.8%)   
#>   On Treatment                          0               0               0                0      
#>   In Follow-up                      1 (0.7%)        5 (3.7%)         1 (0.8%)        7 (1.8%)   
#> Discontinued the study             42 (31.3%)      40 (29.9%)       38 (28.8%)      120 (30.0%) 
#>   Adverse Event                     3 (2.2%)        6 (4.5%)         5 (3.8%)        14 (3.5%)  
#>   Death                            25 (18.7%)      23 (17.2%)       22 (16.7%)      70 (17.5%)  
#>   Lack Of Efficacy                  2 (1.5%)        2 (1.5%)         3 (2.3%)        7 (1.8%)   
#>   Physician Decision                2 (1.5%)        3 (2.2%)         2 (1.5%)        7 (1.8%)   
#>   Protocol Violation                5 (3.7%)        3 (2.2%)          4 (3%)          12 (3%)   
#>   Withdrawal By Parent/Guardian      4 (3%)         2 (1.5%)         1 (0.8%)        7 (1.8%)   
#>   Withdrawal By Subject             1 (0.7%)        1 (0.7%)         1 (0.8%)        3 (0.8%)   
generate_slides(out1, paste0(tempdir(), "/ds.pptx"))
#> [1] "Discontinue table"
#> [1] "Discontinue table (cont.)"

out2 <- t_ds_slide(adsl, "TRT01P", split_by_study = TRUE)
print(out2)
#> Discontinue table
#> 
#> —————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>                                                    AB12345-1                                      AB12345-2                  
#>                                    A: Drug X      B: Placebo    C: Combination    A: Drug X      B: Placebo    C: Combination
#> —————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#> Received Treatment                62 (100.00%)   74 (100.00%)    64 (100.00%)    72 (100.00%)   60 (100.00%)    68 (100.00%) 
#> On-study Status                     1 (1.6%)       2 (2.7%)        0 (0.0%)        0 (0.0%)       3 (5.0%)        1 (1.5%)   
#>   On Treatment                         0              0               0               0              0               0       
#>   In Follow-up                      1 (1.6%)       2 (2.7%)           0               0            3 (5%)         1 (1.5%)   
#> Discontinued the study             19 (30.6%)     24 (32.4%)      15 (23.4%)      23 (31.9%)     16 (26.7%)      23 (33.8%)  
#>   Adverse Event                     2 (3.2%)       4 (5.4%)        4 (6.2%)        1 (1.4%)       2 (3.3%)        1 (1.5%)   
#>   Death                            12 (19.4%)     13 (17.6%)      7 (10.9%)       13 (18.1%)     10 (16.7%)      15 (22.1%)  
#>   Lack Of Efficacy                  1 (1.6%)       2 (2.7%)           0            1 (1.4%)          0            3 (4.4%)   
#>   Physician Decision                2 (3.2%)       2 (2.7%)           0               0           1 (1.7%)        2 (2.9%)   
#>   Protocol Violation                1 (1.6%)       2 (2.7%)        2 (3.1%)        4 (5.6%)       1 (1.7%)        2 (2.9%)   
#>   Withdrawal By Parent/Guardian     1 (1.6%)       1 (1.4%)        1 (1.6%)        3 (4.2%)       1 (1.7%)           0       
#>   Withdrawal By Subject                0              0            1 (1.6%)        1 (1.4%)       1 (1.7%)           0       
```
