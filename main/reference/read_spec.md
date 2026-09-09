# Read yaml spec file

Read yaml spec file and split according to filter lists

## Usage

``` r
read_spec(spec_file = "spec.yml", metadata = NULL)
```

## Arguments

- spec_file:

  \`character\`. Path to a yaml spec file

- metadata:

  Study-level token values merged into every spec entry. Either a named
  \`list\` (or \`NULL\`), or a \`character(1)\` path to a yaml metadata
  file (see \[read_metadata()\] and the example at
  \`system.file("metadata.yml", package = "autoslider.core")\`), which
  is read into a list for you. Its elements can be referenced as
  \`token\` placeholders in the \`titles\` and \`footnotes\` fields of
  the spec and are substituted during decoration (see
  \[apply_tokens()\]). For example, with \`metadata = list(study =
  "BP12345")\` a spec title of \`"Demographics - Study study"\` becomes
  \`"Demographics - Study BP12345"\`.

## Value

An object of class \`spec\` which is a \`list\` where each element
corresponds to one output, e.g. \`t_dm_IT\`.

## Author

\- Liming Li (\`Lil128\`) - Thomas Neitmann (\`neitmant\`) - Joe Zhu

## Examples

``` r
spec_file <- system.file("spec.yml", package = "autoslider.core")

## Take a look at the 'raw' content of the spec file
cat(readLines(spec_file)[1:24], sep = "\n")
#> # ---------------------------------------------------------------------------
#> # Metadata tokens
#> #
#> # Any {token} in a `titles` or `footnotes` field below is replaced during
#> # decoration with the matching value from the `metadata` list passed to
#> # read_spec(), e.g.:
#> #
#> #   read_spec("spec.yml", metadata = list(study = "BP12345"))
#> #
#> # turns a title of "Demographics - Study {study}" into
#> # "Demographics - Study BP12345". Unknown tokens raise an error.
#> # See ?read_spec, ?apply_tokens and the generate_placeholder_slides vignette.
#> # ---------------------------------------------------------------------------
#> - program: l_dsl01_slide
#>   titles: Analysis Sets ({filter_titles("adsl")})
#>   footnotes: 'Analysis Sets footer'
#>   paper: L6
#>   suffix: SE
#> - program: t_pop_slide
#>   titles: Analysis Sets ({filter_titles("adsl")})
#>   footnotes: 'Analysis Sets footer'
#>   paper: L6
#>   suffix: FAS
#> - program: t_ds_slide

## This is how it looks once read into R
spec <- read_spec(spec_file)
spec[1:3]
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

## Supply study metadata so that `{token}` placeholders in titles/footnotes
## are filled in during decoration (e.g. a title of "... Study {study}").
spec <- read_spec(spec_file, metadata = list(study = "BP12345"))

## The same metadata can be kept in a yaml file and read via `read_spec()`
metadata_file <- system.file("metadata.yml", package = "autoslider.core")
spec <- read_spec(spec_file, metadata = metadata_file)
```
