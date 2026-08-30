# Plot mean values of LB

Wrapper for \`g_mean_general()\`. Requires filtering of the datasets
(e.g. using SUFFIX in spec.yml)

## Usage

``` r
g_lb_slide(
  adsl,
  adlb,
  arm = "TRT01P",
  paramcd = "PARAM",
  y = "AVAL",
  subtitle = "Plot of Mean and 95% Confidence Limits by Visit.",
  ...
)
```

## Arguments

- adsl:

  ADSL data

- adlb:

  ADLB data

- arm:

  \`"TRT01P"\` by default

- paramcd:

  character scalar. defaults to By default \`"PARAM"\` Which variable to
  use for plotting.

- y:

  character scalar. Variable to plot on the Y axis. By default
  \`"AVAL"\`

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

adlb_filtered <- eg_adlb %>% filter(
  PARAMCD == "CRP"
)
plot_lb <- g_lb_slide(
  adsl = eg_adsl,
  adlb = adlb_filtered,
  paramcd = "PARAM",
  subtitle_add_unit = FALSE
) +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
generate_slides(plot_lb, paste0(tempdir(), "/g_lb.pptx"))

# Let's plot change values:
plot_lb_chg <- g_lb_slide(
  adsl = eg_adsl,
  adlb = adlb_filtered,
  paramcd = "PARAM",
  y = "CHG",
  subtitle = "Plot of change from baseline and 95% Confidence Limit by Visit."
)
generate_slides(plot_lb_chg, paste0(tempdir(), "/g_lb_chg.pptx"))
```
