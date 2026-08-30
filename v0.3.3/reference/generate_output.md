# Generate output and apply filters, titles, and footnotes

Generate output and apply filters, titles, and footnotes

## Usage

``` r
generate_output(program, datasets, spec, verbose_level = 2, ...)
```

## Arguments

- program:

  program name

- datasets:

  list of datasets

- spec:

  spec

- verbose_level:

  Verbose level of messages be displayed. See details for further
  information.

- ...:

  arguments passed to program

## Value

No return value, called for side effects

## Details

\`verbose_level\` is used to control how many messages are printed out.
By default, \`2\` will show all filter messages and show output
generation message. \`1\` will show output generation message only.
\`0\` will display no message.

## Author

Liming Li (\`Lil128\`)

## Examples

``` r
library(dplyr)
filters::load_filters(
  yaml_file = system.file("filters.yml", package = "autoslider.core"),
  overwrite = TRUE
)

spec_file <- system.file("spec.yml", package = "autoslider.core")
spec <- spec_file %>% read_spec()

data <- list(
  adsl = eg_adsl,
  adae = eg_adae
)
generate_output("t_ae_slide", data, spec$t_ae_slide_SE)
#> ❯ 
#> ⚠ Error: `ids` must be a character scalar.
#> [1] "`ids` must be a character scalar."
#> attr(,"step")
#> [1] "filter dataset"
#> attr(,"class")
#> [1] "autoslider_error"
```
