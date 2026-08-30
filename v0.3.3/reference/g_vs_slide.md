# Plot mean values of VS

Wrapper for \`g_mean_general()\`. Requires filtering of the datasets
(e.g. using SUFFIX in spec.yml)

## Usage

``` r
g_vs_slide(
  adsl,
  advs,
  arm = "TRT01P",
  paramcd = "PARAM",
  subtitle = "Plot of Mean and 95% Confidence Limits by Visit.",
  ...
)
```

## Arguments

- adsl:

  ADSL data

- advs:

  ADVS data

- arm:

  \`"TRT01P"\` by default

- paramcd:

  Which variable to use for plotting. By default \`"PARAM"\`

- subtitle:

  character scalar forwarded to g_lineplot

- ...:

  \| Gets forwarded to \`tern::g_lineplot()\`. This lets you specify
  additional arguments to \`tern::g_lineplot()\`

## Author

Stefan Thoma (\`thomas7\`)

## Examples

``` r
library(dplyr)
advs_filtered <- eg_advs %>% filter(
  PARAMCD == "SYSBP"
)
plot_vs <- g_vs_slide(
  adsl = eg_adsl,
  advs = advs_filtered,
  paramcd = "PARAM",
  subtitle_add_unit = FALSE
) +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
# makes editable plots
generate_slides(plot_vs, paste0(tempdir(), "/g_vs.pptx"), fig_editable = TRUE)
# not editable plots, which appear as images
generate_slides(plot_vs, paste0(tempdir(), "/g_vs.pptx"), fig_editable = FALSE)
```
