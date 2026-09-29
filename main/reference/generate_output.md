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
spec <- spec_file |> read_spec()

data <- list(
  adsl = eg_adsl,
  adae = eg_adae
)
generate_output("t_ae_slide", data, spec$t_ae_slide_SE)
#> ❯ Running program `t_ae_slide` with suffix 'SE'.
#> Filter 'SE' matched target ADSL.
#> 400/400 records matched the filter condition `SAFFL == 'Y'`.
#> AE event table
#> 
#> ————————————————————————————————————————————————————————————————————————————————————————
#> MedDRA System Organ Class                                                               
#>    MedDRA Preferred Term N (%)   A: Drug X    B: Placebo   C: Combination   All Patients
#> ————————————————————————————————————————————————————————————————————————————————————————
#> Total number of patients         78 (58.2)     75 (56)       89 (67.4)       242 (60.5) 
#> cl A.1                           78 (58.2%)   75 (56.0%)     89 (67.4%)     242 (60.5%) 
#>     dcd A.1.1.1.1                50 (37.3%)   45 (33.6%)     63 (47.7%)     158 (39.5%) 
#>     dcd A.1.1.1.2                48 (35.8%)   48 (35.8%)     50 (37.9%)     146 (36.5%) 
#> Total number of patients          79 (59)     74 (55.2)      85 (64.4)       238 (59.5) 
#> cl B.2                           79 (59.0%)   74 (55.2%)     85 (64.4%)     238 (59.5%) 
#>     dcd B.2.2.3.1                48 (35.8%)   54 (40.3%)     51 (38.6%)     153 (38.2%) 
#>     dcd B.2.1.2.1                49 (36.6%)   44 (32.8%)     52 (39.4%)     145 (36.2%) 
#> Total number of patients          79 (59)      67 (50)       80 (60.6)       226 (56.5) 
#> cl D.1                           79 (59.0%)   67 (50.0%)     80 (60.6%)     226 (56.5%) 
#>     dcd D.1.1.1.1                50 (37.3%)   42 (31.3%)     51 (38.6%)     143 (35.8%) 
#>     dcd D.1.1.4.2                48 (35.8%)   42 (31.3%)     50 (37.9%)     140 (35.0%) 
#> Total number of patients         47 (35.1)    58 (43.3)      57 (43.2)       162 (40.5) 
#> cl D.2                           47 (35.1%)   58 (43.3%)     57 (43.2%)     162 (40.5%) 
#>     dcd D.2.1.5.3                47 (35.1%)   58 (43.3%)     57 (43.2%)     162 (40.5%) 
#> Total number of patients         47 (35.1)    49 (36.6)      43 (32.6)       139 (34.8) 
#> cl B.1                           47 (35.1%)   49 (36.6%)     43 (32.6%)     139 (34.8%) 
#>     dcd B.1.1.1.1                47 (35.1%)   49 (36.6%)     43 (32.6%)     139 (34.8%) 
#> Total number of patients         35 (26.1)    48 (35.8)      55 (41.7)       138 (34.5) 
#> cl C.2                           35 (26.1%)   48 (35.8%)     55 (41.7%)     138 (34.5%) 
#>     dcd C.2.1.2.1                35 (26.1%)   48 (35.8%)     55 (41.7%)     138 (34.5%) 
#> Total number of patients         43 (32.1)    46 (34.3)      43 (32.6)        132 (33)  
#> cl C.1                           43 (32.1%)   46 (34.3%)     43 (32.6%)     132 (33.0%) 
#>     dcd C.1.1.1.3                43 (32.1%)   46 (34.3%)     43 (32.6%)     132 (33.0%) 
```
