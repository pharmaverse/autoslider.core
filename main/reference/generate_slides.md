# generate slides based on output

generate slides based on output

## Usage

``` r
generate_slides(
  outputs,
  outfile = paste0(tempdir(), "/output.pptx"),
  template = file.path(system.file(package = "autoslider.core"), "theme/basic.pptx"),
  fig_width = 9,
  fig_height = 5,
  t_lpp = NULL,
  t_cpp = 200,
  l_lpp = 20,
  l_cpp = 150,
  fig_editable = FALSE,
  font_size = NULL,
  ...
)
```

## Arguments

- outputs:

  List of output

- outfile:

  Out file path

- template:

  Template file path

- fig_width:

  figure width in inch

- fig_height:

  figure height in inch

- t_lpp:

  An integer specifying the table lines per page\
  Specify this optional argument to modify the length of all of the
  table displays. Defaults to \`NULL\`, which auto-fits the table to the
  slide height (for rtables, via \[rtables::paginate_table()\]; for
  gtsummary, via a row-height estimate).

- t_cpp:

  An integer specifying the table columns per page\
  Specify this optional argument to modify the width of all of the table
  displays. Only honored for rtables output; gtsummary tables do not
  support column pagination and are instead scaled down to fit when too
  wide. Explicitly setting \`t_cpp\` also raises a warning for gtsummary
  tables that need scaling, since column pagination was requested but
  cannot be applied.

- l_lpp:

  An integer specifying the listing lines per page\
  Specify this optional argument to modify the length of all of the
  listings display

- l_cpp:

  An integer specifying the listing columns per page\
  Specify this optional argument to modify the width of all of the
  listings display

- fig_editable:

  whether we want the figure to be editable in pptx viewers, defaults to
  FALSE

- font_size:

  Deck-wide default table font sizes, a named \`list\` with any of
  \`body\`, \`header\`, \`footer\` (point sizes). Per-slide sizes
  declared in the spec (a \`font_size:\` block on the entry) override
  these. Applied by wrapping the slide's \`table_format\` via
  \[with_font_sizes()\]. The footer defaults to the body size, or 8 pt
  when no body size is supplied; see Details.

- ...:

  arguments passed to program

## Value

No return value, called for side effects

## Details

\## Per-slide font size Each output carries its spec entry as an
attribute (set by \[generate_outputs()\]). \`generate_slides()\` reads
two optional keys from it: \`table_format\` (a formatter function) and
\`font_size\` (a named list with \`body\`/\`header\`/\`footer\`). The
effective formatter for a slide is \`with_font_sizes(table_format, body,
header, footer)\`, so font sizes can be set per slide directly in the
spec, e.g.

    t_dm_slide_FAS:
      program: t_dm_slide
      suffix: FAS
      table_format: black_format_tb
      font_size:
        body: 6
        header: 6
        footer: 5

The \`font_size\` argument sets deck-wide defaults; per-slide values
win. When no footer size is supplied, the resolved body size is used,
falling back to 8 pt. This default is applied to the Confidential
footnote on every supported slide path, including \`decor = FALSE\`.

## Examples

``` r

# Example 1. When applying to the whole pipeline
library(dplyr)
data <- list(
  adsl = eg_adsl |> dplyr::mutate(FASFL = SAFFL),
  adae = eg_adae
)


filters::load_filters(
  yaml_file = system.file("filters.yml", package = "autoslider.core"),
  overwrite = TRUE
)


spec_file <- system.file("spec.yml", package = "autoslider.core")
spec_file |>
  read_spec() |>
  filter_spec(program %in% c("t_dm_slide")) |>
  generate_outputs(datasets = data) |>
  decorate_outputs() |>
  generate_slides()
#> ✔ 2/56 outputs matched the filter condition `program %in% c("t_dm_slide")`.
#> ❯ Running program `t_dm_slide` with suffix 'FAS'.
#> Filter 'FAS' matched target ADSL.
#> 400/400 records matched the filter condition `FASFL == 'Y'`.
#> ❯ Running program `t_dm_slide` with suffix 'FAS'.
#> Filter 'FAS' matched target ADSL.
#> 400/400 records matched the filter condition `FASFL == 'Y'`.
#> [1] " Patient Demographics and Baseline Characteristics, Full Analysis Set"
#> [1] " Patient Demographics and Baseline Characteristics, Full Analysis Set"

# Example 2. When applying to an rtable object or an rlisting object
adsl <- eg_adsl
t_dm_slide(adsl, "TRT01P", c("SEX", "AGE")) |>
  generate_slides()
#> [1] "Demographic slide"
```
