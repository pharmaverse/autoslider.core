# Listing of Vital Signs: Safety-Evaluable Patients

This function generates a listing with vital signs of patients. It
creates various columns such as patient identifier, age/sex/race, visit,
and calculates the range of several vital signs. The output listing
includes labels for each column and a main title.

## Usage

``` r
l_vs_slide(adsl, advs, trt_var = "TRT01A")
```

## Arguments

- adsl:

  A dataframe representing the \`ADSL\` data. Used to propagate filters
  to \`ADVS\`

- advs:

  A dataframe representing the ADVS data.

- trt_var:

  Character scalar or \`NULL\`. \`"TRT01A"\` by default. Specifies which
  variable, if any, should be included as the treatment arm.

## Value

A listing object of vital signs of patients

## Details

The function first validates whether the required columns are present in
the ADVS dataframe. Then, various calculations and transformations are
performed to create additional columns. Finally, the data is formatted
into a listing with appropriate column labels.

## See also

[Vital signs
Listing](https://insightsengineering.github.io/tlg-catalog/stable/listings/vital-signs/vsl01.html)

## Examples

``` r
require(dplyr)
require(rlistings)
adsl <- eg_adsl
advs <- eg_advs %>% filter(SUBJID %in% c("id-236", "id-65", "id-93"))

# Default usage
l_vs_slide(adsl = adsl, advs = advs, trt_var = "TRT01A")
#> Listing of Vital Signs: Safety-Evaluable Patients
#> 
#> ————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>                                                                                                                                 Diastolic Blood                                                         
#>                                                                                                                                    Pressure,      Systolic Blood                                        
#>                                                                                               Weight                                Sitting          Pressure,                          Respiratory Rate
#>                                                                                               Result       Temperature Result       Result            Sitting       Pulse Rate Result        Result     
#>                                                                                   Study       (Kg);               (C);               (Pa);             (Pa);          (beats/min);       (breaths/min); 
#> Treatment    Center/Subject ID            Age/Sex/Race                Visit        Day    Range:(40-100)   Range:(36.1-37.2)    Range:(80-120)    Range:(120-180)    Range:(60-100)      Range:(12-20)  
#> ————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#> A: Drug X        BRA-1/93                  34/F/ASIAN             WEEK 1 DAY 8     402         47.51             35.50/L             94.27            98.82/L             72.44               14.97     
#>                                                                   WEEK 2 DAY 15    460         67.64             37.96/H            109.98           104.21/L           104.70/H              14.90     
#>                                                                   WEEK 3 DAY 22    464         53.06              36.33              90.17            139.66            111.13/H             22.86/H    
#>                                                                   WEEK 4 DAY 29    496         61.68             33.52/L            112.76            128.82              72.89              20.77/H    
#>                                                                   WEEK 5 DAY 36    538         53.98             35.71/L             80.20            137.16              96.63               18.10     
#> B: Placebo       BRA-1/236       32/M/BLACK OR AFRICAN AMERICAN   WEEK 1 DAY 8     486        37.04/L             36.11            120.31/H           146.04              65.75              22.69/H    
#>                                                                   WEEK 2 DAY 15    678         80.66             35.64/L            106.20            146.80              82.04               16.89     
#>                                                                   WEEK 3 DAY 22    762         86.71              36.16             104.63            76.01/L             70.13               19.70     
#>                                                                   WEEK 4 DAY 29    773         48.43             35.38/L            111.13            134.79              80.78               17.98     
#>                                                                   WEEK 5 DAY 36    901        24.05/L            35.90/L            108.01            137.95              68.35               8.48/L    
#>                  BRA-1/65        25/F/BLACK OR AFRICAN AMERICAN   WEEK 1 DAY 8     546         60.68             34.67/L            113.72            132.45              76.37               16.70     
#>                                                                   WEEK 2 DAY 15    604         55.85             38.63/H           127.03/H           133.52              93.95               15.08     
#>                                                                   WEEK 3 DAY 22    723         47.66              37.02             116.06            91.36/L             62.00               3.89/L    
#>                                                                   WEEK 4 DAY 29    791       116.89/H            37.90/H            113.53            170.65              96.86               6.73/L    
#>                                                                   WEEK 5 DAY 36    800         56.73              36.81            141.54/H           165.15              75.85              23.02/H    
#> ————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> Baseline is the patient's last observation prior to initiation of study drug. Abnormalities are flagged as high (H) or low (L) if outside the Roche standard reference range.

# Custom treatment variable
l_vs_slide(adsl = adsl, advs = advs, trt_var = NULL)
#> Listing of Vital Signs: Safety-Evaluable Patients
#> 
#> ———————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>                                                                                                                    Diastolic Blood                                                         
#>                                                                                                                       Pressure,      Systolic Blood                                        
#>                                                                                  Weight                                Sitting          Pressure,                          Respiratory Rate
#>                                                                                  Result       Temperature Result       Result            Sitting       Pulse Rate Result        Result     
#>                                                                      Study       (Kg);               (C);               (Pa);             (Pa);          (beats/min);       (breaths/min); 
#> Center/Subject ID            Age/Sex/Race                Visit        Day    Range:(40-100)   Range:(36.1-37.2)    Range:(80-120)    Range:(120-180)    Range:(60-100)      Range:(12-20)  
#> ———————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>     BRA-1/236       32/M/BLACK OR AFRICAN AMERICAN   WEEK 1 DAY 8     486        37.04/L             36.11            120.31/H           146.04              65.75              22.69/H    
#>                                                      WEEK 2 DAY 15    678         80.66             35.64/L            106.20            146.80              82.04               16.89     
#>                                                      WEEK 3 DAY 22    762         86.71              36.16             104.63            76.01/L             70.13               19.70     
#>                                                      WEEK 4 DAY 29    773         48.43             35.38/L            111.13            134.79              80.78               17.98     
#>                                                      WEEK 5 DAY 36    901        24.05/L            35.90/L            108.01            137.95              68.35               8.48/L    
#>     BRA-1/65        25/F/BLACK OR AFRICAN AMERICAN   WEEK 1 DAY 8     546         60.68             34.67/L            113.72            132.45              76.37               16.70     
#>                                                      WEEK 2 DAY 15    604         55.85             38.63/H           127.03/H           133.52              93.95               15.08     
#>                                                      WEEK 3 DAY 22    723         47.66              37.02             116.06            91.36/L             62.00               3.89/L    
#>                                                      WEEK 4 DAY 29    791       116.89/H            37.90/H            113.53            170.65              96.86               6.73/L    
#>                                                      WEEK 5 DAY 36    800         56.73              36.81            141.54/H           165.15              75.85              23.02/H    
#>     BRA-1/93                  34/F/ASIAN             WEEK 1 DAY 8     402         47.51             35.50/L             94.27            98.82/L             72.44               14.97     
#>                                                      WEEK 2 DAY 15    460         67.64             37.96/H            109.98           104.21/L           104.70/H              14.90     
#>                                                      WEEK 3 DAY 22    464         53.06              36.33              90.17            139.66            111.13/H             22.86/H    
#>                                                      WEEK 4 DAY 29    496         61.68             33.52/L            112.76            128.82              72.89              20.77/H    
#>                                                      WEEK 5 DAY 36    538         53.98             35.71/L             80.20            137.16              96.63               18.10     
#> ———————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> Baseline is the patient's last observation prior to initiation of study drug. Abnormalities are flagged as high (H) or low (L) if outside the Roche standard reference range.
```
