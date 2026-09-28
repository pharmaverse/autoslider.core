# Medical history table

Summarize medical history by system organ class (SOC) and preferred term
(PT). ADSL defines both the analysis population and the treatment
denominators. ADMH records for subjects not present in ADSL are
excluded, and treatment is derived from ADSL. If ADMH also contains
`arm`, its non-missing values must agree with ADSL for the same subject.

## Usage

``` r
t_mh_slide(adsl, admh, arm = "TRT01A", add_all_patients_col = TRUE)
```

## Arguments

- adsl:

  Subject-level analysis dataset. It must contain one row per
  non-missing `USUBJID` and the treatment variable named by `arm`.

- admh:

  Medical history analysis dataset. It must contain `USUBJID`,
  `MHBODSYS`, and `MHDECOD`.

- arm:

  Name of the treatment variable in `adsl`, character scalar; `"TRT01A"`
  by default.

- add_all_patients_col:

  Logical scalar indicating whether an additional `All Patients` column
  is displayed.

## Value

An `rtables::VTableTree` object.

## Details

Counts for the overall table and each SOC include the number and
percentage of unique subjects with at least one condition and, on a
separate row, the non-unique number of condition records. PT rows
contain unique subject counts and percentages. SOCs and PTs are sorted
by decreasing total unique subject count, with labels used to break ties
deterministically. Missing or blank SOC and PT values are displayed as
`<Missing>`.

## Note

\* Default arm variables are set to \`"TRT01A"\` for safety output, and
\`"TRT01P"\` for efficacy output

## References

The table structure follows the public MHT01 example in the [TLG
Catalog](https://insightsengineering.github.io/tlg-catalog/stable/tables/medical-history/mht01.html).

## Examples

``` r
library(dplyr)
adsl <- eg_adsl %>%
  dplyr::mutate(TRT01A = factor(TRT01A))
admh <- eg_admh

out <- t_mh_slide(adsl, admh)
print(out)
#> Medical History
#> 
#> ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#> MedDRA System Organ Class                                 A: Drug X    B: Placebo    C: Combination   All Patients
#>   MedDRA Preferred Term                                    (N=134)       (N=134)        (N=132)         (N=400)   
#> ——————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#> Total number of patients with at least one condition     116 (86.6%)   120 (89.6%)    120 (90.9%)     356 (89.0%) 
#> Total number of conditions                                   618           598            703             1919    
#> cl B                                                                                                              
#>   Total number of patients with at least one condition   92 (68.7%)    90 (67.2%)      94 (71.2%)     276 (69.0%) 
#>   Total number of conditions                                 182           187            200             569     
#>   trm B_3/3                                              45 (33.6%)    46 (34.3%)      54 (40.9%)     145 (36.2%) 
#>   trm B_1/3                                              56 (41.8%)    46 (34.3%)      42 (31.8%)     144 (36.0%) 
#>   trm B_2/3                                              44 (32.8%)    45 (33.6%)      49 (37.1%)     138 (34.5%) 
#> cl D                                                                                                              
#>   Total number of patients with at least one condition   92 (68.7%)    86 (64.2%)      95 (72.0%)     273 (68.2%) 
#>   Total number of conditions                                 188           189            199             576     
#>   trm D_2/3                                              46 (34.3%)    51 (38.1%)      51 (38.6%)     148 (37.0%) 
#>   trm D_1/3                                              46 (34.3%)    50 (37.3%)      51 (38.6%)     147 (36.8%) 
#>   trm D_3/3                                              51 (38.1%)    39 (29.1%)      46 (34.8%)     136 (34.0%) 
#> cl A                                                                                                              
#>   Total number of patients with at least one condition   81 (60.4%)    74 (55.2%)      83 (62.9%)     238 (59.5%) 
#>   Total number of conditions                                 129           104            144             377     
#>   trm A_1/2                                              59 (44.0%)    47 (35.1%)      54 (40.9%)     160 (40.0%) 
#>   trm A_2/2                                              43 (32.1%)    42 (31.3%)      51 (38.6%)     136 (34.0%) 
#> cl C                                                                                                              
#>   Total number of patients with at least one condition   74 (55.2%)    72 (53.7%)      85 (64.4%)     231 (57.8%) 
#>   Total number of conditions                                 119           118            160             397     
#>   trm C_1/2                                              51 (38.1%)    45 (33.6%)      56 (42.4%)     152 (38.0%) 
#>   trm C_2/2                                              42 (31.3%)    45 (33.6%)      59 (44.7%)     146 (36.5%) 

out_without_overall <- t_mh_slide(
  adsl,
  admh,
  add_all_patients_col = FALSE
)
```
