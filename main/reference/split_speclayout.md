# Split an ordered speclayout into content and placeholder entries

Partitions a speclayout (as read by \[yaml::read_yaml()\]) into the TLG
entries (those with a \`program\`) and the placeholder entries (those
with a \`type\` and no \`program\`), keeping file order. Anything else
(e.g. a \`defaults:\` block) is returned under \`other\`.

## Usage

``` r
split_speclayout(speclayout)
```

## Arguments

- speclayout:

  A named \`list\` read from a speclayout yaml file.

## Value

A \`list\` with named-list elements \`content\`, \`placeholders\` and
\`other\`.

## Examples

``` r
speclayout <- list(
  sec_overview = list(type = "section", title = "Overview"),
  t_dm_slide_FAS = list(program = "t_dm_slide", suffix = "FAS"),
  defaults = list(common = list(layout = "Title and Content"))
)
split_speclayout(speclayout)
#> $content
#> $content$t_dm_slide_FAS
#> $content$t_dm_slide_FAS$program
#> [1] "t_dm_slide"
#> 
#> $content$t_dm_slide_FAS$suffix
#> [1] "FAS"
#> 
#> 
#> 
#> $placeholders
#> $placeholders$sec_overview
#> $placeholders$sec_overview$type
#> [1] "section"
#> 
#> $placeholders$sec_overview$title
#> [1] "Overview"
#> 
#> 
#> 
#> $other
#> $other$defaults
#> $other$defaults$common
#> $other$defaults$common$layout
#> [1] "Title and Content"
#> 
#> 
#> 
#> 
```
