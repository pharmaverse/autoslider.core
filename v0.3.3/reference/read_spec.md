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

  Metadata of study

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
#>   titles: Patient Disposition
#>   footnotes: 't_ds footnotes'
#>   paper: L6
#>   suffix: FAS
#> - program: t_ds_trt_slide
#>   titles: Patients Who Discontinued From Study Treatment
#>   footnotes: 'ds trt footnotes'
#>   paper: L6
#>   suffix: SE
#>   args:
#>     arm: "TRT01A"
#>     colcount: FALSE
#>     drug_vars: ["A: Drug X", "B: Placebo", "C: Combination"]

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
```
