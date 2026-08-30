# Adverse event summary table

Adverse event summary table

## Usage

``` r
t_ae_summ_slide(
  adsl,
  adae,
  arm = "TRT01A",
  dose_adjust_flags = NA,
  dose_adjust_labels = NA,
  gr34_highest_grade_only = TRUE
)
```

## Arguments

- adsl:

  ADSL dataset, dataframe

- adae:

  ADAE dataset, dataframe

- arm:

  Arm variable, character, "\`TRT01A" by default.

- dose_adjust_flags:

  Character or a vector of characters. Each character is a variable name
  in adae dataset. These variables are Logical vectors which flag AEs
  leading to dose adjustment, such as drug discontinuation, dose
  interruption and reduction. The flag can be related to any drug, or a
  specific drug.

- dose_adjust_labels:

  Character or a vector of characters. Each character represents a label
  displayed in the AE summary table (e.g. AE leading to discontinuation
  from drug X). The order of the labels should match the order of
  variable names in `dose_adjust_flags`.

- gr34_highest_grade_only:

  A logical value. Default is TRUE, such that only patients with the
  highest AE grade as 3 or 4 are included for the count of the "Grade
  3-4 AE" and "Treatment-related Grade 3-4 AE" ; set it to FALSE if you
  want to include patients with the highest AE grade as 5.

## Value

an rtables object

## Examples

