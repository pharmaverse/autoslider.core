# Plot mean values general function used by wrappers \`g_vs_slide\`,\`g_lb_slide\`, & \`g_eg_slide\`

adapted from
https://insightsengineering.github.io/tlg-catalog/stable/graphs/other/mng01.html

## Usage

``` r
g_mean_general(
  adsl,
  data,
  variables = control_lineplot_vars(group_var = "TRT01P"),
  by_vars = c("USUBJID", "STUDYID"),
  subtitle = "Plot of Mean and 95% Confidence Limits by Visit.",
  ...
)
```

## Arguments

- adsl:

  ADSL dataset

- data:

  dataset containing the variable of interest in PARAMCD and AVAL

- variables:

  (named `character`) vector of variable names in `df` which should
  include:

  - `x` (`string`)\
    name of x-axis variable.

  - `y` (`string`)\
    name of y-axis variable.

  - `group_var` (`string` or `NULL`)\
    name of grouping variable (or strata), i.e. treatment arm. Can be
    `NA` to indicate lack of groups.

  - `subject_var` (`string` or `NULL`)\
    name of subject variable. Only applies if `group_var` is not NULL.

  - `paramcd` (`string` or `NA`)\
    name of the variable for parameter's code. Used for y-axis label and
    plot's subtitle. Can be `NA` if `paramcd` is not to be added to the
    y-axis label or subtitle.

  - `y_unit` (`string` or `NA`)\
    name of variable with units of `y`. Used for y-axis label and plot's
    subtitle. Can be `NA` if y unit is not to be added to the y-axis
    label or subtitle.

  - `facet_var` (`string` or `NA`)\
    name of the secondary grouping variable used for plot faceting, i.e.
    treatment arm. Can be `NA` to indicate lack of groups.

- by_vars:

  variables to merge the two datasets by

- subtitle:

  character scalar forwarded to g_lineplot

- ...:

  additional arguments passed to \`tern::g_lineplot\`

## Author

Stefan Thoma (\`thomas7\`)

## Examples

``` r
library(dplyr)
advs_filtered <- eg_advs %>% filter(
  PARAMCD == "SYSBP"
)
out1 <- g_mean_general(eg_adsl, advs_filtered)
generate_slides(out1, paste0(tempdir(), "/g_mean.pptx"))
```
