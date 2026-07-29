# How to use autoslider.core

In this vignette we show the general `autoslider.core` workflow, how you
can create functions that produce study-specific outputs, and how you
can integrate them into the `autoslider.core` framework.

## Requirements

Of course, you need to have the `autoslider.core` package installed, and
you need to have data available. In this example I use example data
stored in the `autoslider.core` package.

The data needs to be stored in a named list where the names should
correspond to ADaM data sets.

## Workflow

The folder structure could look something like:

    ├── programs
    │   ├── run_script.R
    │   ├── R   
    |   |   ├── helping_functions.R
    |   |   ├── output_functions.R
    ├── outputs
    ├── specs.yml
    ├── filters.yml

The `autoslideR` workflow would be implemented in the `run_script.R`
file. This workflow does not require the files in `R/`. However, if
custom output-creating functions are implemented, `R/` would be the
place to put them.

The `autoslideR` workflow has four main aspects:

### The specifications `specs.yml`

This file contains the specifications of all outputs you would like to
create.

For each output we define specific information, namely the program name,
the footnotes & titles, the paper (this indicates the orientation, P for
portrait and L for landscape, the number indicates the font size), the
suffix and `args`.

It could look something like that:

    - program: t_ds_slide
      titles: Patient Disposition ({filter_titles("adsl")})
      footnotes: 't_ds footnotes'
      paper: L6
      suffix: ITT
    - program: t_dm_slide
      titles: Patient Demographics and Baseline Characteristics
      footnotes: 't_dm_slide footnote'
      paper: L6
      suffix: ITT
      args:
        arm: "TRT01A"
        vars: ["SEX", "AGE", "RACE", "ETHNIC", "COUNTRY"]

The program name refers to a function that produces an output. This
could be one of the `_slide` functions in `autoslider.core` or a custom
function.

Titles and footnotes are added once the outputs are created. We refer to
that as decorating the outputs.

The suffix specifies the name of the filters that are applied to the
data, before the data is funneled into the function (program). The
filters themselves are specified in the `filters.yml` file.

### The filters `filters.yml`

In `filters.yml` we specify the names of the filters used across the
outputs. Each filter has a name (e.g. `FAS`), a title
(`Full Analysis Set`), and then the filtering condition on a target
dataset. The filter title may be appended to the output title. For the
`t_ds_slides` slide above all filter titles that target the adsl dataset
would be included in the brackets. We would thus expect the title to
read: “Patient Disposition (Full Analysis Set)”

\[what is the type?\]

As you can see, we don’t just have population filters, but also filters
on serious adverse events. We can thus produce SAE tables by just
supplying the serious adverse events to the AE table function. This
concept generalizes also to `PARAMCD` values.

    ITT:
      title: Intent to Treat Population
      condition: ITTFL =='Y'
      target: adsl
      type: slref
    SAS:
      title: Secondary Analysis Set
      condition: SASFL == 'Y'
      target: adsl
      type: slref
    SE:
      title: Safety Evaluable Population
      condition: SAFFL=='Y'
      target: adsl
      type: slref
    SER:
      title: Serious Adverse Events
      condition: AESER == 'Y'
      target: adae
      type: anl

### The functions

