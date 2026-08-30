# Table of AEs of Special Interest adapted from https://insightsengineering.github.io/tlg-catalog/stable/tables/adverse-events/aet01_aesi.html

Table of AEs of Special Interest adapted from
https://insightsengineering.github.io/tlg-catalog/stable/tables/adverse-events/aet01_aesi.html

## Usage

``` r
t_aesi_slide(adsl, adae, aesi, arm = "ACTARM", grad_var = "AETOXGR")
```

## Arguments

- adsl:

  ADSL data set, dataframe

- adae:

  ADAE data set, dataframe.

- aesi:

  AESI variable which will act as a filter to select the rows required
  to create the table. An example of AESI variable is CQ01NAM.

- arm:

  Arm variable, character, \`"ACTARM"\` by default.

- grad_var:

  Grading variable, character, \`"AETOXGR"\` by default.

## Value

rtables object

## Author

Kai Xiang Lim (\`limk43\`)

## Examples

``` r
library(dplyr)
adsl <- eg_adsl
adae <- eg_adae
adae_atoxgr <- adae %>% dplyr::mutate(ATOXGR = AETOXGR)
t_aesi_slide(adsl, adae, aesi = "CQ01NAM")
#>                                                                                    A: Drug X    B: Placebo    C: Combination
#>                                                                                     (N=134)       (N=134)        (N=132)    
#> ————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#> Total number of patients with at least one AESI                                   97 (72.4%)    93 (69.4%)      99 (75.0%)  
#> Total number of AESIs                                                                 396           380            465      
#> Total number of patients with at least one AESI by worst grade                                                              
#>   Grade 1                                                                          4 (3.0%)      3 (2.2%)           0       
#>   Grade 2                                                                          6 (4.5%)      10 (7.5%)       7 (5.3%)   
#>   Grade 3                                                                         18 (13.4%)    14 (10.4%)      16 (12.1%)  
#>   Grade 4                                                                         15 (11.2%)    20 (14.9%)      18 (13.6%)  
#>   Grade 5 (fatal outcome)                                                         76 (56.7%)    70 (52.2%)      75 (56.8%)  
#> Total number of patients with study drug withdrawn due to AESI                    21 (15.7%)    15 (11.2%)      26 (19.7%)  
#> Total number of patients with dose modified/interrupted due to AESI               56 (41.8%)    63 (47.0%)      64 (48.5%)  
#> Total number of patients with treatment received for AESI                         91 (67.9%)    93 (69.4%)      95 (72.0%)  
#> Total number of patients with all non-fatal AESIs resolved                        23 (17.2%)    17 (12.7%)      19 (14.4%)  
#> Total number of patients with at least one unresolved or ongoing non-fatal AESI   96 (71.6%)    100 (74.6%)     97 (73.5%)  
#> Total number of patients with at least one serious AESI                           104 (77.6%)   101 (75.4%)     99 (75.0%)  
#> Total number of patients with at least one related AESI                           99 (73.9%)    98 (73.1%)     102 (77.3%)  
t_aesi_slide(adsl, adae, aesi = "CQ01NAM", arm = "ARM", grad_var = "AESEV")
#>                                                                                    A: Drug X    B: Placebo    C: Combination
#>                                                                                     (N=134)       (N=134)        (N=132)    
#> ————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#> Total number of patients with at least one AESI                                   97 (72.4%)    93 (69.4%)      99 (75.0%)  
#> Total number of AESIs                                                                 396           380            465      
#> Total number of patients with at least one AESI by worst grade                                                              
#>   Mild                                                                             4 (3.0%)      3 (2.2%)           0       
#>   Moderate                                                                        24 (17.9%)    24 (17.9%)      23 (17.4%)  
#>   Severe                                                                          91 (67.9%)    90 (67.2%)      93 (70.5%)  
#> Total number of patients with study drug withdrawn due to AESI                    21 (15.7%)    15 (11.2%)      26 (19.7%)  
#> Total number of patients with dose modified/interrupted due to AESI               56 (41.8%)    63 (47.0%)      64 (48.5%)  
#> Total number of patients with treatment received for AESI                         91 (67.9%)    93 (69.4%)      95 (72.0%)  
#> Total number of patients with all non-fatal AESIs resolved                        23 (17.2%)    17 (12.7%)      19 (14.4%)  
#> Total number of patients with at least one unresolved or ongoing non-fatal AESI   96 (71.6%)    100 (74.6%)     97 (73.5%)  
#> Total number of patients with at least one serious AESI                           104 (77.6%)   101 (75.4%)     99 (75.0%)  
#> Total number of patients with at least one related AESI                           99 (73.9%)    98 (73.1%)     102 (77.3%)  
t_aesi_slide(adsl, adae_atoxgr, aesi = "CQ01NAM", grad_var = "ATOXGR")
#>                                                                                    A: Drug X    B: Placebo    C: Combination
#>                                                                                     (N=134)       (N=134)        (N=132)    
#> ————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#> Total number of patients with at least one AESI                                   97 (72.4%)    93 (69.4%)      99 (75.0%)  
#> Total number of AESIs                                                                 396           380            465      
#> Total number of patients with at least one AESI by worst grade                                                              
#>   Grade 1                                                                          4 (3.0%)      3 (2.2%)           0       
#>   Grade 2                                                                          6 (4.5%)      10 (7.5%)       7 (5.3%)   
#>   Grade 3                                                                         18 (13.4%)    14 (10.4%)      16 (12.1%)  
#>   Grade 4                                                                         15 (11.2%)    20 (14.9%)      18 (13.6%)  
#>   Grade 5 (fatal outcome)                                                         76 (56.7%)    70 (52.2%)      75 (56.8%)  
#> Total number of patients with study drug withdrawn due to AESI                    21 (15.7%)    15 (11.2%)      26 (19.7%)  
#> Total number of patients with dose modified/interrupted due to AESI               56 (41.8%)    63 (47.0%)      64 (48.5%)  
#> Total number of patients with treatment received for AESI                         91 (67.9%)    93 (69.4%)      95 (72.0%)  
#> Total number of patients with all non-fatal AESIs resolved                        23 (17.2%)    17 (12.7%)      19 (14.4%)  
#> Total number of patients with at least one unresolved or ongoing non-fatal AESI   96 (71.6%)    100 (74.6%)     97 (73.5%)  
#> Total number of patients with at least one serious AESI                           104 (77.6%)   101 (75.4%)     99 (75.0%)  
#> Total number of patients with at least one related AESI                           99 (73.9%)    98 (73.1%)     102 (77.3%)  
```
