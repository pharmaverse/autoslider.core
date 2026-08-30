# Demographic table

Demographic table

## Usage

``` r
t_dm_slide(
  adsl,
  arm = "TRT01P",
  vars = c("AGE", "SEX", "RACE"),
  stats = c("median", "range", "count_fraction"),
  split_by_study = FALSE,
  side_by_side = NULL
)
```

## Arguments

- adsl:

  ADSL data set, dataframe

- arm:

  Arm variable, character, "\`TRT01P" by default.

- vars:

  Characters of variables

- stats:

  see \`.stats\` from \[tern::analyze_vars()\]

- split_by_study:

  Split by study, building structured header for tables

- side_by_side:

  "GlobalAsia" or "GlobalAsiaChina" to define the side by side
  requirement

## Value

rtables object

## Note

\* Default arm variables are set to \`"TRT01A"\` for safety output, and
\`"TRT01P"\` for efficacy output

## Examples

``` r
library(dplyr)
adsl <- eg_adsl
out1 <- t_dm_slide(adsl, "TRT01P", c("SEX", "AGE", "RACE", "ETHNIC", "COUNTRY"))
print(out1)
#> Demographic slide
#> 
#> ———————————————————————————————————————————————————————————————————————————————————————————————————————
#>                                                A: Drug X    B: Placebo    C: Combination   All Patients
#> ———————————————————————————————————————————————————————————————————————————————————————————————————————
#> Sex                                                                                                    
#>   F                                            79 (59%)     82 (61.2%)       70 (53%)      231 (57.8%) 
#>   M                                            55 (41%)     52 (38.8%)       62 (47%)      169 (42.2%) 
#> Age                                                                                                    
#>   Median                                         33.00         35.00          35.00           34.00    
#>   Min - Max                                   21.0 - 50.0   21.0 - 62.0    20.0 - 69.0     20.0 - 69.0 
#> Race                                                                                                   
#>   ASIAN                                       68 (50.7%)     67 (50%)       73 (55.3%)      208 (52%)  
#>   BLACK OR AFRICAN AMERICAN                   31 (23.1%)    28 (20.9%)      32 (24.2%)      91 (22.8%) 
#>   WHITE                                       27 (20.1%)    26 (19.4%)      21 (15.9%)      74 (18.5%) 
#>   AMERICAN INDIAN OR ALASKA NATIVE              8 (6%)       11 (8.2%)       6 (4.5%)       25 (6.2%)  
#>   MULTIPLE                                         0         1 (0.7%)           0            1 (0.2%)  
#>   NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER        0         1 (0.7%)           0            1 (0.2%)  
#>   OTHER                                            0             0              0               0      
#>   UNKNOWN                                          0             0              0               0      
#> Ethnicity                                                                                              
#>    NOT REPORTED                                6 (4.5%)      10 (7.5%)      11 (8.3%)       27 (6.8%)  
#>   HISPANIC OR LATINO                          15 (11.2%)    18 (13.4%)      15 (11.4%)       48 (12%)  
#>   NOT HISPANIC OR LATINO                      104 (77.6%)   103 (76.9%)    101 (76.5%)      308 (77%)  
#>   UNKNOWN                                      9 (6.7%)      3 (2.2%)        5 (3.8%)       17 (4.2%)  
#> Country                                                                                                
#>   CHN                                         74 (55.2%)    81 (60.4%)      64 (48.5%)     219 (54.8%) 
#>   USA                                          10 (7.5%)     13 (9.7%)      17 (12.9%)       40 (10%)  
#>   BRA                                          13 (9.7%)     7 (5.2%)       10 (7.6%)       30 (7.5%)  
#>   PAK                                           12 (9%)      9 (6.7%)       10 (7.6%)       31 (7.8%)  
#>   NGA                                           8 (6%)       7 (5.2%)       11 (8.3%)       26 (6.5%)  
#>   RUS                                          5 (3.7%)       8 (6%)         6 (4.5%)       19 (4.8%)  
#>   JPN                                          5 (3.7%)       4 (3%)         9 (6.8%)       18 (4.5%)  
#>   GBR                                           4 (3%)       3 (2.2%)        2 (1.5%)        9 (2.2%)  
#>   CAN                                          3 (2.2%)      2 (1.5%)        3 (2.3%)         8 (2%)   
#>   CHE                                              0             0              0               0      
generate_slides(out1, paste0(tempdir(), "/dm.pptx"))
#> [1] "Demographic slide"
#> [1] "Demographic slide (cont.)"
#> [1] "Demographic slide (cont.)"
#> [1] "Demographic slide (cont.)"

