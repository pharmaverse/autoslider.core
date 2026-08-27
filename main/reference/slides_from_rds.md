# Generate slides from rds files

Generate slides from rds files

## Usage

``` r
slides_from_rds(
  filenames,
  outfile = paste0(tempdir(), "/output.pptx"),
  template = file.path(system.file(package = "autoslider.core"), "theme/basic.pptx")
)
```

## Arguments

- filenames:

  List of file names

- outfile:

  Out file path

- template:

  Template file path

## Value

No return value, called for side effects

## Examples

``` r
library(dplyr, warn.conflicts = FALSE)

data <- list(
  adsl = eg_adsl,
  adae = eg_adae,
  adtte = eg_adtte
)

filters::load_filters(
  yaml_file = system.file("filters.yml", package = "autoslider.core"),
  overwrite = TRUE
)

## For this example the outputs will be saved in a temporary directory. In a
## production run this should be the reporting event's 'output' folder instead.
output_dir <- tempdir()

spec_file <- system.file("spec.yml", package = "autoslider.core")
read_spec(spec_file) %>%
  filter_spec(program == "t_dm_slide") %>%
  generate_outputs(datasets = data) %>%
  decorate_outputs() %>%
  save_outputs(outfolder = output_dir)
#> ✔ 2/51 outputs matched the filter condition `program == "t_dm_slide"`.
#> ❯ Running program `t_dm_slide` with suffix 'FAS'.
#> Filter 'FAS' matched target ADSL.
#> 400/400 records matched the filter condition `FASFL == 'Y'`.
#> ❯ Running program `t_dm_slide` with suffix 'FAS'.
#> Filter 'FAS' matched target ADSL.
#> 400/400 records matched the filter condition `FASFL == 'Y'`.
#> ✔ Output saved in path /tmp/RtmpCvBl77/t_dm_slide_FAS
#> ✔ Output saved in path /tmp/RtmpCvBl77/t_dm_slide_FAS
#> ✔ Total number of success 2/2
#> $t_dm_slide_FAS
#> An object of class "dVTableTree"
#> Slot "tbl":
#>  Patient Demographics and Baseline Characteristics, Full Analysis Set
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
#> ———————————————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> t_dm_slide footnote
#> Confidential and for internal use only
#> GitHub repository: NA
#> Git hash: 94b16b07c2ceaad002d5124d16f1c4fc8ffdb69f
#> 
#> Slot "titles":
#>  Patient Demographics and Baseline Characteristics, Full Analysis Set
#> 
#> Slot "footnotes":
#> [1] "t_dm_slide footnote"                   
#> [2] "Confidential and for internal use only"
#> 
#> Slot "usernotes":
#> [1] ""
#> 
#> Slot "paper":
#> [1] "L6"
#> 
#> Slot "width":
#> [1] 41 11 11 14 12
#> 
#> 
#> $t_dm_slide_FAS
#> An object of class "dVTableTree"
#> Slot "tbl":
#>  Patient Demographics and Baseline Characteristics, Full Analysis Set
#> 
#> ———————————————————————————————————————————————————————————————————————————————————————————————————————
#>                                                                 Global                                 
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
#> ———————————————————————————————————————————————————————————————————————————————————————————————————————
#> 
#> t_dm_slide footnote
#> Confidential and for internal use only
#> GitHub repository: NA
#> Git hash: 94b16b07c2ceaad002d5124d16f1c4fc8ffdb69f
#> 
#> Slot "titles":
#>  Patient Demographics and Baseline Characteristics, Full Analysis Set
#> 
#> Slot "footnotes":
#> [1] "t_dm_slide footnote"                   
#> [2] "Confidential and for internal use only"
#> 
#> Slot "usernotes":
#> [1] ""
#> 
#> Slot "paper":
#> [1] "L6"
#> 
#> Slot "width":
#> [1] 41 11 11 14 12
#> 
#> 

slides_from_rds(list.files(file.path(output_dir, "t_dm_slide_FAS.rds")))
```
