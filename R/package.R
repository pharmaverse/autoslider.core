#' autoslider.core Package
#'
# nocov start

"_PACKAGE"

#' @import flextable
#' @import officer
#' @import rtables
#' @import tern
#' @import rlistings
#' @import ggplot2
#' @importFrom assertthat assert_that noNA are_equal has_name is.string
#' @importFrom checkmate assert_class assert_numeric assert_flag assert_count assert_number
#' @importFrom cli cat_bullet
#' @importFrom dplyr mutate_at mutate rename filter select semi_join case_when all_of arrange
#' @importFrom dplyr left_join distinct inner_join
#' @importFrom dplyr %>%
#' @importFrom formatters matrix_form propose_column_widths
#' @importFrom ggpubr as_ggplot
#' @importFrom graphics title
#' @importFrom grDevices dev.off svg
#' @importFrom grid grid.draw gpar grid.newpage unit.pmax
#' @importFrom gridExtra arrangeGrob
#' @importFrom gtsummary tbl_summary add_p modify_caption
#' @importFrom methods is formalArgs new
#' @importFrom officer fortify_location ph_location_label set_notes layout_default
#' @importFrom rlang abort `:=`
#' @importFrom rvg dml
#' @importFrom stats setNames median na.omit pt sd as.formula
#' @importFrom stringr str_extract str_to_title
#' @importFrom survival Surv survfit coxph survdiff strata
#' @importFrom tern control_coxph format_xx d_proportion
#' @importFrom tidyr gather spread unite
#' @importFrom utils modifyList file.edit assignInNamespace
NULL

utils::globalVariables(c(
  ".", "AEACN", "AEBODSYS", "AECONTRT", "AEDECOD", "AENDY", "AEOUT", "AEREL", "AESER", "AETOXGR", "AGE",
  "ALL_RESOLVED", "ANL01FL", "ASTDY", "ATOXGR", "AVAL", "AVISIT", "AVISITN", "Action", "CNSR",
  "CONTRT", "COUNTRY", "CPID", "DCSREAS", "DSM", "DTHCAT", "Date_First", "EVNT1", "EVNTDESC",
  "NOT_RESOLVED", "RACE", "Related", "SAFFL", "SEX", "SITEID", "STDONS", "STUDYID", "SUBJID",
  "Serious", "TRT01A", "TRTEMFL", "TRTSDTM", "USUBJID", "WD", "as.formula", "border_color",
  "is_event", "is_not_event",
  "PARAMCD", "ONTRTFL", "VSSEQ", "ANRIND", "CHG", "AVAL_ANRIND", "AVAL_ANRIND_WEIGHT",
  "AVAL_ANRIND_TEMP", "AVAL_ANRIND_DIABP", "AVAL_ANRIND_SYSBP", "AVAL_ANRIND_PULSE",
  "AVAL_ANRIND_RESP"
))


#' General notes
#'
#' @note
#'  * Default arm variables are set to `"TRT01A"` for safety output, and
#'  `"TRT01P"` for efficacy output
#'
gen_notes <- function() {
  NULL
}

# nocov end
