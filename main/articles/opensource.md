# Guidelines for Open-sourcing

`AutoslideR` core functions that are used for slide rendering and
workflow is already open-sourced with the
[`autoslider.core`](https://cran.r-project.org/package=autoslider.core)
package, if you have built your own customized template package, namely
`autoslider.*` (see [this
page](https://pharmaverse.github.io/autoslider.core/articles/downstream.md)
for guidelines), once the template functions are stable, generic, we
also encourage to make these functions open-source for external users.
This article describes the how to process. Template that contains
specific variable names or columns are not recommended for
open-sourcing. The key steps include the following

- From `autoslider.*` to `autoslider.core`.

1.  Move the template R functions `autoslider.core` `R/` directory,
    rebuild the `autoslider.core` documentation, and update the
    `autoslider.core` `NAMESPACE`.
2.  *Copy* (keep one copy within `autoslideR`) the relevant test
    function to `autoslider.core` `tests/testthat` directory.

- On the `autoslider.*` side.

1.  Reexport the template function, and edit the `R/autoslider_core.R`
    file.
2.  Recompile the documentation, and update the `autoslideR`
    `NAMESPACE`.

For example, `t_dm_slide.R` contains `t_dm_slide` template function, as
the following

`#' Demographic table`` ``#'`` ``#' @param adsl ADSL data set, dataframe`` ``` #' @param arm Arm variable, character, "`TRT01P" by default. ``` ``#' @param vars Characters of variables`` ``` #' @param stats see `.stats` from [tern::analyze_vars()] ``` ``#' @param split_by_study Split by study, building structured header for tables`` ``#' @param side_by_side "GlobalAsia" or "GlobalAsiaChina" to define the side by side requirement`` ``#' @return rtables object`` ``#' @inherit gen_notes note`` ``#' @export`` ``#' @examples`` ``#' library(dplyr)`` ``#' adsl <- eg_adsl`` ``#' out1 <- t_dm_slide(adsl, "TRT01P", c("SEX", "AGE", "RACE", "ETHNIC", "COUNTRY"))`` ``#' print(out1)`` ``#' generate_slides(out1, paste0(tempdir(), "/dm.pptx"))`` ``#'`` ``#' out2 <- t_dm_slide(adsl, "TRT01P", c("SEX", "AGE", "RACE", "ETHNIC", "COUNTRY"),`` ``#' split_by_study = TRUE`` ``#' )`` ``#' print(out2)`` ``#'`` ``t_dm_slide`` ``<-`` ``function``(``adsl``,`` `` ``arm`` ``=`` ``"TRT01P"``,`` `` ``vars`` ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``"AGE"``, ``"SEX"``, ``"RACE"``)``,`` `` ``stats`` ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``"median"``, ``"range"``, ``"count_fraction"``)``,`` `` ``split_by_study`` ``=`` ``FALSE``,`` `` ``side_by_side`` ``=`` ``NULL``)`` ``{`` `` ``if`` ``(`[`is.null`](https://rdrr.io/r/base/NULL.html)`(``side_by_side``)``)`` ``{`` `` ``extra`` ``<-`` ``NULL`` `` ``}`` ``else`` ``{`` `` ``extra`` ``<-`` `[`c`](https://rdrr.io/r/base/c.html)`(``"COUNTRY"``)`` `` ``}`` `` `` ``for`` ``(``v`` ``in`` `[`c`](https://rdrr.io/r/base/c.html)`(``vars``, ``extra``)``)`` ``{`` `` ``assert_that``(`[`has_name`](https://rlang.r-lib.org/reference/has_name.html)`(``adsl``, ``v``)``)`` `` ``}`` `` `` ``adsl1`` ``<-`` ``adsl`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)` `` `[`select`](https://dplyr.tidyverse.org/reference/select.html)`(`[`all_of`](https://tidyselect.r-lib.org/reference/all_of.html)`(`[`c`](https://rdrr.io/r/base/c.html)`(``"STUDYID"``, ``"USUBJID"``, ``arm``, ``vars``, ``extra``)``)``)`` `` `` ``lyt`` ``<-`` `[`build_table_header`](https://pharmaverse.github.io/autoslider.core/reference/build_table_header.md)`(``adsl1``, ``arm``,`` `` split_by_study ``=`` ``split_by_study``,`` `` side_by_side ``=`` ``side_by_side`` `` ``)`` `` `` ``lyt`` ``<-`` ``lyt`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)` `` ``analyze_vars``(`` `` na.rm ``=`` ``TRUE``,`` `` .stats ``=`` ``stats``,`` `` denom ``=`` ``"n"``,`` `` vars ``=`` ``vars``,`` `` .formats ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``mean_sd ``=`` ``"xx.xx (xx.xx)"``, median ``=`` ``"xx.xx"``)``,`` `` var_labels ``=`` ``formatters``::`[`var_labels`](https://rdrr.io/pkg/formatters/man/var_labels.html)`(``adsl1``)``[``vars``]`` `` ``)`` `` `` ``result`` ``<-`` `[`lyt_to_side_by_side`](https://pharmaverse.github.io/autoslider.core/reference/lyt_to_side_by_side.md)`(``lyt``, ``adsl1``, ``side_by_side``)`` `` `` ``if`` ``(`[`is.null`](https://rdrr.io/r/base/NULL.html)`(``side_by_side``)``)`` ``{`` `` ``# adding "N" attribute`` `` ``arm`` ``<-`` ``col_paths``(``result``)``[[``1``]``]``[``1``]`` `` `` ``n_r`` ``<-`` `[`data.frame`](https://rdrr.io/r/base/data.frame.html)`(`` `` ARM ``=`` `[`toupper`](https://rdrr.io/r/base/chartr.html)`(`[`names`](https://rdrr.io/r/base/names.html)`(``result``@``col_info``)``)``,`` `` N ``=`` ``col_counts``(``result``)`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)` `[`as.numeric`](https://rdrr.io/r/base/numeric.html)`(``)`` `` ``)`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)` `` ``` `colnames<-` ```(`[`c`](https://rdrr.io/r/base/c.html)`(`[`paste`](https://rdrr.io/r/base/paste.html)`(``arm``)``, ``"N"``)``)`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)` `` ``dplyr``::`[`arrange`](https://dplyr.tidyverse.org/reference/arrange.html)`(`[`get`](https://rdrr.io/r/base/get.html)`(``arm``)``)`` `` `` `[`attr`](https://rdrr.io/r/base/attr.html)`(``result``, ``"N"``)`` ``<-`` ``n_r`` `` ``}`` `` ``result``@``main_title`` ``<-`` ``"Demographic slide"`` `` ``result`` ``}`

1.  Move `t_dm_slide.R` file from `autoslider.*` to `autoslider.core`
    `R/` directory.
2.  Copy `autoslider.*` `tests/testthat/test-t_dm_slide.R` to
    `autoslider.core` `tests/testthat/`.
3.  Add the following code to `autoslider.*` `R/autoslider_core.R` file.

`#' Demographic table`` ``#' @importFrom autoslider.core t_dm_slide`` ``#' @examples`` ``#' library(dplyr)`` ``#' adsl <- eg_adsl`` ``#' out1 <- t_dm_slide(adsl, "TRT01P", c("SEX", "AGE", "RACE", "ETHNIC", "COUNTRY"))`` ``#' print(out1)`` ``#' generate_slides(out1, "dm.pptx")`` ``#'`` ``#' out2 <- t_dm_slide(adsl, "TRT01P", c("SEX", "AGE", "RACE", "ETHNIC", "COUNTRY"),`` ``#' split_by_study = TRUE`` ``#' )`` ``#' print(out2)`` ``#'`` ``#' @export`` ``autoslider.core``::`[`t_dm_slide`](https://pharmaverse.github.io/autoslider.core/reference/t_dm_slide.md)
