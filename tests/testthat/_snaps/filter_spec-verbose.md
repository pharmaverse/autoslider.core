# Listing print correctly

    Code
      full_spec %>% filter_spec(., program %in% c("t_ds_slide", "t_ds_trt_slide",
        "i_am_wrong"), verbose = TRUE)
    Output
      v 2/55 outputs matched the filter condition `program %in% c("t_ds_slide", "t_ds_trt_slide", "i_am_wrong")`.
      $t_ds_slide_FAS
      $t_ds_slide_FAS$program
      [1] "t_ds_slide"
      
      $t_ds_slide_FAS$titles
      [1] "Patient Disposition"
      
      $t_ds_slide_FAS$footnotes
      [1] "t_ds footnotes"
      
      $t_ds_slide_FAS$paper
      [1] "L6"
      
      $t_ds_slide_FAS$suffix
      [1] "FAS"
      
      $t_ds_slide_FAS$output
      [1] "t_ds_slide_FAS"
      
      
      $t_ds_trt_slide_SE
      $t_ds_trt_slide_SE$program
      [1] "t_ds_trt_slide"
      
      $t_ds_trt_slide_SE$titles
      [1] "Patients Who Discontinued From Study Treatment"
      
      $t_ds_trt_slide_SE$footnotes
      [1] "ds trt footnotes"
      
      $t_ds_trt_slide_SE$paper
      [1] "L6"
      
      $t_ds_trt_slide_SE$suffix
      [1] "SE"
      
      $t_ds_trt_slide_SE$args
      $t_ds_trt_slide_SE$args$arm
      [1] "TRT01A"
      
      $t_ds_trt_slide_SE$args$colcount
      [1] FALSE
      
      $t_ds_trt_slide_SE$args$drug_vars
      [1] "A: Drug X"      "B: Placebo"     "C: Combination"
      
      $t_ds_trt_slide_SE$args$drug_names
      [1] "Drug X"      "Placebo"     "Combination"
      
      $t_ds_trt_slide_SE$args$drug_sdt
      [1] "TRTSDT" "TRTSDT" "TRTSDT"
      
      $t_ds_trt_slide_SE$args$drug_discfl
      [1] "DTRFL" "DTRFL" "DTRFL"
      
      $t_ds_trt_slide_SE$args$drug_discst
      [1] "EOTSTT" "EOTSTT" "EOTSTT"
      
      $t_ds_trt_slide_SE$args$drug_discrs
      [1] "DCSREAS" "DCSREAS" "DCSREAS"
      
      
      $t_ds_trt_slide_SE$output
      [1] "t_ds_trt_slide_SE"
      
      
      attr(,"class")
      [1] "spec" "list"

