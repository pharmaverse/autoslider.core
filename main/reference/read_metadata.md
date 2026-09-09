# Read a study metadata file

Reads a yaml metadata file into a named \`list\` of study-level values
suitable for the \`metadata\` argument of \[read_spec()\] and
\[apply_tokens()\]. Each top-level key in the file becomes a \`token\`
that can be referenced in the \`titles\` and \`footnotes\` fields of a
spec. An example file is shipped at \`system.file("metadata.yml",
package = "autoslider.core")\`.

## Usage

``` r
read_metadata(metadata_file = "metadata.yml")
```

## Arguments

- metadata_file:

  \`character(1)\`. Path to a yaml metadata file, i.e. a flat mapping of
  \`key: value\` pairs.

## Value

A named \`list\` of metadata values.

## See also

\[read_spec()\], \[apply_tokens()\]

## Examples

``` r
metadata_file <- system.file("metadata.yml", package = "autoslider.core")

## Take a look at the 'raw' content of the metadata file
cat(readLines(metadata_file), sep = "\n")
#> # ---------------------------------------------------------------------------
#> # Study metadata
#> #
#> # A flat list of study-level values. Each key below becomes a {token} that can
#> # be referenced in the `titles` and `footnotes` fields of a spec (see spec.yml)
#> # and is substituted into the text during decoration.
#> #
#> # Read it on its own with read_metadata(), or hand the path straight to
#> # read_spec() and let it read the file for you:
#> #
#> #   metadata <- read_metadata(
#> #     system.file("metadata.yml", package = "autoslider.core")
#> #   )
#> #   spec <- read_spec("spec.yml", metadata = metadata)
#> #
#> #   # equivalently -- read_spec() resolves a file path to a metadata list:
#> #   spec <- read_spec(
#> #     "spec.yml",
#> #     metadata = system.file("metadata.yml", package = "autoslider.core")
#> #   )
#> #
#> # A spec title of "Demographics - Study {study}" then becomes
#> # "Demographics - Study BP12345". Unknown tokens raise an error.
#> # See ?read_metadata, ?read_spec and ?apply_tokens.
#> # ---------------------------------------------------------------------------
#> study: BP12345
#> ro: RO12345678
#> cut_date: 17-FEB-2014
#> extr_date: 17-JUN-2014
#> part_id: 1
#> cohort_value: Cohort 2
#> spotfire_link: Insert link here.

## Read it into a named list of token values
read_metadata(metadata_file)
#> $study
#> [1] "BP12345"
#> 
#> $ro
#> [1] "RO12345678"
#> 
#> $cut_date
#> [1] "17-FEB-2014"
#> 
#> $extr_date
#> [1] "17-JUN-2014"
#> 
#> $part_id
#> [1] 1
#> 
#> $cohort_value
#> [1] "Cohort 2"
#> 
#> $spotfire_link
#> [1] "Insert link here."
#> 
```
