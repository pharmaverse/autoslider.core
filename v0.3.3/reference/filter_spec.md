# Filter a spec object

Filter a spec object

## Usage

``` r
filter_spec(spec, filter_expr, verbose = TRUE)
```

## Arguments

- spec:

  A \`spec\` object as returned by \`read_spec()\`

- filter_expr:

  A \`logical\` expression indicating outputs to keep

- verbose:

  Should a message about the number of outputs matching \`filter_spec\`
  be printed? Defaults to \`TRUE\`.

## Value

A \`spec\` object containing only the outputs matching \`filter_expr\`

## Author

Thomas Neitmann (\`neitmant\`)

## Examples

``` r
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
spec_file <- system.file("spec.yml", package = "autoslider.core")
spec <- spec_file %>% read_spec()

## Keep only the t_dm_IT output
filter_spec(spec, output == "t_dm_IT")
#> ✖ No output matched the filter condition `output == "t_dm_IT"`
#> named list()
#> attr(,"class")
#> [1] "spec" "list"

## Same as above but more verbose
filter_spec(spec, program == "t_dm" && suffix == "IT")
#> ✖ No output matched the filter condition `program == "t_dm" && suffix == "IT"`
#> named list()
#> attr(,"class")
#> [1] "spec" "list"

## Keep all t_ae outputs
filter_spec(spec, program == "t_ae")
#> ✖ No output matched the filter condition `program == "t_ae"`
#> named list()
#> attr(,"class")
#> [1] "spec" "list"

