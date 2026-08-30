# Plot mean values of EG

Wrapper for \`g_mean_general()\`. Requires filtering of the datasets
(e.g. using SUFFIX in spec.yml)

## Usage

``` r
g_eg_slide(
  adsl,
  adeg,
  arm = "TRT01P",
  paramcd = "PARAM",
  subtitle = "Plot of Mean and 95% Confidence Limits by Visit.",
  ...
)
```

## Arguments

- adsl:

  ADSL data

- adeg:

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

adeg_filtered <- eg_adeg %>% filter(
  PARAMCD == "HR"
)
plot_eg <- g_eg_slide(
  adsl = eg_adsl,
  adeg = adeg_filtered,
  arm = "TRT01P",
  paramcd = "PARAM",
  subtitle_add_unit = FALSE
) +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))

generate_slides(plot_eg, paste0(tempdir(), "/g_eg.pptx"))
```
