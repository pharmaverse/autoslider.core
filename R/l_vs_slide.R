#' Listing of Vital Signs: Safety-Evaluable Patients
#'
#' This function generates a listing with vital signs of patients.
#' It creates various columns such as patient identifier, age/sex/race, visit,
#' and calculates the range of several vital signs. The output listing includes labels for each column and a main title.
#'
#' @param adsl A dataframe representing the `ADSL` data.
#' Used to propagate filters to `ADVS`
#' @param advs A dataframe representing the ADVS data.
#' @param trt_var Character scalar or `NULL`. `"TRT01A"` by default. Specifies which variable,
#' if any, should be included as the treatment arm.
#'
#' @return A listing object of vital signs of patients
#'
#' @details
#' The function first validates whether the required columns are present in the ADVS dataframe.
#' Then, various calculations and transformations are performed to create additional columns.
#' Finally, the data is formatted into a listing with appropriate column labels.
#'
#' @seealso
#' \href{https://insightsengineering.github.io/tlg-catalog/stable/listings/vital-signs/vsl01.html}{Vital signs Listing}
#'
#' @export
#'
#' @examples
#' require(dplyr)
#' require(rlistings)
#' adsl <- eg_adsl
#' advs <- eg_advs %>% filter(SUBJID %in% c("id-236", "id-65", "id-93"))
#'
#' # Default usage
#' l_vs_slide(adsl = adsl, advs = advs, trt_var = "TRT01A")
#'
#' # Custom treatment variable
#' l_vs_slide(adsl = adsl, advs = advs, trt_var = NULL)
#'
l_vs_slide <- function(adsl, advs, trt_var = "TRT01A") {
  variables <- c("SITEID", "SUBJID", "AGE", "SEX", "RACE", trt_var)
  lapply(variables, function(x) {
    assert_that(has_name(advs, x))
  })

  # Optional treatment column ----
  trt_cols <- if (!is.null(trt_var)) trt_var else character(0)

  # Preprocess data ----
  adsl_f <- adsl %>%
    df_explicit_na()

  get_param_unit_range <- function(dataset) {
    u_rng <- lapply(unique(dataset$PARAMCD), function(p) {
      dat <- dataset %>% filter(PARAMCD == p)
      list(
        unit = unique(dat$AVALU),
        range = paste0(unique(dat$ANRLO), "-", unique(dat$ANRHI))
      )
    })
    names(u_rng) <- unique(dataset$PARAMCD)
    u_rng
  }

  vs_u_rng <- get_param_unit_range(advs)

  advs_f <- advs %>%
    semi_join(., adsl_f, by = c("STUDYID", "USUBJID"))

  advs_sub <- advs_f %>%
    filter(!is.na(AVAL) & SAFFL == "Y" & ONTRTFL == "Y" & !is.na(VSSEQ)) %>%
    mutate(
      CRTNPT = paste(SITEID, sub("^.*-([[:alnum:]]+)$", "\\1", SUBJID), sep = "/"),
      AGSXRC = paste(AGE, SEX, RACE, sep = "/"),
      AVAL = format(round(AVAL, 2), nsmall = 2),
      AVAL_ANRIND = ifelse(ANRIND %in% c("NORMAL", ""), AVAL, paste(AVAL, substr(ANRIND, 1, 1), sep = "/")),
      CHG = format(round(CHG, 2), nsmall = 2)
    )

  id_cols <- c("SUBJID", "CRTNPT", "AGSXRC", trt_cols, "ADY", "AVISIT", "ADTM")

  anl_vs <- advs_sub %>%
    select(all_of(id_cols), PARAMCD, AVAL_ANRIND, CHG) %>%
    tidyr::pivot_wider(
      id_cols = all_of(id_cols),
      names_from = PARAMCD,
      values_from = c(AVAL_ANRIND, CHG)
    )

  out <- anl_vs %>%
    select(
      all_of(c("CRTNPT", "AGSXRC", trt_cols, "AVISIT", "ADY")),
      AVAL_ANRIND_WEIGHT, AVAL_ANRIND_TEMP, AVAL_ANRIND_DIABP,
      AVAL_ANRIND_SYSBP, AVAL_ANRIND_PULSE, AVAL_ANRIND_RESP
    )

  labels <- list(
    CRTNPT = "Center/Subject ID",
    AGSXRC = "Age/Sex/Race",
    AVISIT = "Visit",
    ADY = "Study\nDay",
    AVAL_ANRIND_WEIGHT = paste0(
      "Weight\nResult\n(",
      vs_u_rng$WEIGHT$unit,
      ");\nRange:(",
      vs_u_rng$WEIGHT$range,
      ")"
    ),
    AVAL_ANRIND_TEMP = paste0(
      "Temperature Result\n(",
      vs_u_rng$TEMP$unit,
      ");\nRange:(",
      vs_u_rng$TEMP$range,
      ")"
    ),
    AVAL_ANRIND_DIABP = paste0(
      "Diastolic Blood\nPressure,\nSitting\nResult\n(",
      vs_u_rng$DIABP$unit,
      ");\nRange:(",
      vs_u_rng$DIABP$range,
      ")"
    ),
    AVAL_ANRIND_SYSBP = paste0(
      "Systolic Blood\nPressure,\nSitting\n(",
      vs_u_rng$SYSBP$unit,
      ");\nRange:(",
      vs_u_rng$SYSBP$range,
      ")"
    ),
    AVAL_ANRIND_PULSE = paste0(
      "Pulse Rate Result\n(",
      vs_u_rng$PULSE$unit,
      ");\nRange:(",
      vs_u_rng$PULSE$range,
      ")"
    ),
    AVAL_ANRIND_RESP = paste0(
      "Respiratory Rate\nResult\n(",
      vs_u_rng$RESP$unit,
      ");\nRange:(",
      vs_u_rng$RESP$range,
      ")"
    )
  )
  if (!is.null(trt_var)) {
    labels[[trt_var]] <- "Treatment"
  }

  out <- do.call(formatters::var_relabel, c(list(out), labels))

  lsting <- as_listing(
    out,
    key_cols = c(trt_cols, "CRTNPT", "AGSXRC", "AVISIT"),
    disp_cols = names(out),
    main_title = "Listing of Vital Signs: Safety-Evaluable Patients",
    main_footer = paste(
      "Baseline is the patient's last observation prior to initiation of study drug.",
      "Abnormalities are flagged as high (H) or low (L) if outside the Roche standard reference range."
    )
  )

  lsting
}