## Keep all output run on safety population
filter_spec(spec, "SE" %in% suffix)
#> ✔ 10/51 outputs matched the filter condition `"SE" %in% suffix`.
#> $l_dsl01_slide_SE
#> $l_dsl01_slide_SE$program
#> [1] "l_dsl01_slide"
#> 
#> $l_dsl01_slide_SE$titles
#> [1] "Analysis Sets ({filter_titles(\"adsl\")})"
#> 
#> $l_dsl01_slide_SE$footnotes
#> [1] "Analysis Sets footer"
#> 
#> $l_dsl01_slide_SE$paper
#> [1] "L6"
#> 
#> $l_dsl01_slide_SE$suffix
#> [1] "SE"
#> 
#> $l_dsl01_slide_SE$output
#> [1] "l_dsl01_slide_SE"
#> 
#> 
#> $t_ds_trt_slide_SE
#> $t_ds_trt_slide_SE$program
#> [1] "t_ds_trt_slide"
#> 
#> $t_ds_trt_slide_SE$titles
#> [1] "Patients Who Discontinued From Study Treatment"
#> 
#> $t_ds_trt_slide_SE$footnotes
#> [1] "ds trt footnotes"
#> 
#> $t_ds_trt_slide_SE$paper
#> [1] "L6"
#> 
#> $t_ds_trt_slide_SE$suffix
#> [1] "SE"
#> 
#> $t_ds_trt_slide_SE$args
#> $t_ds_trt_slide_SE$args$arm
#> [1] "TRT01A"
#> 
#> $t_ds_trt_slide_SE$args$colcount
#> [1] FALSE
#> 
#> $t_ds_trt_slide_SE$args$drug_vars
#> [1] "A: Drug X"      "B: Placebo"     "C: Combination"
#> 
#> $t_ds_trt_slide_SE$args$drug_names
#> [1] "Drug X"      "Placebo"     "Combination"
#> 
#> $t_ds_trt_slide_SE$args$drug_sdt
#> [1] "TRTSDT" "TRTSDT" "TRTSDT"
#> 
#> $t_ds_trt_slide_SE$args$drug_discfl
#> [1] "DTRFL" "DTRFL" "DTRFL"
#> 
#> $t_ds_trt_slide_SE$args$drug_discst
#> [1] "EOTSTT" "EOTSTT" "EOTSTT"
#> 
#> $t_ds_trt_slide_SE$args$drug_discrs
#> [1] "DCSREAS" "DCSREAS" "DCSREAS"
#> 
#> 
#> $t_ds_trt_slide_SE$output
#> [1] "t_ds_trt_slide_SE"
#> 
#> 
#> $t_ex_slide_SE
#> $t_ex_slide_SE$program
#> [1] "t_ex_slide"
#> 
#> $t_ex_slide_SE$titles
#> [1] "Study Drug Exposure"
#> 
#> $t_ex_slide_SE$footnotes
#> [1] ""
#> 
#> $t_ex_slide_SE$paper
#> [1] "L6"
#> 
#> $t_ex_slide_SE$suffix
#> [1] "SE"
#> 
#> $t_ex_slide_SE$args
#> $t_ex_slide_SE$args$arm
#> [1] "TRT01A"
#> 
#> $t_ex_slide_SE$args$drug_terms
#> [1] "Drug A" "Drug B"
#> 
#> $t_ex_slide_SE$args$drug_labels
#> [1] "Drug A" "Drug B"
#> 
#> $t_ex_slide_SE$args$total_duration
#> [1] "TDURD"
#> 
#> $t_ex_slide_SE$args$total_duration_breaks
#> [1] 3 6
#> 
#> $t_ex_slide_SE$args$dose_intensity
#> [1] "TDOSINT"
#> 
#> $t_ex_slide_SE$args$number_dose_received
#> [1] "TNDOSE"
#> 
#> $t_ex_slide_SE$args$colcount
#> [1] FALSE
#> 
#> $t_ex_slide_SE$args$stats
#> [1] "median"         "range"          "count_fraction"
#> 
#> 
#> $t_ex_slide_SE$output
#> [1] "t_ex_slide_SE"
#> 
#> 
#> $t_ae_summ_slide_SE
#> $t_ae_summ_slide_SE$program
#> [1] "t_ae_summ_slide"
#> 
#> $t_ae_summ_slide_SE$titles
#> [1] "Overall Summary of Adverse Events"
#> 
#> $t_ae_summ_slide_SE$footnotes
#> [1] ""
#> 
#> $t_ae_summ_slide_SE$paper
#> [1] "L6"
#> 
#> $t_ae_summ_slide_SE$suffix
#> [1] "SE"
#> 
#> $t_ae_summ_slide_SE$args
#> $t_ae_summ_slide_SE$args$arm
#> [1] "TRT01A"
#> 
#> $t_ae_summ_slide_SE$args$dose_adjust_flags
#> [1] "dis_flags" "dis_flags" "dis_flags"
#> 
#> $t_ae_summ_slide_SE$args$dose_adjust_labels
#> [1] "DRUG WITHDRAWN"   "DOSE REDUCED"     "DRUG INTERRUPTED"
#> 
#> $t_ae_summ_slide_SE$args$gr34_highest_grade_only
#> [1] TRUE
#> 
#> 
#> $t_ae_summ_slide_SE$output
#> [1] "t_ae_summ_slide_SE"
#> 
#> 
#> $t_dd_slide_SE
#> $t_dd_slide_SE$program
#> [1] "t_dd_slide"
#> 
#> $t_dd_slide_SE$titles
#> [1] "Deaths and Causes of Death"
#> 
#> $t_dd_slide_SE$footnotes
#> [1] ""
#> 
#> $t_dd_slide_SE$paper
#> [1] "L6"
#> 
#> $t_dd_slide_SE$suffix
#> [1] "SE"
#> 
#> $t_dd_slide_SE$args
#> $t_dd_slide_SE$args$arm
#> [1] "TRT01A"
#> 
#> 
#> $t_dd_slide_SE$output
#> [1] "t_dd_slide_SE"
#> 
#> 
#> $t_ae_si_slide_SE
#> $t_ae_si_slide_SE$program
#> [1] "t_ae_si_slide"
#> 
#> $t_ae_si_slide_SE$titles
#> [1] "Immune-mediated Adverse Events"
#> 
#> $t_ae_si_slide_SE$footnotes
#> [1] ""
#> 
#> $t_ae_si_slide_SE$paper
#> [1] "L6"
#> 
#> $t_ae_si_slide_SE$suffix
#> [1] "SE"
#> 
#> $t_ae_si_slide_SE$args
#> $t_ae_si_slide_SE$args$arm
#> [1] "TRT01A"
#> 
#> 
#> $t_ae_si_slide_SE$output
#> [1] "t_ae_si_slide_SE"
#> 
#> 
#> $t_lb_slide_SE
#> $t_lb_slide_SE$program
#> [1] "t_lb_slide"
#> 
#> $t_lb_slide_SE$titles
#> [1] "Laboratory Test Results and Change from Baseline by Visit"
#> 
#> $t_lb_slide_SE$footnotes
#> [1] ""
#> 
#> $t_lb_slide_SE$paper
#> [1] "L6"
#> 
#> $t_lb_slide_SE$suffix
#> [1] "SE"
#> 
#> $t_lb_slide_SE$args
#> $t_lb_slide_SE$args$arm
#> [1] "TRT01A"
#> 
#> 
#> $t_lb_slide_SE$output
#> [1] "t_lb_slide_SE"
#> 
#> 
#> $t_eg_abn_slide_SE
#> $t_eg_abn_slide_SE$program
#> [1] "t_eg_abn_slide"
#> 
#> $t_eg_abn_slide_SE$titles
#> [1] "ECG Abnormalities"
#> 
#> $t_eg_abn_slide_SE$footnotes
#> [1] ""
#> 
#> $t_eg_abn_slide_SE$paper
#> [1] "L6"
#> 
#> $t_eg_abn_slide_SE$suffix
#> [1] "SE"
#> 
#> $t_eg_abn_slide_SE$args
#> $t_eg_abn_slide_SE$args$arm
#> [1] "TRT01A"
#> 
#> 
#> $t_eg_abn_slide_SE$output
#> [1] "t_eg_abn_slide_SE"
#> 
#> 
#> $l_ae_slide_SE
#> $l_ae_slide_SE$program
#> [1] "l_ae_slide"
#> 
#> $l_ae_slide_SE$titles
#> [1] "Listing of Adverse Events"
#> 
#> $l_ae_slide_SE$footnotes
#> [1] "(1) Outcome: 1 = fatal; 2 = not recovered/not resolved; 3 = recovered/resolved; 4 = recovered/resolved with sequelae; 5 = recovering/resolving; 6 = unknown. /n (2) Action taken with study drug: 1 = dose increased; 2 = dose not changed; 3 = dose reduced; 4 = drug interrupted; 5 = drug /n withdrawn; 6 = not applicable; 7 = unknown. /n *  Study day derived from imputed onset date. /n ** Duration derived from imputed onset date and/or end date."
#> 
#> $l_ae_slide_SE$paper
#> [1] "L6"
#> 
#> $l_ae_slide_SE$suffix
#> [1] "SE"
#> 
#> $l_ae_slide_SE$output
#> [1] "l_ae_slide_SE"
#> 
#> 
#> $t_aesi_slide_SE
#> $t_aesi_slide_SE$program
#> [1] "t_aesi_slide"
#> 
#> $t_aesi_slide_SE$titles
#> [1] "AESIs"
#> 
#> $t_aesi_slide_SE$footnotes
#> [1] ""
#> 
#> $t_aesi_slide_SE$paper
#> [1] "L6"
#> 
#> $t_aesi_slide_SE$suffix
#> [1] "SE"
#> 
#> $t_aesi_slide_SE$args
#> $t_aesi_slide_SE$args$arm
#> [1] "TRT01A"
#> 
#> 
#> $t_aesi_slide_SE$output
#> [1] "t_aesi_slide_SE"
#> 
#> 
#> attr(,"class")
#> [1] "spec" "list"

