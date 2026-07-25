# Generating Templates with table_templates.R

## Overview

This vignette demonstrates how to use predefined templates to create new
R scripts for generating tables.The core idea is to provide a set of
standard templates for common statistical tables, such as those for
demography (`t_dm_slide`). Users can then modify them to suit their
specific datasets and analysis needs.

## List available templates

Before generating a template, you can view all supported table templates
using the
[`list_all_templates()`](https://pharmaverse.github.io/autoslider.core/reference/list_all_templates.md)
function:

To get started, first navigate to your `autoslider.core` repo directory,
make sure you have installed the `autoslider.core` package:

``` r

setwd("~/path/to/autoslider.core")

devtools::load_all()

list_all_templates()
```

This will return a character vector of supported templates (e.g.,
`t_dm_slide`, `g_ae_slide`, etc.), each corresponding to a table type
stored in the `R/` folder of the package.

## Generate a template for your own table

Use the
[`use_template()`](https://pharmaverse.github.io/autoslider.core/reference/use_template.md)
function to generate a template script that you can customize. For
example:

``` r_function_call
use_template(template = "t_dm_slide", function_name = "demography")
```

This will create a file with the demography template at
`./programs/R/demography.R`, whose contents are displayed below.

``` r

library(dplyr)
library(autoslider.core)
demography <- function(adsl,
                       arm = "TRT01P",
                       vars = c("AGE", "SEX", "RACE"),
                       stats = c("median", "range", "count_fraction"),
                       split_by_study = FALSE,
                       side_by_side = NULL) {
  if (is.null(side_by_side)) {
    extra <- NULL
  } else {
    extra <- c("COUNTRY")
  }
  for (v in c(vars, extra)) {
    assert_that(has_name(adsl, v))
  }
  adsl1 <- adsl %>%
    select(all_of(c("STUDYID", "USUBJID", arm, vars, extra)))
  if (!is.null(side_by_side)) {
    adsl1$lvl <- "Global"
  }
  lyt <- build_table_header(adsl1, arm,
    split_by_study = split_by_study,
    side_by_side = side_by_side
  )
  lyt <- lyt %>%
    analyze_vars(
      na.rm = TRUE,
      .stats = stats,
      denom = "n",
      vars = vars,
      .formats = c(mean_sd = "xx.xx (xx.xx)", median = "xx.xx"),
      var_labels = formatters::var_labels(adsl1)[vars]
    )
  result <- lyt_to_side_by_side(lyt, adsl1, side_by_side)
  if (is.null(side_by_side)) {
    # adding "N" attribute
    arm <- col_paths(result)[[1]][1]
    n_r <- data.frame(
      ARM = toupper(names(result@col_info)),
      N = col_counts(result) %>% as.numeric()
    ) %>%
      `colnames<-`(c(paste(arm), "N")) %>%
      dplyr::arrange(get(arm))
    attr(result, "N") <- n_r
  }
  result@main_title <- "Demographic slide"
  result
}
```

Processing our data with the generated `t_dm_slide` script would look
like：

``` r

filters::load_filters(filters, overwrite = TRUE)
# read data
data <- list(
  "adsl" = eg_adsl %>%
    mutate(
      FASFL = SAFFL, # add FASFL for illustrative purpose for t_pop_slide
      # DISTRTFL is needed for t_ds_slide but is missing in example data
      DISTRTFL = sample(c("Y", "N"), size = length(TRT01A), replace = TRUE, prob = c(.1, .9))
    ) %>%
    preprocess_t_ds(), # this preproccessing is required by one of the autoslider.core functions
  "adae" = eg_adae,
  "adtte" = eg_adtte,
  "adrs" = eg_adrs,
  "adlb" = eg_adlb
)
demography(data$adsl)
#> Demographic slide
#> 
#> ———————————————————————————————————————————————————————————————————————————————————————————————————————
#>                                                A: Drug X    B: Placebo    C: Combination   All Patients
#> ———————————————————————————————————————————————————————————————————————————————————————————————————————
#> Age                                                                                                    
#>   Median                                         33.00         35.00          35.00           34.00    
#>   Min - Max                                   21.0 - 50.0   21.0 - 62.0    20.0 - 69.0     20.0 - 69.0 
#> Sex                                                                                                    
#>   F                                            79 (59%)     82 (61.2%)       70 (53%)      231 (57.8%) 
#>   M                                            55 (41%)     52 (38.8%)       62 (47%)      169 (42.2%) 
#> Race                                                                                                   
#>   ASIAN                                       68 (50.7%)     67 (50%)       73 (55.3%)      208 (52%)  
#>   BLACK OR AFRICAN AMERICAN                   31 (23.1%)    28 (20.9%)      32 (24.2%)      91 (22.8%) 
#>   WHITE                                       27 (20.1%)    26 (19.4%)      21 (15.9%)      74 (18.5%) 
#>   AMERICAN INDIAN OR ALASKA NATIVE              8 (6%)       11 (8.2%)       6 (4.5%)       25 (6.2%)  
#>   MULTIPLE                                         0         1 (0.7%)           0            1 (0.2%)  
#>   NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER        0         1 (0.7%)           0            1 (0.2%)  
#>   OTHER                                            0             0              0               0      
#>   UNKNOWN                                          0             0              0               0
```

Following this process, you have successfully generated a reusable
`demography` function that processes clinical data, and convert it into
a standard demographic table, including statistical insights like range,
median, and count fractions to variables AGE, SEX, and RACE.

Naturally, you may want to customize the script to cater to the dataset
characteristics or study objectives. To create multiple versions from
the same template for specific analytics requirements, we have made it
possible to do so by passing in different `function_name`. For example:

``` r_function_call
use_template(template = "l_ae_slide", function_name = "l_ae_slide_001")
# which generates an Adverse Events listing at ./programs/R/l_ae_slide_001.R

use_template(template = "l_ae_slide", function_name = "l_ae_slide_v2")
# which generates an Adverse Events listing at ./programs/R/l_ae_slide_v2.R
```

### Notes

- The `template` argument must match one of the entries in
  list_all_templates().

- If a file with the same name already exists, it will not be
  overwritten unless you set `overwrite = TRUE`.

- In interactive mode, the generated file will open in your R editor for
  immediate editing.

## Customize the template

Feel free to modify the template script to suit your dataset or
statistical needs. For instance, you can:

- Add or remove table columns

- Customize labels and formatting

- Modify the summary statistics
