# Adverse event table

Adverse event table

## Usage

``` r
t_ae_slide(
  adsl,
  adae,
  arm = "TRT01A",
  split_by_study = FALSE,
  side_by_side = NULL
)
```

## Arguments

- adsl:

  ADSL data set, dataframe

- adae:

  ADAE data set, dataframe

- arm:

  Arm variable, character, "\`TRT01A" by default.

- split_by_study:

  Split by study, building structured header for tables

- side_by_side:

  should table be displayed side by side

## Value

rtables object

## Note

\* Default arm variables are set to \`"TRT01A"\` for safety output, and
\`"TRT01P"\` for efficacy output

## Examples

``` r
library(dplyr)
adsl <- eg_adsl %>%
  dplyr::mutate(TRT01A = factor(TRT01A, levels = c("A: Drug X", "B: Placebo")))
adae <- eg_adae %>%
  dplyr::mutate(
    TRT01A = factor(TRT01A, levels = c("A: Drug X", "B: Placebo")),
    ATOXGR = AETOXGR
  )
out <- t_ae_slide(adsl, adae, "TRT01A")
print(out)
#> AE event table
#> 
#> ———————————————————————————————————————————————————————————————————————
#> MedDRA System Organ Class                                              
#>    MedDRA Preferred Term N (%)   A: Drug X    B: Placebo   All Patients
#> ———————————————————————————————————————————————————————————————————————
#> Total number of patients         78 (58.2)     75 (56)      242 (60.5) 
#> cl A.1                           78 (58.2%)   75 (56.0%)   242 (60.5%) 
#>     dcd A.1.1.1.1                50 (37.3%)   45 (33.6%)   158 (39.5%) 
#>     dcd A.1.1.1.2                48 (35.8%)   48 (35.8%)   146 (36.5%) 
#> Total number of patients          79 (59)     74 (55.2)     238 (59.5) 
#> cl B.2                           79 (59.0%)   74 (55.2%)   238 (59.5%) 
#>     dcd B.2.2.3.1                48 (35.8%)   54 (40.3%)   153 (38.2%) 
#>     dcd B.2.1.2.1                49 (36.6%)   44 (32.8%)   145 (36.2%) 
#> Total number of patients          79 (59)      67 (50)      226 (56.5) 
#> cl D.1                           79 (59.0%)   67 (50.0%)   226 (56.5%) 
#>     dcd D.1.1.1.1                50 (37.3%)   42 (31.3%)   143 (35.8%) 
#>     dcd D.1.1.4.2                48 (35.8%)   42 (31.3%)   140 (35.0%) 
#> Total number of patients         47 (35.1)    58 (43.3)     162 (40.5) 
#> cl D.2                           47 (35.1%)   58 (43.3%)   162 (40.5%) 
#>     dcd D.2.1.5.3                47 (35.1%)   58 (43.3%)   162 (40.5%) 
#> Total number of patients         47 (35.1)    49 (36.6)     139 (34.8) 
#> cl B.1                           47 (35.1%)   49 (36.6%)   139 (34.8%) 
#>     dcd B.1.1.1.1                47 (35.1%)   49 (36.6%)   139 (34.8%) 
#> Total number of patients         43 (32.1)    46 (34.3)      132 (33)  
#> cl C.1                           43 (32.1%)   46 (34.3%)   132 (33.0%) 
#>     dcd C.1.1.1.3                43 (32.1%)   46 (34.3%)   132 (33.0%) 
#> Total number of patients         35 (26.1)    48 (35.8)     138 (34.5) 
#> cl C.2                           35 (26.1%)   48 (35.8%)   138 (34.5%) 
#>     dcd C.2.1.2.1                35 (26.1%)   48 (35.8%)   138 (34.5%) 
generate_slides(out, paste0(tempdir(), "/ae.pptx"))
#> [1] "AE event table"
#> [1] "AE event table (cont.)"
#> [1] "AE event table (cont.)"
```