## Keep t_dm_CHN_IT and t_dm_CHN_SE
filter_spec(spec, program == "t_dm" && suffix %in% c("CHN_IT", "CHN_SE"))
#> ✖ No output matched the filter condition `program == "t_dm" && suffix %in% c("CHN_IT", "CHN_SE")`
#> named list()
#> attr(,"class")
#> [1] "spec" "list"

## Keep all tables
filter_spec(spec, grepl("^t_", program))
#> ✔ 34/51 outputs matched the filter condition `grepl("^t_", program)`.
#> $t_pop_slide_FAS
#> $t_pop_slide_FAS$program
#> [1] "t_pop_slide"
#> 
#> $t_pop_slide_FAS$titles
#> [1] "Analysis Sets ({filter_titles(\"adsl\")})"
#> 
#> $t_pop_slide_FAS$footnotes
#> [1] "Analysis Sets footer"
#> 
#> $t_pop_slide_FAS$paper
#> [1] "L6"
#> 
#> $t_pop_slide_FAS$suffix
#> [1] "FAS"
#> 
#> $t_pop_slide_FAS$output
#> [1] "t_pop_slide_FAS"
#> 
#> 
#> $t_ds_slide_FAS
#> $t_ds_slide_FAS$program
#> [1] "t_ds_slide"
#> 
#> $t_ds_slide_FAS$titles
#> [1] "Patient Disposition"
#> 
#> $t_ds_slide_FAS$footnotes
#> [1] "t_ds footnotes"
#> 
#> $t_ds_slide_FAS$paper
#> [1] "L6"
#> 
#> $t_ds_slide_FAS$suffix
#> [1] "FAS"
#> 
#> $t_ds_slide_FAS$output
#> [1] "t_ds_slide_FAS"
#> 
#> 
#> $t_ds_trt_slide_SE
#> $t_ds_trt_slide_SE$program
#> [1] "t_ds_trt_slide"
#> 
#> $t_ds_trt_slide_SE$titles
#> [1] "Patients Who Discontinued From Study Treatment"
#> 
#> $t_ds_trt_slide_SE$footnotes
#> [1] "ds trt footnotes"
#> 
#> $t_ds_trt_slide_SE$paper
#> [1] "L6"
#> 
#> $t_ds_trt_slide_SE$suffix
#> [1] "SE"
#> 
#> $t_ds_trt_slide_SE$args
#> $t_ds_trt_slide_SE$args$arm
#> [1] "TRT01A"
#> 
#> $t_ds_trt_slide_SE$args$colcount
#> [1] FALSE
#> 
#> $t_ds_trt_slide_SE$args$drug_vars
#> [1] "A: Drug X"      "B: Placebo"     "C: Combination"
#> 
#> $t_ds_trt_slide_SE$args$drug_names
#> [1] "Drug X"      "Placebo"     "Combination"
#> 
#> $t_ds_trt_slide_SE$args$drug_sdt
#> [1] "TRTSDT" "TRTSDT" "TRTSDT"
#> 
#> $t_ds_trt_slide_SE$args$drug_discfl
#> [1] "DTRFL" "DTRFL" "DTRFL"
#> 
#> $t_ds_trt_slide_SE$args$drug_discst
#> [1] "EOTSTT" "EOTSTT" "EOTSTT"
#> 
#> $t_ds_trt_slide_SE$args$drug_discrs
#> [1] "DCSREAS" "DCSREAS" "DCSREAS"
#> 
#> 
#> $t_ds_trt_slide_SE$output
#> [1] "t_ds_trt_slide_SE"
#> 
#> 
#> $t_dm_slide_FAS
#> $t_dm_slide_FAS$program
#> [1] "t_dm_slide"
#> 
#> $t_dm_slide_FAS$titles
#> [1] "Patient Demographics and Baseline Characteristics"
#> 
#> $t_dm_slide_FAS$footnotes
#> [1] "t_dm_slide footnote"
#> 
#> $t_dm_slide_FAS$paper
#> [1] "L6"
#> 
#> $t_dm_slide_FAS$suffix
#> [1] "FAS"
#> 
#> $t_dm_slide_FAS$args
#> $t_dm_slide_FAS$args$arm
#> [1] "TRT01A"
#> 
#> $t_dm_slide_FAS$args$vars
#> [1] "SEX"    "AGE"    "RACE"   "ETHNIC"
#> 
#> 
#> $t_dm_slide_FAS$output
#> [1] "t_dm_slide_FAS"
#> 
#> 
#> $t_dm_slide_FAS
#> $t_dm_slide_FAS$program
#> [1] "t_dm_slide"
#> 
#> $t_dm_slide_FAS$titles
#> [1] "Patient Demographics and Baseline Characteristics"
#> 
#> $t_dm_slide_FAS$footnotes
#> [1] "t_dm_slide footnote"
#> 
#> $t_dm_slide_FAS$paper
#> [1] "L6"
#> 
#> $t_dm_slide_FAS$suffix
#> [1] "FAS"
#> 
#> $t_dm_slide_FAS$args
#> $t_dm_slide_FAS$args$arm
#> [1] "TRT01A"
#> 
#> $t_dm_slide_FAS$args$vars
#> [1] "SEX"    "AGE"    "RACE"   "ETHNIC"
#> 
#> $t_dm_slide_FAS$args$side_by_side
#> [1] TRUE
#> 
#> 
#> $t_dm_slide_FAS$output
#> [1] "t_dm_slide_FAS"
#> 
#> 
#> $t_dm_tx_FAS
#> $t_dm_tx_FAS$program
#> [1] "t_dm_tx"
#> 
#> $t_dm_tx_FAS$titles
#> [1] "Baseline Disease Characteristics"
#> 
#> $t_dm_tx_FAS$footnotes
#> [1] ""
#> 
#> $t_dm_tx_FAS$paper
#> [1] "L6"
#> 
#> $t_dm_tx_FAS$suffix
#> [1] "FAS"
#> 
#> $t_dm_tx_FAS$output
#> [1] "t_dm_tx_FAS"
#> 
#> 
#> $t_tte_slide_PFSINV_FAS
#> $t_tte_slide_PFSINV_FAS$program
#> [1] "t_tte_slide"
#> 
#> $t_tte_slide_PFSINV_FAS$titles
#> [1] "Time to Event Summary for {filter_titles(\"adsl\", \"adtte\")}"
#> 
#> $t_tte_slide_PFSINV_FAS$footnotes
#> [1] ""
#> 
#> $t_tte_slide_PFSINV_FAS$paper
#> [1] "L6"
#> 
#> $t_tte_slide_PFSINV_FAS$suffix
#> [1] "PFSINV_FAS"
#> 
#> $t_tte_slide_PFSINV_FAS$args
#> $t_tte_slide_PFSINV_FAS$args$arm
#> [1] "TRT01P"
#> 
#> $t_tte_slide_PFSINV_FAS$args$refgroup
#> [1] "B: Placebo"
#> 
#> 
#> $t_tte_slide_PFSINV_FAS$output
#> [1] "t_tte_slide_PFSINV_FAS"
#> 
#> 
#> $t_tte_slide_PFSINV_FAS
#> $t_tte_slide_PFSINV_FAS$program
#> [1] "t_tte_slide"
#> 
#> $t_tte_slide_PFSINV_FAS$titles
#> [1] "Time to Event Summary for {filter_titles(\"adsl\", \"adtte\")}"
#> 
#> $t_tte_slide_PFSINV_FAS$footnotes
#> [1] ""
#> 
#> $t_tte_slide_PFSINV_FAS$paper
#> [1] "L6"
#> 
#> $t_tte_slide_PFSINV_FAS$suffix
#> [1] "PFSINV_FAS"
#> 
#> $t_tte_slide_PFSINV_FAS$args
#> $t_tte_slide_PFSINV_FAS$args$arm
#> [1] "TRT01P"
#> 
#> $t_tte_slide_PFSINV_FAS$args$refgroup
#> [1] "B: Placebo"
#> 
#> $t_tte_slide_PFSINV_FAS$args$strata
#> [1] "STRATA1" "STRATA2"
#> 
#> 
#> $t_tte_slide_PFSINV_FAS$output
#> [1] "t_tte_slide_PFSINV_FAS"
#> 
#> 
#> $t_tte_slide_OS_FAS
#> $t_tte_slide_OS_FAS$program
#> [1] "t_tte_slide"
#> 
#> $t_tte_slide_OS_FAS$titles
#> [1] "Time to Event Summary for {filter_titles(\"adsl\", \"adtte\")}"
#> 
#> $t_tte_slide_OS_FAS$footnotes
#> [1] ""
#> 
#> $t_tte_slide_OS_FAS$paper
#> [1] "L6"
#> 
#> $t_tte_slide_OS_FAS$suffix
#> [1] "OS_FAS"
#> 
#> $t_tte_slide_OS_FAS$args
#> $t_tte_slide_OS_FAS$args$arm
#> [1] "TRT01P"
#> 
#> $t_tte_slide_OS_FAS$args$refgroup
#> [1] "B: Placebo"
#> 
#> 
#> $t_tte_slide_OS_FAS$output
#> [1] "t_tte_slide_OS_FAS"
#> 
#> 
#> $t_orr_slide_INVET
#> $t_orr_slide_INVET$program
#> [1] "t_orr_slide"
#> 
#> $t_orr_slide_INVET$titles
#> [1] "{filter_titles(\"adsl\", \"adtte\")}"
#> 
#> $t_orr_slide_INVET$paper
#> [1] "L6"
#> 
#> $t_orr_slide_INVET$suffix
#> [1] "INVET"
#> 
#> $t_orr_slide_INVET$args
#> $t_orr_slide_INVET$args$arm
#> [1] "TRT01A"
#> 
#> $t_orr_slide_INVET$args$method
#> [1] "clopper-pearson"
#> 
#> 
#> $t_orr_slide_INVET$footnotes
#> [1] "t_orr_slide footnotes"
#> 
#> $t_orr_slide_INVET$output
#> [1] "t_orr_slide_INVET"
#> 
#> 
#> $t_orr_slide_INVET
#> $t_orr_slide_INVET$program
#> [1] "t_orr_slide"
#> 
#> $t_orr_slide_INVET$titles
#> [1] "{filter_titles(\"adsl\", \"adtte\")}"
#> 
#> $t_orr_slide_INVET$footnotes
#> [1] "t_orr_slide footnotes"
#> 
#> $t_orr_slide_INVET$paper
#> [1] "L6"
#> 
#> $t_orr_slide_INVET$suffix
#> [1] "INVET"
#> 
#> $t_orr_slide_INVET$args
#> $t_orr_slide_INVET$args$arm
#> [1] "TRT01A"
#> 
#> $t_orr_slide_INVET$args$refgroup
#> [1] "A: Drug X"
#> 
#> 
#> $t_orr_slide_INVET$output
#> [1] "t_orr_slide_INVET"
#> 
#> 
#> $t_orr_dor_slide_INVET_PFSINV
#> $t_orr_dor_slide_INVET_PFSINV$program
#> [1] "t_orr_dor_slide"
#> 
#> $t_orr_dor_slide_INVET_PFSINV$titles
#> [1] "{filter_titles(\"adsl\", \"adtte\")}"
#> 
#> $t_orr_dor_slide_INVET_PFSINV$footnotes
#> [1] ""
#> 
#> $t_orr_dor_slide_INVET_PFSINV$paper
#> [1] "L6"
#> 
#> $t_orr_dor_slide_INVET_PFSINV$suffix
#> [1] "INVET_PFSINV"
#> 
#> $t_orr_dor_slide_INVET_PFSINV$args
#> $t_orr_dor_slide_INVET_PFSINV$args$arm
#> [1] "TRT01A"
#> 
#> 
#> $t_orr_dor_slide_INVET_PFSINV$output
#> [1] "t_orr_dor_slide_INVET_PFSINV"
#> 
#> 
#> $t_orr_dor_slide_PFSINV_INVET_SE
#> $t_orr_dor_slide_PFSINV_INVET_SE$program
#> [1] "t_orr_dor_slide"
#> 
#> $t_orr_dor_slide_PFSINV_INVET_SE$titles
#> [1] "{filter_titles(\"adsl\", \"adtte\")}"
#> 
#> $t_orr_dor_slide_PFSINV_INVET_SE$footnotes
#> [1] ""
#> 
#> $t_orr_dor_slide_PFSINV_INVET_SE$paper
#> [1] "L6"
#> 
#> $t_orr_dor_slide_PFSINV_INVET_SE$suffix
#> [1] "PFSINV_INVET_SE"
#> 
#> $t_orr_dor_slide_PFSINV_INVET_SE$args
#> $t_orr_dor_slide_PFSINV_INVET_SE$args$arm
#> [1] "TRT01A"
#> 
#> $t_orr_dor_slide_PFSINV_INVET_SE$args$refgroup
#> [1] "A: Drug X"
#> 
#> 
#> $t_orr_dor_slide_PFSINV_INVET_SE$output
#> [1] "t_orr_dor_slide_PFSINV_INVET_SE"
#> 
#> 
#> $t_dor_slide_PFSINV_SE
#> $t_dor_slide_PFSINV_SE$program
#> [1] "t_dor_slide"
#> 
#> $t_dor_slide_PFSINV_SE$titles
#> [1] "{filter_titles(\"adsl\", \"adtte\")}"
#> 
#> $t_dor_slide_PFSINV_SE$footnotes
#> [1] ""
#> 
#> $t_dor_slide_PFSINV_SE$paper
#> [1] "L6"
#> 
#> $t_dor_slide_PFSINV_SE$suffix
#> [1] "PFSINV_SE"
#> 
#> $t_dor_slide_PFSINV_SE$args
#> $t_dor_slide_PFSINV_SE$args$arm
#> [1] "TRT01A"
#> 
#> $t_dor_slide_PFSINV_SE$args$refgroup
#> [1] "A: Drug X"
#> 
#> 
#> $t_dor_slide_PFSINV_SE$output
#> [1] "t_dor_slide_PFSINV_SE"
#> 
#> 
#> $t_ex_slide_SE
#> $t_ex_slide_SE$program
#> [1] "t_ex_slide"
#> 
#> $t_ex_slide_SE$titles
#> [1] "Study Drug Exposure"
#> 
#> $t_ex_slide_SE$footnotes
#> [1] ""
#> 
#> $t_ex_slide_SE$paper
#> [1] "L6"
#> 
#> $t_ex_slide_SE$suffix
#> [1] "SE"
#> 
#> $t_ex_slide_SE$args
#> $t_ex_slide_SE$args$arm
#> [1] "TRT01A"
#> 
#> $t_ex_slide_SE$args$drug_terms
#> [1] "Drug A" "Drug B"
#> 
#> $t_ex_slide_SE$args$drug_labels
#> [1] "Drug A" "Drug B"
#> 
#> $t_ex_slide_SE$args$total_duration
#> [1] "TDURD"
#> 
#> $t_ex_slide_SE$args$total_duration_breaks
#> [1] 3 6
#> 
#> $t_ex_slide_SE$args$dose_intensity
#> [1] "TDOSINT"
#> 
#> $t_ex_slide_SE$args$number_dose_received
#> [1] "TNDOSE"
#> 
#> $t_ex_slide_SE$args$colcount
#> [1] FALSE
#> 
#> $t_ex_slide_SE$args$stats
#> [1] "median"         "range"          "count_fraction"
#> 
#> 
#> $t_ex_slide_SE$output
#> [1] "t_ex_slide_SE"
#> 
#> 
#> $t_ae_summ_slide_SE
#> $t_ae_summ_slide_SE$program
#> [1] "t_ae_summ_slide"
#> 
#> $t_ae_summ_slide_SE$titles
#> [1] "Overall Summary of Adverse Events"
#> 
#> $t_ae_summ_slide_SE$footnotes
#> [1] ""
#> 
#> $t_ae_summ_slide_SE$paper
#> [1] "L6"
#> 
#> $t_ae_summ_slide_SE$suffix
#> [1] "SE"
#> 
#> $t_ae_summ_slide_SE$args
#> $t_ae_summ_slide_SE$args$arm
#> [1] "TRT01A"
#> 
#> $t_ae_summ_slide_SE$args$dose_adjust_flags
#> [1] "dis_flags" "dis_flags" "dis_flags"
#> 
#> $t_ae_summ_slide_SE$args$dose_adjust_labels
#> [1] "DRUG WITHDRAWN"   "DOSE REDUCED"     "DRUG INTERRUPTED"
#> 
#> $t_ae_summ_slide_SE$args$gr34_highest_grade_only
#> [1] TRUE
#> 
#> 
#> $t_ae_summ_slide_SE$output
#> [1] "t_ae_summ_slide_SE"
#> 
#> 
#> $t_ae_pt_slide_X10PER_SE
#> $t_ae_pt_slide_X10PER_SE$program
#> [1] "t_ae_pt_slide"
#> 
#> $t_ae_pt_slide_X10PER_SE$titles
#> [1] "Most Common AEs (Incidence Rate of at Least 10%)"
#> 
#> $t_ae_pt_slide_X10PER_SE$footnotes
#> [1] ""
#> 
#> $t_ae_pt_slide_X10PER_SE$paper
#> [1] "L6"
#> 
#> $t_ae_pt_slide_X10PER_SE$suffix
#> [1] "X10PER_SE"
#> 
#> $t_ae_pt_slide_X10PER_SE$args
#> $t_ae_pt_slide_X10PER_SE$args$arm
#> [1] "TRT01A"
#> 
#> $t_ae_pt_slide_X10PER_SE$args$cutoff
#> [1] 10
#> 
#> 
#> $t_ae_pt_slide_X10PER_SE$output
#> [1] "t_ae_pt_slide_X10PER_SE"
#> 
#> 
#> $t_ae_pt_slide_G34_X2PER_SE
#> $t_ae_pt_slide_G34_X2PER_SE$program
#> [1] "t_ae_pt_slide"
#> 
#> $t_ae_pt_slide_G34_X2PER_SE$titles
#> [1] "Most Common Grade 3-4 AEs (Incidence Rate of at Least 2%)"
#> 
#> $t_ae_pt_slide_G34_X2PER_SE$footnotes
#> [1] "t_ae_pt_slide footnote"
#> 
#> $t_ae_pt_slide_G34_X2PER_SE$paper
#> [1] "L6"
#> 
#> $t_ae_pt_slide_G34_X2PER_SE$suffix
#> [1] "G34_X2PER_SE"
#> 
#> $t_ae_pt_slide_G34_X2PER_SE$args
#> $t_ae_pt_slide_G34_X2PER_SE$args$arm
#> [1] "TRT01A"
#> 
#> $t_ae_pt_slide_G34_X2PER_SE$args$cutoff
#> [1] 2
#> 
#> 
#> $t_ae_pt_slide_G34_X2PER_SE$output
#> [1] "t_ae_pt_slide_G34_X2PER_SE"
#> 
#> 
#> $t_ae_pt_soc_slide_X10PER_SE
#> $t_ae_pt_soc_slide_X10PER_SE$program
#> [1] "t_ae_pt_soc_slide"
#> 
#> $t_ae_pt_soc_slide_X10PER_SE$titles
#> [1] "Most Common AEs (Incidence Rate of at Least 10%)"
#> 
#> $t_ae_pt_soc_slide_X10PER_SE$footnotes
#> [1] "t_ae_pt_soc_slide footnote"
#> 
#> $t_ae_pt_soc_slide_X10PER_SE$paper
#> [1] "L6"
#> 
#> $t_ae_pt_soc_slide_X10PER_SE$suffix
#> [1] "X10PER_SE"
#> 
#> $t_ae_pt_soc_slide_X10PER_SE$args
#> $t_ae_pt_soc_slide_X10PER_SE$args$arm
#> [1] "TRT01A"
#> 
#> $t_ae_pt_soc_slide_X10PER_SE$args$cutoff
#> [1] 10
#> 
#> 
#> $t_ae_pt_soc_slide_X10PER_SE$output
#> [1] "t_ae_pt_soc_slide_X10PER_SE"
#> 
#> 
#> $t_ae_pt_soc_slide_G34_X2PER_SE
#> $t_ae_pt_soc_slide_G34_X2PER_SE$program
#> [1] "t_ae_pt_soc_slide"
#> 
#> $t_ae_pt_soc_slide_G34_X2PER_SE$titles
#> [1] "Most Common Grade 3-4 AEs (Incidence Rate of at Least 2%)"
#> 
#> $t_ae_pt_soc_slide_G34_X2PER_SE$footnotes
#> [1] "t_ae_pt_soc_slide footnote"
#> 
#> $t_ae_pt_soc_slide_G34_X2PER_SE$paper
#> [1] "L6"
#> 
#> $t_ae_pt_soc_slide_G34_X2PER_SE$suffix
#> [1] "G34_X2PER_SE"
#> 
#> $t_ae_pt_soc_slide_G34_X2PER_SE$args
#> $t_ae_pt_soc_slide_G34_X2PER_SE$args$arm
#> [1] "TRT01A"
#> 
#> $t_ae_pt_soc_slide_G34_X2PER_SE$args$cutoff
#> [1] 2
#> 
#> 
#> $t_ae_pt_soc_slide_G34_X2PER_SE$output
#> [1] "t_ae_pt_soc_slide_G34_X2PER_SE"
#> 
#> 
#> $t_ae_diff_slide_X5PER_SE
#> $t_ae_diff_slide_X5PER_SE$program
#> [1] "t_ae_diff_slide"
#> 
#> $t_ae_diff_slide_X5PER_SE$titles
#> [1] "Adverse Events with Difference of At Least 5% between Arms by Preferred Term"
#> 
#> $t_ae_diff_slide_X5PER_SE$footnotes
#> [1] "t_ae_diff_slide footnote"
#> 
#> $t_ae_diff_slide_X5PER_SE$paper
#> [1] "L6"
#> 
#> $t_ae_diff_slide_X5PER_SE$suffix
#> [1] "X5PER_SE"
#> 
#> $t_ae_diff_slide_X5PER_SE$args
#> $t_ae_diff_slide_X5PER_SE$args$arm
#> [1] "TRT01A"
#> 
#> $t_ae_diff_slide_X5PER_SE$args$cutoff
#> [1] 5
#> 
#> 
#> $t_ae_diff_slide_X5PER_SE$output
#> [1] "t_ae_diff_slide_X5PER_SE"
#> 
#> 
#> $t_ae_diff_slide_G34_X2PER_SE
#> $t_ae_diff_slide_G34_X2PER_SE$program
#> [1] "t_ae_diff_slide"
#> 
#> $t_ae_diff_slide_G34_X2PER_SE$titles
#> [1] "Grade 3-4 Adverse Events with Difference of At Least 2% between Arms by Preferred Term"
#> 
#> $t_ae_diff_slide_G34_X2PER_SE$footnotes
#> [1] "t_ae_diff_slide footnote"
#> 
#> $t_ae_diff_slide_G34_X2PER_SE$paper
#> [1] "L6"
#> 
#> $t_ae_diff_slide_G34_X2PER_SE$suffix
#> [1] "G34_X2PER_SE"
#> 
#> $t_ae_diff_slide_G34_X2PER_SE$args
#> $t_ae_diff_slide_G34_X2PER_SE$args$arm
#> [1] "TRT01A"
#> 
#> $t_ae_diff_slide_G34_X2PER_SE$args$cutoff
#> [1] 2
#> 
#> 
#> $t_ae_diff_slide_G34_X2PER_SE$output
#> [1] "t_ae_diff_slide_G34_X2PER_SE"
#> 
#> 
#> $t_ae_soc_diff_slide_X5PER_SE
#> $t_ae_soc_diff_slide_X5PER_SE$program
#> [1] "t_ae_soc_diff_slide"
#> 
#> $t_ae_soc_diff_slide_X5PER_SE$titles
#> [1] "Adverse Events with Difference of At Least 5% between Arms by Preferred Term"
#> 
#> $t_ae_soc_diff_slide_X5PER_SE$footnotes
#> [1] "t_ae_soc_diff_slide footnote"
#> 
#> $t_ae_soc_diff_slide_X5PER_SE$paper
#> [1] "L6"
#> 
#> $t_ae_soc_diff_slide_X5PER_SE$suffix
#> [1] "X5PER_SE"
#> 
#> $t_ae_soc_diff_slide_X5PER_SE$args
#> $t_ae_soc_diff_slide_X5PER_SE$args$arm
#> [1] "TRT01A"
#> 
#> $t_ae_soc_diff_slide_X5PER_SE$args$cutoff
#> [1] 5
#> 
#> 
#> $t_ae_soc_diff_slide_X5PER_SE$output
#> [1] "t_ae_soc_diff_slide_X5PER_SE"
#> 
#> 
#> $t_ae_soc_diff_slide_G34_X2PER_SE
#> $t_ae_soc_diff_slide_G34_X2PER_SE$program
#> [1] "t_ae_soc_diff_slide"
#> 
#> $t_ae_soc_diff_slide_G34_X2PER_SE$titles
#> [1] "Grade 3-4 Adverse Events with Difference of At Least 2% between Arms by Preferred Term"
#> 
#> $t_ae_soc_diff_slide_G34_X2PER_SE$footnotes
#> [1] "t_ae_soc_diff_slide footnote"
#> 
#> $t_ae_soc_diff_slide_G34_X2PER_SE$paper
#> [1] "L6"
#> 
#> $t_ae_soc_diff_slide_G34_X2PER_SE$suffix
#> [1] "G34_X2PER_SE"
#> 
#> $t_ae_soc_diff_slide_G34_X2PER_SE$args
#> $t_ae_soc_diff_slide_G34_X2PER_SE$args$arm
#> [1] "TRT01A"
#> 
#> $t_ae_soc_diff_slide_G34_X2PER_SE$args$cutoff
#> [1] 2
#> 
#> 
#> $t_ae_soc_diff_slide_G34_X2PER_SE$output
#> [1] "t_ae_soc_diff_slide_G34_X2PER_SE"
#> 
#> 
#> $t_dd_slide_SE
#> $t_dd_slide_SE$program
#> [1] "t_dd_slide"
#> 
#> $t_dd_slide_SE$titles
#> [1] "Deaths and Causes of Death"
#> 
#> $t_dd_slide_SE$footnotes
#> [1] ""
#> 
#> $t_dd_slide_SE$paper
#> [1] "L6"
#> 
#> $t_dd_slide_SE$suffix
#> [1] "SE"
#> 
#> $t_dd_slide_SE$args
#> $t_dd_slide_SE$args$arm
#> [1] "TRT01A"
#> 
#> 
#> $t_dd_slide_SE$output
#> [1] "t_dd_slide_SE"
#> 
#> 
#> $t_ae_soc_diff_slide_SER_X2PER_SE
#> $t_ae_soc_diff_slide_SER_X2PER_SE$program
#> [1] "t_ae_soc_diff_slide"
#> 
#> $t_ae_soc_diff_slide_SER_X2PER_SE$titles
#> [1] "Serious AEs with Difference of at Least 2% between Treatment Arms"
#> 
#> $t_ae_soc_diff_slide_SER_X2PER_SE$footnotes
#> [1] "t_ae_soc_diff_slide footnotes"
#> 
#> $t_ae_soc_diff_slide_SER_X2PER_SE$paper
#> [1] "L6"
#> 
#> $t_ae_soc_diff_slide_SER_X2PER_SE$suffix
#> [1] "SER_X2PER_SE"
#> 
#> $t_ae_soc_diff_slide_SER_X2PER_SE$args
#> $t_ae_soc_diff_slide_SER_X2PER_SE$args$arm
#> [1] "TRT01A"
#> 
#> $t_ae_soc_diff_slide_SER_X2PER_SE$args$cutoff
#> [1] 2
#> 
#> 
#> $t_ae_soc_diff_slide_SER_X2PER_SE$output
#> [1] "t_ae_soc_diff_slide_SER_X2PER_SE"
#> 
#> 
#> $t_ae_si_slide_SE
#> $t_ae_si_slide_SE$program
#> [1] "t_ae_si_slide"
#> 
#> $t_ae_si_slide_SE$titles
#> [1] "Immune-mediated Adverse Events"
#> 
#> $t_ae_si_slide_SE$footnotes
#> [1] ""
#> 
#> $t_ae_si_slide_SE$paper
#> [1] "L6"
#> 
#> $t_ae_si_slide_SE$suffix
#> [1] "SE"
#> 
#> $t_ae_si_slide_SE$args
#> $t_ae_si_slide_SE$args$arm
#> [1] "TRT01A"
#> 
#> 
#> $t_ae_si_slide_SE$output
#> [1] "t_ae_si_slide_SE"
#> 
#> 
#> $t_cm_npt_slide_FAS
#> $t_cm_npt_slide_FAS$program
#> [1] "t_cm_npt_slide"
#> 
#> $t_cm_npt_slide_FAS$titles
#> [1] "Follow-up Anti-cancer Therapies"
#> 
#> $t_cm_npt_slide_FAS$footnotes
#> [1] ""
#> 
#> $t_cm_npt_slide_FAS$paper
#> [1] "L6"
#> 
#> $t_cm_npt_slide_FAS$suffix
#> [1] "FAS"
#> 
#> $t_cm_npt_slide_FAS$args
#> $t_cm_npt_slide_FAS$args$arm
#> [1] "TRT01P"
#> 
#> 
#> $t_cm_npt_slide_FAS$output
#> [1] "t_cm_npt_slide_FAS"
#> 
#> 
#> $t_ef_concord_slide_FAS
#> $t_ef_concord_slide_FAS$program
#> [1] "t_ef_concord_slide"
#> 
#> $t_ef_concord_slide_FAS$titles
#> [1] "Concordance Analysis Between the IRF Determined and the Investigator Determined PD"
#> 
#> $t_ef_concord_slide_FAS$footnotes
#> [1] ""
#> 
#> $t_ef_concord_slide_FAS$paper
#> [1] "L6"
#> 
#> $t_ef_concord_slide_FAS$suffix
#> [1] "FAS"
#> 
#> $t_ef_concord_slide_FAS$args
#> $t_ef_concord_slide_FAS$args$arm
#> [1] "TRT01P"
#> 
#> 
#> $t_ef_concord_slide_FAS$output
#> [1] "t_ef_concord_slide_FAS"
#> 
#> 
#> $t_lb_slide_SE
#> $t_lb_slide_SE$program
#> [1] "t_lb_slide"
#> 
#> $t_lb_slide_SE$titles
#> [1] "Laboratory Test Results and Change from Baseline by Visit"
#> 
#> $t_lb_slide_SE$footnotes
#> [1] ""
#> 
#> $t_lb_slide_SE$paper
#> [1] "L6"
#> 
#> $t_lb_slide_SE$suffix
#> [1] "SE"
#> 
#> $t_lb_slide_SE$args
#> $t_lb_slide_SE$args$arm
#> [1] "TRT01A"
#> 
#> 
#> $t_lb_slide_SE$output
#> [1] "t_lb_slide_SE"
#> 
#> 
#> $t_vs_slide_FAS
#> $t_vs_slide_FAS$program
#> [1] "t_vs_slide"
#> 
#> $t_vs_slide_FAS$titles
#> [1] "Vital Sign Abnormalities"
#> 
#> $t_vs_slide_FAS$footnotes
#> [1] ""
#> 
#> $t_vs_slide_FAS$paper
#> [1] "L6"
#> 
#> $t_vs_slide_FAS$suffix
#> [1] "FAS"
#> 
#> $t_vs_slide_FAS$args
#> $t_vs_slide_FAS$args$arm
#> [1] "TRT01P"
#> 
#> 
#> $t_vs_slide_FAS$output
#> [1] "t_vs_slide_FAS"
#> 
#> 
#> $t_eg_abn_slide_SE
#> $t_eg_abn_slide_SE$program
#> [1] "t_eg_abn_slide"
#> 
#> $t_eg_abn_slide_SE$titles
#> [1] "ECG Abnormalities"
#> 
#> $t_eg_abn_slide_SE$footnotes
#> [1] ""
#> 
#> $t_eg_abn_slide_SE$paper
#> [1] "L6"
#> 
#> $t_eg_abn_slide_SE$suffix
#> [1] "SE"
#> 
#> $t_eg_abn_slide_SE$args
#> $t_eg_abn_slide_SE$args$arm
#> [1] "TRT01A"
#> 
#> 
#> $t_eg_abn_slide_SE$output
#> [1] "t_eg_abn_slide_SE"
#> 
#> 
#> $t_ae_sae_slide_SER
#> $t_ae_sae_slide_SER$program
#> [1] "t_ae_sae_slide"
#> 
#> $t_ae_sae_slide_SER$titles
#> [1] "AEs & Serious AEs"
#> 
#> $t_ae_sae_slide_SER$footnotes
#> [1] ""
#> 
#> $t_ae_sae_slide_SER$paper
#> [1] "L6"
#> 
#> $t_ae_sae_slide_SER$suffix
#> [1] "SER"
#> 
#> $t_ae_sae_slide_SER$args
#> $t_ae_sae_slide_SER$args$arm
#> [1] "TRT01A"
#> 
#> 
#> $t_ae_sae_slide_SER$output
#> [1] "t_ae_sae_slide_SER"
#> 
#> 
#> $t_aesi_slide_SE
#> $t_aesi_slide_SE$program
#> [1] "t_aesi_slide"
#> 
#> $t_aesi_slide_SE$titles
#> [1] "AESIs"
#> 
#> $t_aesi_slide_SE$footnotes
#> [1] ""
#> 
#> $t_aesi_slide_SE$paper
#> [1] "L6"
#> 
#> $t_aesi_slide_SE$suffix
#> [1] "SE"
#> 
#> $t_aesi_slide_SE$args
#> $t_aesi_slide_SE$args$arm
#> [1] "TRT01A"
#> 
#> 
#> $t_aesi_slide_SE$output
#> [1] "t_aesi_slide_SE"
#> 
#> 
#> attr(,"class")
#> [1] "spec" "list"
```