You can find an overview of all `autoslider.core` functions
[here](https://pharmaverse.github.io/autoslider.core/latest-tag/reference/index.html).
Note that all output-producing functions end with `_slide` while the
prefix (i.e. `t_`, `l_`, `g_`) specify the type of output (i.e. table,
listing, or graph respectively). Custom functions are needed if the
`autoslider.core` functions do not cover the outputs you need. More on
that further down.

### The backend machinery

A typical workflow could look something like this:

``` r

# define path to the yml files
spec_file <- "spec.yml"
filters <- "filters.yml"
```

``` r

library("dplyr")
# load all filters
filters::load_filters(filters, overwrite = TRUE)
# read data
data <- list(
  "adsl" = eg_adsl |>
    mutate(
      FASFL = SAFFL, # add FASFL for illustrative purpose for t_pop_slide
      # DISTRTFL is needed for t_ds_slide but is missing in example data
      DISTRTFL = sample(c("Y", "N"), size = length(TRT01A), replace = TRUE, prob = c(.1, .9))
    ) |>
    preprocess_t_ds(), # this preproccessing is required by one of the autoslider.core functions
  "adae" = eg_adae,
  "adtte" = eg_adtte,
  "adrs" = eg_adrs,
  "adlb" = eg_adlb
)



# create outputs based on the specs and the functions
outputs <- spec_file |>
  read_spec() |>
  # we can also filter for specific programs, if we don't want to create them all
  filter_spec(program %in% c(
    "t_ds_slide",
    "t_dm_slide"
  )) |>
  # these filtered specs are now piped into the generate_outputs function.
  # this function also requires the data
  generate_outputs(datasets = data) |>
  # now we decorate based on the specs, i.e. add footnotes and titles
  decorate_outputs(
    version_label = NULL
  )
# ✔ 2/3 outputs matched the filter condition `program %in% c("t_ds_slide", "t_dm_slide")`.
# ❯ Running program `t_ds_slide` with suffix 'ITT'.
# Filter 'ITT' matched target ADSL.
# 400/400 records matched the filter condition `ITTFL == 'Y'`.
# ❯ Running program `t_dm_slide` with suffix 'ITT'.
# Filter 'ITT' matched target ADSL.
# 400/400 records matched the filter condition `ITTFL == 'Y'`.
```

We can have a look at one of the outputs stored in the outputs file:

``` r

outputs$t_dm_slide_ITT
# An object of class "dVTableTree"
# Slot "tbl":
#  Patient Demographics and Baseline Characteristics, Intent to Treat Population
# 
# ———————————————————————————————————————————————————————————————————————————————————————————————————————
#                                                A: Drug X    B: Placebo    C: Combination   All Patients
# ———————————————————————————————————————————————————————————————————————————————————————————————————————
# Sex                                                                                                    
#   F                                            79 (59%)     82 (61.2%)       70 (53%)      231 (57.8%) 
#   M                                            55 (41%)     52 (38.8%)       62 (47%)      169 (42.2%) 
# Age                                                                                                    
#   Median                                         33.00         35.00          35.00           34.00    
#   Min - Max                                   21.0 - 50.0   21.0 - 62.0    20.0 - 69.0     20.0 - 69.0 
# Race                                                                                                   
#   ASIAN                                       68 (50.7%)     67 (50%)       73 (55.3%)      208 (52%)  
#   BLACK OR AFRICAN AMERICAN                   31 (23.1%)    28 (20.9%)      32 (24.2%)      91 (22.8%) 
#   WHITE                                       27 (20.1%)    26 (19.4%)      21 (15.9%)      74 (18.5%) 
#   AMERICAN INDIAN OR ALASKA NATIVE              8 (6%)       11 (8.2%)       6 (4.5%)       25 (6.2%)  
#   MULTIPLE                                         0         1 (0.7%)           0            1 (0.2%)  
#   NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER        0         1 (0.7%)           0            1 (0.2%)  
#   OTHER                                            0             0              0               0      
#   UNKNOWN                                          0             0              0               0      
# Ethnicity                                                                                              
#    NOT REPORTED                                6 (4.5%)      10 (7.5%)      11 (8.3%)       27 (6.8%)  
#   HISPANIC OR LATINO                          15 (11.2%)    18 (13.4%)      15 (11.4%)       48 (12%)  
#   NOT HISPANIC OR LATINO                      104 (77.6%)   103 (76.9%)    101 (76.5%)      308 (77%)  
#   UNKNOWN                                      9 (6.7%)      3 (2.2%)        5 (3.8%)       17 (4.2%)  
# Country                                                                                                
#   CHN                                         74 (55.2%)    81 (60.4%)      64 (48.5%)     219 (54.8%) 
#   USA                                          10 (7.5%)     13 (9.7%)      17 (12.9%)       40 (10%)  
#   BRA                                          13 (9.7%)     7 (5.2%)       10 (7.6%)       30 (7.5%)  
#   PAK                                           12 (9%)      9 (6.7%)       10 (7.6%)       31 (7.8%)  
#   NGA                                           8 (6%)       7 (5.2%)       11 (8.3%)       26 (6.5%)  
#   RUS                                          5 (3.7%)       8 (6%)         6 (4.5%)       19 (4.8%)  
#   JPN                                          5 (3.7%)       4 (3%)         9 (6.8%)       18 (4.5%)  
#   GBR                                           4 (3%)       3 (2.2%)        2 (1.5%)        9 (2.2%)  
#   CAN                                          3 (2.2%)      2 (1.5%)        3 (2.3%)         8 (2%)   
#   CHE                                              0             0              0               0      
# ———————————————————————————————————————————————————————————————————————————————————————————————————————
# 
# t_dm_slide footnote
# Confidential and for internal use only
# GitHub repository: NA
# Git hash: c2ea91d1f3393095c16393e4ce0f0a4f856d0057
# 
# Slot "titles":
#  Patient Demographics and Baseline Characteristics, Intent to Treat Population
# 
# Slot "footnotes":
# [1] "t_dm_slide footnote"                   
# [2] "Confidential and for internal use only"
# 
# Slot "usernotes":
# [1] ""
# 
# Slot "paper":
# [1] "L6"
# 
# Slot "width":
# [1] 41 11 11 14 12
```

Now we can save it to a slide. For this example I store the output in a
tempfile, you would likely store it in the `outputs/` folder.

``` r

# Output to slides with template and color theme
outputs |>
  generate_slides(
    outfile = tempfile(fileext = ".ppts"),
    template = file.path(system.file(package = "autoslider.core"), "/theme/basic.pptx"),
    table_format = autoslider_format
  )
```

## Writing custom functions

Unless your requirements are really specific, the most efficient way to
write a study function is to base it off of a template function from the
[TLG
catalogue](https://insightsengineering.github.io/tlg-catalog/stable/).

The function you would want to create should take as input a list of
datasets and potentially additional arguments. Within the function, you
should not worry about filtering the data, as this should be taken care
of with the `filters.yml` file and the general workflow. To work
properly with `autoslider.core` your function should return either:

- A `ggplot2` object for graphs
- An `rtables` object for tables
- An `rlistings` object for listings

That’s it!

Now let’s see how this works in practice.

### create example function

A function that works within the `autoslideR` workflow should also work
on its own. This makes it straightforward to develop and test.

As an example, lets create a function corresponding to a [TLG
catalogue](https://insightsengineering.github.io/tlg-catalog/stable/)
output.

We are going create a table based on [LBT06 Laboratory Abnormalities by
Visit and Baseline
Status](https://insightsengineering.github.io/tlg-catalog/stable/tables/lab-results/lbt06.html):

``` r

lbt06 <- function(datasets) {
  # Ensure character variables are converted to factors and empty strings and NAs are explicit missing levels.
  adsl <- datasets$adsl |> tern::df_explicit_na()
  adlb <- datasets$adlb |> tern::df_explicit_na()

  # Please note that df_explict_na has a na_level argument defaulting to "<Missing>",
  # Please don't change the na_level to anything other than NA, empty string or the default "<Missing>".

  adlb_f <- adlb |>
    dplyr::filter(ABLFL != "Y") |>
    dplyr::filter(!(AVISIT %in% c("SCREENING", "BASELINE"))) |>
    dplyr::mutate(AVISIT = droplevels(AVISIT)) |>
    formatters::var_relabel(AVISIT = "Visit")

  adlb_f_crp <- adlb_f |> dplyr::filter(PARAMCD == "CRP")

  # Define the split function
  split_fun <- rtables::drop_split_levels

  lyt <- rtables::basic_table(show_colcounts = TRUE) |>
    rtables::split_cols_by("ARM") |>
    rtables::split_rows_by("AVISIT",
      split_fun = split_fun, label_pos = "topleft",
      split_label = formatters::obj_label(adlb_f_crp$AVISIT)
    ) |>
    tern::count_abnormal_by_baseline(
      "ANRIND",
      abnormal = c(Low = "LOW", High = "HIGH"),
      .indent_mods = 4L
    ) |>
    tern::append_varlabels(adlb_f_crp, "ANRIND", indent = 1L) |>
    rtables::append_topleft("    Baseline Status")

  result <- rtables::build_table(
    lyt = lyt,
    df = adlb_f_crp,
    alt_counts_df = adsl
  ) |>
    rtables::trim_rows()

  result
}
```

Let’s see if this works:

``` r

lbt06(data)
# Visit                                                                                  
#   Analysis Reference Range Indicator     A: Drug X        B: Placebo     C: Combination
#     Baseline Status                       (N=134)          (N=134)          (N=132)    
# ———————————————————————————————————————————————————————————————————————————————————————
# WEEK 1 DAY 8                                                                           
#   Low                                                                                  
#             Not low                    16/119 (13.4%)   22/113 (19.5%)   24/112 (21.4%)
#             Low                         2/15 (13.3%)     2/21 (9.5%)       7/20 (35%)  
#             Total                      18/134 (13.4%)   24/134 (17.9%)   31/132 (23.5%)
#   High                                                                                 
#             Not high                   21/114 (18.4%)   20/112 (17.9%)   17/115 (14.8%)
#             High                         2/20 (10%)      4/22 (18.2%)     3/17 (17.6%) 
#             Total                      23/134 (17.2%)   24/134 (17.9%)   20/132 (15.2%)
# WEEK 2 DAY 15                                                                          
#   Low                                                                                  
#             Not low                    26/119 (21.8%)   20/113 (17.7%)   12/112 (10.7%)
#             Low                         2/15 (13.3%)     3/21 (14.3%)      4/20 (20%)  
#             Total                      28/134 (20.9%)   23/134 (17.2%)   16/132 (12.1%)
#   High                                                                                 
#             Not high                   15/114 (13.2%)   17/112 (15.2%)    15/115 (13%) 
#             High                         2/20 (10%)      4/22 (18.2%)     4/17 (23.5%) 
#             Total                      17/134 (12.7%)   21/134 (15.7%)   19/132 (14.4%)
# WEEK 3 DAY 22                                                                          
#   Low                                                                                  
#             Not low                    15/119 (12.6%)   21/113 (18.6%)   18/112 (16.1%)
#             Low                             0/15         3/21 (14.3%)         0/20     
#             Total                      15/134 (11.2%)   24/134 (17.9%)   18/132 (13.6%)
#   High                                                                                 
#             Not high                   22/114 (19.3%)   18/112 (16.1%)   17/115 (14.8%)
#             High                         2/20 (10%)      5/22 (22.7%)     1/17 (5.9%)  
#             Total                      24/134 (17.9%)   23/134 (17.2%)   18/132 (13.6%)
# WEEK 4 DAY 29                                                                          
#   Low                                                                                  
#             Not low                    30/119 (25.2%)   13/113 (11.5%)   16/112 (14.3%)
#             Low                          3/15 (20%)      2/21 (9.5%)       5/20 (25%)  
#             Total                      33/134 (24.6%)   15/134 (11.2%)   21/132 (15.9%)
#   High                                                                                 
#             Not high                   17/114 (14.9%)   11/112 (9.8%)    16/115 (13.9%)
#             High                         2/20 (10%)      6/22 (27.3%)     3/17 (17.6%) 
#             Total                      19/134 (14.2%)   17/134 (12.7%)   19/132 (14.4%)
# WEEK 5 DAY 36                                                                          
#   Low                                                                                  
#             Not low                    17/119 (14.3%)   19/113 (16.8%)   16/112 (14.3%)
#             Low                         2/15 (13.3%)     3/21 (14.3%)      5/20 (25%)  
#             Total                      19/134 (14.2%)   22/134 (16.4%)   21/132 (15.9%)
#   High                                                                                 
#             Not high                   19/114 (16.7%)   17/112 (15.2%)   11/115 (9.6%) 
#             High                         4/20 (20%)      6/22 (27.3%)     2/17 (11.8%) 
#             Total                      23/134 (17.2%)   23/134 (17.2%)   13/132 (9.8%)
```

This works!

To increase code-reusability and to have filtering control centralised
in the `filters.yml` file, I would recommend to remove most filtering
processes from the function, namely the following chunk:

``` r

adlb_f <- eg_adlb |>
  dplyr::filter(ABLFL != "Y") |>
  dplyr::filter(!(AVISIT %in% c("SCREENING", "BASELINE"))) |>
  dplyr::mutate(AVISIT = droplevels(AVISIT)) |>
  formatters::var_relabel(AVISIT = "Visit")

adlb_f_crp <- adlb_f |> dplyr::filter(PARAMCD == "CRP")
```

For this, I’ll add two separate filters into the `filters.yml` file; one
to filter the right parameter, and one to take care of the AVISIT and
ABLFL.

    LBCRP:
      title: CRP Values
      condition: PARAMCD == 'CRP'
      target: adlb
      type: slref
    LBNOBAS:
      title: Only Visits After Baseline
      condition: ABLFL != "Y" & !(AVISIT %in% c("SCREENING", "BASELINE"))
      target: adlb
      type: slref

And the corresponding specs entry:

    - program: lbt06
      titles: Patient Disposition ({filter_titles("adsl")})
      footnotes: 't_ds footnotes'
      paper: L6
      suffix: FAS_LBCRP_LBNOBAS

Now we can rewrite the function. But keep in mind: We are applying a
filter to the ADSL data set but create the output on ADLB. To forward
the filter to ADLB, we must semi-join the ADSL to ADLB.

``` r

lbt06 <- function(datasets) {
  # Ensure character variables are converted to factors and empty strings and NAs are explicit missing levels.
  adsl <- datasets$adsl |> tern::df_explicit_na()
  adlb <- datasets$adlb |> tern::df_explicit_na()


  # join adsl to adlb
  adlb <- adlb |> semi_join(adsl, by = "USUBJID")

  # Please note that df_explict_na has a na_level argument defaulting to "<Missing>",
  # Please don't change the na_level to anything other than NA, empty string or the default "<Missing>".

  adlb_f <- adlb |>
    dplyr::mutate(AVISIT = droplevels(AVISIT)) |>
    formatters::var_relabel(AVISIT = "Visit")

  # Define the split function
  split_fun <- rtables::drop_split_levels

  lyt <- rtables::basic_table(show_colcounts = TRUE) |>
    rtables::split_cols_by("ARM") |>
    rtables::split_rows_by("AVISIT",
      split_fun = split_fun, label_pos = "topleft",
      split_label = formatters::obj_label(adlb_f_crp$AVISIT)
    ) |>
    tern::count_abnormal_by_baseline(
      "ANRIND",
      abnormal = c(Low = "LOW", High = "HIGH"),
      .indent_mods = 4L
    ) |>
    tern::append_varlabels(adlb_f, "ANRIND", indent = 1L) |>
    rtables::append_topleft("    Baseline Status")

  result <- rtables::build_table(
    lyt = lyt,
    df = adlb_f,
    alt_counts_df = adsl
  ) |>
    rtables::trim_rows()

  result
}
```

lets do a dry-run before we integrate this function into the workflow:

``` r

# filter data | this step will be performed by the workflow later on

adsl <- eg_adsl
adlb <- eg_adlb

adlb_f <- adlb |>
  dplyr::filter(ABLFL != "Y") |>
  dplyr::filter(!(AVISIT %in% c("SCREENING", "BASELINE")))

adlb_f_crp <- adlb_f |> dplyr::filter(PARAMCD == "CRP")

adsl_f <- adsl |> filter(ITTFL == "Y")
```

``` r

lbt06(list(adsl = adsl_f, adlb = adlb_f_crp))
# Analysis Visit                                                                         
#   Analysis Reference Range Indicator     A: Drug X        B: Placebo     C: Combination
#     Baseline Status                       (N=134)          (N=134)          (N=132)    
# ———————————————————————————————————————————————————————————————————————————————————————
# WEEK 1 DAY 8                                                                           
#   Low                                                                                  
#             Not low                    16/119 (13.4%)   22/113 (19.5%)   24/112 (21.4%)
#             Low                         2/15 (13.3%)     2/21 (9.5%)       7/20 (35%)  
#             Total                      18/134 (13.4%)   24/134 (17.9%)   31/132 (23.5%)
#   High                                                                                 
#             Not high                   21/114 (18.4%)   20/112 (17.9%)   17/115 (14.8%)
#             High                         2/20 (10%)      4/22 (18.2%)     3/17 (17.6%) 
#             Total                      23/134 (17.2%)   24/134 (17.9%)   20/132 (15.2%)
# WEEK 2 DAY 15                                                                          
#   Low                                                                                  
#             Not low                    26/119 (21.8%)   20/113 (17.7%)   12/112 (10.7%)
#             Low                         2/15 (13.3%)     3/21 (14.3%)      4/20 (20%)  
#             Total                      28/134 (20.9%)   23/134 (17.2%)   16/132 (12.1%)
#   High                                                                                 
#             Not high                   15/114 (13.2%)   17/112 (15.2%)    15/115 (13%) 
#             High                         2/20 (10%)      4/22 (18.2%)     4/17 (23.5%) 
#             Total                      17/134 (12.7%)   21/134 (15.7%)   19/132 (14.4%)
# WEEK 3 DAY 22                                                                          
#   Low                                                                                  
#             Not low                    15/119 (12.6%)   21/113 (18.6%)   18/112 (16.1%)
#             Low                             0/15         3/21 (14.3%)         0/20     
#             Total                      15/134 (11.2%)   24/134 (17.9%)   18/132 (13.6%)
#   High                                                                                 
#             Not high                   22/114 (19.3%)   18/112 (16.1%)   17/115 (14.8%)
#             High                         2/20 (10%)      5/22 (22.7%)     1/17 (5.9%)  
#             Total                      24/134 (17.9%)   23/134 (17.2%)   18/132 (13.6%)
# WEEK 4 DAY 29                                                                          
#   Low                                                                                  
#             Not low                    30/119 (25.2%)   13/113 (11.5%)   16/112 (14.3%)
#             Low                          3/15 (20%)      2/21 (9.5%)       5/20 (25%)  
#             Total                      33/134 (24.6%)   15/134 (11.2%)   21/132 (15.9%)
#   High                                                                                 
#             Not high                   17/114 (14.9%)   11/112 (9.8%)    16/115 (13.9%)
#             High                         2/20 (10%)      6/22 (27.3%)     3/17 (17.6%) 
#             Total                      19/134 (14.2%)   17/134 (12.7%)   19/132 (14.4%)
# WEEK 5 DAY 36                                                                          
#   Low                                                                                  
#             Not low                    17/119 (14.3%)   19/113 (16.8%)   16/112 (14.3%)
#             Low                         2/15 (13.3%)     3/21 (14.3%)      5/20 (25%)  
#             Total                      19/134 (14.2%)   22/134 (16.4%)   21/132 (15.9%)
#   High                                                                                 
#             Not high                   19/114 (16.7%)   17/112 (15.2%)   11/115 (9.6%) 
#             High                         4/20 (20%)      6/22 (27.3%)     2/17 (11.8%) 
#             Total                      23/134 (17.2%)   23/134 (17.2%)   13/132 (9.8%)
```

Looks like it works!

### Integrate it into the general workflow

You have to keep in mind that the function you created must be in the
global environment when calling the `create_outputs` function. This is
the case for all `autoslider.core` functions, as you attach the
`autoslider.core` package (with your
[`library(autoslider.core)`](https://github.com/pharmaverse/autoslider.core)
call), so all (exported) function of the `autoslider.core` package are
available.

If you store your custom function in a separate script, you would need
to source that script at some point before calling the function, i.e.:

``` r

source("programs/R/output_functions.R")
```

Now you just have to make sure the two `.yml` files are correctly
specified.

Set the path to the `.yml` files.

``` r

filters <- "filters.yml"
spec_file <- "specs.yml"
```

Then load the filters and generate the outputs.

``` r

filters::load_filters(filters, overwrite = TRUE)

outputs <- spec_file |>
  read_spec() |>
  generate_outputs(data) |>
  decorate_outputs()
# ❯ Running program `t_ds_slide` with suffix 'ITT'.
# Filter 'ITT' matched target ADSL.
# 400/400 records matched the filter condition `ITTFL == 'Y'`.
# ❯ Running program `t_dm_slide` with suffix 'ITT'.
# Filter 'ITT' matched target ADSL.
# 400/400 records matched the filter condition `ITTFL == 'Y'`.
# ❯ Running program `lbt06` with suffix 'ITT_LBCRP_LBNOBAS'.
# Filter 'ITT' matched target ADSL.
# 400/400 records matched the filter condition `ITTFL == 'Y'`.
# Filters 'LBCRP', 'LBNOBAS' matched target ADLB.
# 2000/8400 records matched the filter condition `PARAMCD == 'CRP' & (ABLFL != 'Y' & !(AVISIT %in% c('SCREENING', 'BASELINE')))`.

outputs$lbt06_ITT_LBCRP_LBNOBAS
# An object of class "dVTableTree"
# Slot "tbl":
#  Patient Disposition (Intent to Treat Population)
# 
# ———————————————————————————————————————————————————————————————————————————————————————
# Analysis Visit                                                                         
#   Analysis Reference Range Indicator     A: Drug X        B: Placebo     C: Combination
#     Baseline Status                       (N=134)          (N=134)          (N=132)    
# ———————————————————————————————————————————————————————————————————————————————————————
# WEEK 1 DAY 8                                                                           
#   Low                                                                                  
#             Not low                    16/119 (13.4%)   22/113 (19.5%)   24/112 (21.4%)
#             Low                         2/15 (13.3%)     2/21 (9.5%)       7/20 (35%)  
#             Total                      18/134 (13.4%)   24/134 (17.9%)   31/132 (23.5%)
#   High                                                                                 
#             Not high                   21/114 (18.4%)   20/112 (17.9%)   17/115 (14.8%)
#             High                         2/20 (10%)      4/22 (18.2%)     3/17 (17.6%) 
#             Total                      23/134 (17.2%)   24/134 (17.9%)   20/132 (15.2%)
# WEEK 2 DAY 15                                                                          
#   Low                                                                                  
#             Not low                    26/119 (21.8%)   20/113 (17.7%)   12/112 (10.7%)
#             Low                         2/15 (13.3%)     3/21 (14.3%)      4/20 (20%)  
#             Total                      28/134 (20.9%)   23/134 (17.2%)   16/132 (12.1%)
#   High                                                                                 
#             Not high                   15/114 (13.2%)   17/112 (15.2%)    15/115 (13%) 
#             High                         2/20 (10%)      4/22 (18.2%)     4/17 (23.5%) 
#             Total                      17/134 (12.7%)   21/134 (15.7%)   19/132 (14.4%)
# WEEK 3 DAY 22                                                                          
#   Low                                                                                  
#             Not low                    15/119 (12.6%)   21/113 (18.6%)   18/112 (16.1%)
#             Low                             0/15         3/21 (14.3%)         0/20     
#             Total                      15/134 (11.2%)   24/134 (17.9%)   18/132 (13.6%)
#   High                                                                                 
#             Not high                   22/114 (19.3%)   18/112 (16.1%)   17/115 (14.8%)
#             High                         2/20 (10%)      5/22 (22.7%)     1/17 (5.9%)  
#             Total                      24/134 (17.9%)   23/134 (17.2%)   18/132 (13.6%)
# WEEK 4 DAY 29                                                                          
#   Low                                                                                  
#             Not low                    30/119 (25.2%)   13/113 (11.5%)   16/112 (14.3%)
#             Low                          3/15 (20%)      2/21 (9.5%)       5/20 (25%)  
#             Total                      33/134 (24.6%)   15/134 (11.2%)   21/132 (15.9%)
#   High                                                                                 
#             Not high                   17/114 (14.9%)   11/112 (9.8%)    16/115 (13.9%)
#             High                         2/20 (10%)      6/22 (27.3%)     3/17 (17.6%) 
#             Total                      19/134 (14.2%)   17/134 (12.7%)   19/132 (14.4%)
# WEEK 5 DAY 36                                                                          
#   Low                                                                                  
#             Not low                    17/119 (14.3%)   19/113 (16.8%)   16/112 (14.3%)
#             Low                         2/15 (13.3%)     3/21 (14.3%)      5/20 (25%)  
#             Total                      19/134 (14.2%)   22/134 (16.4%)   21/132 (15.9%)
#   High                                                                                 
#             Not high                   19/114 (16.7%)   17/112 (15.2%)   11/115 (9.6%) 
#             High                         4/20 (20%)      6/22 (27.3%)     2/17 (11.8%) 
#             Total                      23/134 (17.2%)   23/134 (17.2%)   13/132 (9.8%) 
# ———————————————————————————————————————————————————————————————————————————————————————
# 
# t_ds footnotes
# Confidential and for internal use only
# GitHub repository: NA
# Git hash: c2ea91d1f3393095c16393e4ce0f0a4f856d0057
# 
# Slot "titles":
#  Patient Disposition (Intent to Treat Population)
# 
# Slot "footnotes":
# [1] "t_ds footnotes"                        
# [2] "Confidential and for internal use only"
# 
# Slot "usernotes":
# [1] ""
# 
# Slot "paper":
# [1] "L6"
# 
# Slot "width":
# [1] 36 14 14 14
```

Once this works, we can finally generate the slides.

``` r

filepath <- tempfile(fileext = ".pptx")
generate_slides(outputs, outfile = filepath)
# [1] " Patient Disposition (Intent to Treat Population)"
# [1] " Patient Disposition (Intent to Treat Population) (cont.)"
# [1] " Patient Demographics and Baseline Characteristics, Intent to Treat Population"
# [1] " Patient Demographics and Baseline Characteristics, Intent to Treat Population (cont.)"
# [1] " Patient Demographics and Baseline Characteristics, Intent to Treat Population (cont.)"
# [1] " Patient Demographics and Baseline Characteristics, Intent to Treat Population (cont.)"
# [1] " Patient Disposition (Intent to Treat Population)"
# [1] " Patient Disposition (Intent to Treat Population) (cont.)"
# [1] " Patient Disposition (Intent to Treat Population) (cont.)"
# [1] " Patient Disposition (Intent to Treat Population) (cont.)"
# [1] " Patient Disposition (Intent to Treat Population) (cont.)"
# [1] " Patient Disposition (Intent to Treat Population) (cont.)"
# [1] " Patient Disposition (Intent to Treat Population) (cont.)"
# [1] " Patient Disposition (Intent to Treat Population) (cont.)"
# [1] " Patient Disposition (Intent to Treat Population) (cont.)"
# [1] " Patient Disposition (Intent to Treat Population) (cont.)"
```

Of course, you would not use a temporary file, and you might want to use
a custom `.pptx` template for your slides.