``` r
library(dplyr)
ADSL <- eg_adsl
ADAE <- eg_adae

ADAE <- ADAE %>%
  dplyr::mutate(ATOXGR = AETOXGR)
t_ae_summ_slide(adsl = ADSL, adae = ADAE)
#> Warning: Non-unique sibling analysis table names. Using Labels instead. Use the table_names argument to analyze to avoid this when analyzing the same variable multiple times.
#>  occured at (row) path: root
#> AE summary table
#> 
#> ———————————————————————————————————————————————————————————————————————————————————
#>                             A: Drug X    B: Placebo   C: Combination   All Patients
#>                              (N=134)      (N=134)        (N=132)         (N=400)   
#> ———————————————————————————————————————————————————————————————————————————————————
#> All grade AEs, any cause   100 (74.6%)   98 (73.1%)    103 (78.0%)     301 (75.2%) 
#>   Related                  86 (64.2%)    85 (63.4%)     92 (69.7%)     263 (65.8%) 
#> Grade 3-4 AEs              26 (19.4%)    31 (23.1%)     29 (22.0%)      86 (21.5%) 
#>   Related                   13 (9.7%)    18 (13.4%)     15 (11.4%)      46 (11.5%) 
#> Grade 5 AE                 64 (47.8%)    52 (38.8%)     64 (48.5%)     180 (45.0%) 
#>   Related                  64 (47.8%)    52 (38.8%)     64 (48.5%)     180 (45.0%) 
#> SAEs                       85 (63.4%)    80 (59.7%)     87 (65.9%)     252 (63.0%) 
#>   Related                  64 (47.8%)    52 (38.8%)     64 (48.5%)     180 (45.0%) 

# add flag for ae leading to dose reduction
ADAE$reduce_flg <- ifelse(ADAE$AEACN == "DOSE REDUCED", TRUE, FALSE)
t_ae_summ_slide(
  adsl = ADSL, adae = ADAE,
  dose_adjust_flags = c("reduce_flg"),
  dose_adjust_labels = c("AE leading to dose reduction of drug X")
)
#> Warning: Non-unique sibling analysis table names. Using Labels instead. Use the table_names argument to analyze to avoid this when analyzing the same variable multiple times.
#>  occured at (row) path: root
#> AE summary table
#> 
#> —————————————————————————————————————————————————————————————————————————————————————————————————
#>                                           A: Drug X    B: Placebo   C: Combination   All Patients
#>                                            (N=134)      (N=134)        (N=132)         (N=400)   
#> —————————————————————————————————————————————————————————————————————————————————————————————————
#> All grade AEs, any cause                 100 (74.6%)   98 (73.1%)    103 (78.0%)     301 (75.2%) 
#>   Related                                86 (64.2%)    85 (63.4%)     92 (69.7%)     263 (65.8%) 
#> Grade 3-4 AEs                            26 (19.4%)    31 (23.1%)     29 (22.0%)      86 (21.5%) 
#>   Related                                 13 (9.7%)    18 (13.4%)     15 (11.4%)      46 (11.5%) 
#> Grade 5 AE                               64 (47.8%)    52 (38.8%)     64 (48.5%)     180 (45.0%) 
#>   Related                                64 (47.8%)    52 (38.8%)     64 (48.5%)     180 (45.0%) 
#> SAEs                                     85 (63.4%)    80 (59.7%)     87 (65.9%)     252 (63.0%) 
#>   Related                                64 (47.8%)    52 (38.8%)     64 (48.5%)     180 (45.0%) 
#> AE leading to dose reduction of drug X   41 (30.6%)    37 (27.6%)     43 (32.6%)     121 (30.2%) 
# add flgs for ae leading to dose reduction, drug withdraw and drug interruption
ADAE$withdraw_flg <- ifelse(ADAE$AEACN == "DRUG WITHDRAWN", TRUE, FALSE)
ADAE$interrup_flg <- ifelse(ADAE$AEACN == "DRUG INTERRUPTED", TRUE, FALSE)
out <- t_ae_summ_slide(
  adsl = ADSL, adae = ADAE, arm = "TRT01A",
  dose_adjust_flags = c("withdraw_flg", "reduce_flg", "interrup_flg"),
  dose_adjust_labels = c(
    "AE leading to discontinuation from drug X",
    "AE leading to drug X reduction",
    "AE leading to drug X interruption"
  )
)
#> Warning: Non-unique sibling analysis table names. Using Labels instead. Use the table_names argument to analyze to avoid this when analyzing the same variable multiple times.
#>  occured at (row) path: root
print(out)
#> AE summary table
#> 
#> ————————————————————————————————————————————————————————————————————————————————————————————————————
#>                                              A: Drug X    B: Placebo   C: Combination   All Patients
#>                                               (N=134)      (N=134)        (N=132)         (N=400)   
#> ————————————————————————————————————————————————————————————————————————————————————————————————————
#> All grade AEs, any cause                    100 (74.6%)   98 (73.1%)    103 (78.0%)     301 (75.2%) 
#>   Related                                   86 (64.2%)    85 (63.4%)     92 (69.7%)     263 (65.8%) 
#> Grade 3-4 AEs                               26 (19.4%)    31 (23.1%)     29 (22.0%)      86 (21.5%) 
#>   Related                                    13 (9.7%)    18 (13.4%)     15 (11.4%)      46 (11.5%) 
#> Grade 5 AE                                  64 (47.8%)    52 (38.8%)     64 (48.5%)     180 (45.0%) 
#>   Related                                   64 (47.8%)    52 (38.8%)     64 (48.5%)     180 (45.0%) 
#> SAEs                                        85 (63.4%)    80 (59.7%)     87 (65.9%)     252 (63.0%) 
#>   Related                                   64 (47.8%)    52 (38.8%)     64 (48.5%)     180 (45.0%) 
#> AE leading to discontinuation from drug X   22 (16.4%)    21 (15.7%)     28 (21.2%)      71 (17.8%) 
#> AE leading to drug X reduction              41 (30.6%)    37 (27.6%)     43 (32.6%)     121 (30.2%) 
#> AE leading to drug X interruption            4 (3.0%)      4 (3.0%)       3 (2.3%)       11 (2.8%)  
generate_slides(out, paste0(tempdir(), "/ae_summary.pptx"))
#> [1] "AE summary table"
#> [1] "AE summary table (cont.)"
```
