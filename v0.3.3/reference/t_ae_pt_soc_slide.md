# Adverse event table

Adverse event table

## Usage

``` r
t_ae_pt_soc_slide(
  adsl,
  adae,
  arm,
  cutoff = NA,
  prune_by_total = FALSE,
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

  Arm variable, character

- cutoff:

  Cutoff threshold

- prune_by_total:

  Prune according total column

- split_by_study:

  Split by study, building structured header for tables

- side_by_side:

  "GlobalAsia" or "GlobalAsiaChina" to define the side by side
  requirement

## Value

rtables object

## Examples

``` r
library(dplyr)
# Example 1
adsl <- eg_adsl %>%
  dplyr::mutate(TRT01A = factor(TRT01A, levels = c("A: Drug X", "B: Placebo")))
adae <- eg_adae %>%
  dplyr::mutate(
    TRT01A = factor(TRT01A, levels = c("A: Drug X", "B: Placebo")),
    ATOXGR = AETOXGR
  )
out <- t_ae_pt_soc_slide(adsl, adae, "TRT01A", 2)
print(out)
#> Adverse Events table
#> 
#> ———————————————————————————————————————————————————————————————————————
#> MedDRA System Organ Class                                              
#>    MedDRA Preferred Term N (%)   A: Drug X    B: Placebo   All Patients
#> ———————————————————————————————————————————————————————————————————————
#> cl A.1                                                                 
#> dcd A.1.1.1.1                    45 (33.6%)   31 (23.1%)   128 (32.0%) 
#> dcd A.1.1.1.2                    41 (30.6%)   39 (29.1%)   122 (30.5%) 
#> cl B.1                                                                 
#> dcd B.1.1.1.1                    38 (28.4%)   37 (27.6%)   111 (27.8%) 
#> cl B.2                                                                 
#> dcd B.2.2.3.1                    38 (28.4%)   40 (29.9%)   123 (30.8%) 
#> dcd B.2.1.2.1                    39 (29.1%)   34 (25.4%)   119 (29.8%) 
#> cl C.1                                                                 
#> dcd C.1.1.1.3                    36 (26.9%)   34 (25.4%)   106 (26.5%) 
#> cl C.2                                                                 
#> dcd C.2.1.2.1                    28 (20.9%)   36 (26.9%)   112 (28.0%) 
#> cl D.1                                                                 
#> dcd D.1.1.1.1                    42 (31.3%)   32 (23.9%)   120 (30.0%) 
#> dcd D.1.1.4.2                    38 (28.4%)   34 (25.4%)   112 (28.0%) 
#> cl D.2                                                                 
#> dcd D.2.1.5.3                    37 (27.6%)   46 (34.3%)   133 (33.2%) 
generate_slides(out, paste0(tempdir(), "/ae.pptx"))
#> [1] "Adverse Events table"
#> [1] "Adverse Events table (cont.)"


# Example 2, prune by total column
out2 <- t_ae_pt_soc_slide(adsl, adae, "TRT01A", 25, prune_by_total = TRUE)
print(out2)
#> Adverse Events table
#> 
#> ———————————————————————————————————————————————————————————————————————
#> MedDRA System Organ Class                                              
#>    MedDRA Preferred Term N (%)   A: Drug X    B: Placebo   All Patients
#> ———————————————————————————————————————————————————————————————————————
#> cl A.1                                                                 
#> dcd A.1.1.1.1                    45 (33.6%)   31 (23.1%)   128 (32.0%) 
#> dcd A.1.1.1.2                    41 (30.6%)   39 (29.1%)   122 (30.5%) 
#> cl B.1                                                                 
#> dcd B.1.1.1.1                    38 (28.4%)   37 (27.6%)   111 (27.8%) 
#> cl B.2                                                                 
#> dcd B.2.2.3.1                    38 (28.4%)   40 (29.9%)   123 (30.8%) 
#> dcd B.2.1.2.1                    39 (29.1%)   34 (25.4%)   119 (29.8%) 
#> cl C.1                                                                 
#> dcd C.1.1.1.3                    36 (26.9%)   34 (25.4%)   106 (26.5%) 
#> cl C.2                                                                 
#> dcd C.2.1.2.1                    28 (20.9%)   36 (26.9%)   112 (28.0%) 
#> cl D.1                                                                 
#> dcd D.1.1.1.1                    42 (31.3%)   32 (23.9%)   120 (30.0%) 
#> dcd D.1.1.4.2                    38 (28.4%)   34 (25.4%)   112 (28.0%) 
#> cl D.2                                                                 
#> dcd D.2.1.5.3                    37 (27.6%)   46 (34.3%)   133 (33.2%) 
generate_slides(out2, paste0(tempdir(), "/ae2.pptx"))
#> [1] "Adverse Events table"
#> [1] "Adverse Events table (cont.)"
```