out2 <- t_dm_slide(adsl, "TRT01P", c("SEX", "AGE", "RACE", "ETHNIC", "COUNTRY"),
  split_by_study = TRUE
)
print(out2)
#> Demographic slide
#> 
#> —————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#>                                                               AB12345-1                                    AB12345-2                 
#>                                                A: Drug X    B: Placebo    C: Combination    A: Drug X    B: Placebo    C: Combination
#> —————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
#> Sex                                                                                                                                  
#>   F                                           36 (58.1%)    48 (64.9%)      33 (51.6%)     43 (59.7%)    34 (56.7%)      37 (54.4%)  
#>   M                                           26 (41.9%)    26 (35.1%)      31 (48.4%)     29 (40.3%)    26 (43.3%)      31 (45.6%)  
#> Age                                                                                                                                  
#>   Median                                         33.50         34.00          35.00           32.50         35.00          35.00     
#>   Min - Max                                   23.0 - 48.0   21.0 - 62.0    21.0 - 64.0     21.0 - 50.0   24.0 - 58.0    20.0 - 69.0  
#> Race                                                                                                                                 
#>   ASIAN                                       34 (54.8%)     37 (50%)       31 (48.4%)     34 (47.2%)     30 (50%)       42 (61.8%)  
#>   BLACK OR AFRICAN AMERICAN                    13 (21%)     14 (18.9%)      18 (28.1%)      18 (25%)     14 (23.3%)      14 (20.6%)  
#>   WHITE                                       11 (17.7%)    16 (21.6%)      11 (17.2%)     16 (22.2%)    10 (16.7%)      10 (14.7%)  
#>   AMERICAN INDIAN OR ALASKA NATIVE             4 (6.5%)      5 (6.8%)        4 (6.2%)       4 (5.6%)       6 (10%)        2 (2.9%)   
#>   MULTIPLE                                         0         1 (1.4%)           0               0             0              0       
#>   NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER        0         1 (1.4%)           0               0             0              0       
#>   OTHER                                            0             0              0               0             0              0       
#>   UNKNOWN                                          0             0              0               0             0              0       
#> Ethnicity                                                                                                                            
#>    NOT REPORTED                                3 (4.8%)      5 (6.8%)       7 (10.9%)       3 (4.2%)      5 (8.3%)        4 (5.9%)   
#>   HISPANIC OR LATINO                           8 (12.9%)    12 (16.2%)      7 (10.9%)       7 (9.7%)       6 (10%)       8 (11.8%)   
#>   NOT HISPANIC OR LATINO                      45 (72.6%)    55 (74.3%)      50 (78.1%)     59 (81.9%)     48 (80%)        51 (75%)   
#>   UNKNOWN                                      6 (9.7%)      2 (2.7%)           0           3 (4.2%)      1 (1.7%)        5 (7.4%)   
#> Country                                                                                                                              
#>   CHN                                         29 (46.8%)    50 (67.6%)      29 (45.3%)     45 (62.5%)    31 (51.7%)      35 (51.5%)  
#>   USA                                          4 (6.5%)      4 (5.4%)        6 (9.4%)       6 (8.3%)       9 (15%)       11 (16.2%)  
#>   BRA                                          9 (14.5%)     3 (4.1%)        5 (7.8%)       4 (5.6%)      4 (6.7%)        5 (7.4%)   
#>   PAK                                          5 (8.1%)      5 (6.8%)        5 (7.8%)       7 (9.7%)      4 (6.7%)        5 (7.4%)   
#>   NGA                                          3 (4.8%)      4 (5.4%)        6 (9.4%)       5 (6.9%)       3 (5%)         5 (7.4%)   
#>   RUS                                          5 (8.1%)      4 (5.4%)        5 (7.8%)           0         4 (6.7%)        1 (1.5%)   
#>   JPN                                          3 (4.8%)          0           5 (7.8%)       2 (2.8%)      4 (6.7%)        4 (5.9%)   
#>   GBR                                          2 (3.2%)      2 (2.7%)           0           2 (2.8%)      1 (1.7%)        2 (2.9%)   
#>   CAN                                          2 (3.2%)      2 (2.7%)        3 (4.7%)       1 (1.4%)          0              0       
#>   CHE                                              0             0              0               0             0              0       
```
