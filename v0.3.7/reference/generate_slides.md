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
  fig_margin = 0.25,
  fig_format = c("svg", "png"),
  fig_dpi = 300,
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

- fig_width, fig_height:

  Figure width and height in inches. They set the figure's shape: the
  figure is scaled, keeping that shape, to fill the free area of the
  slide (below the title, above any footer the slide writes) inside a
  margin of `fig_margin`, and centered there. Text in the plot keeps its
  point size, because the plot is drawn at the scaled size.

- t_lpp:

  An integer specifying the table lines per page\
  Specify this optional argument to modify the length of all of the
  table displays. Defaults to `NULL`, which auto-fits the table to the
  slide height (for rtables, via
  [`rtables::paginate_table()`](https://insightsengineering.github.io/rtables/latest-tag/reference/paginate.html);
  for gtsummary, via a row-height estimate). Overridden for an
  individual slide by an `lpp` field on its spec entry.

- t_cpp:

  An integer specifying the table columns per page\
  Specify this optional argument to modify the width of all of the table
  displays. Only honored for rtables output; gtsummary tables do not
  support column pagination and are instead scaled down to fit when too
  wide. Explicitly setting `t_cpp` also raises a warning for gtsummary
  tables that need scaling, since column pagination was requested but
  cannot be applied. Overridden for an individual slide by a `cpp` field
  on its spec entry.

- l_lpp:

  An integer specifying the listing lines per page\
  Specify this optional argument to modify the length of all of the
  listings display. Overridden for an individual slide by an `lpp` field
  on its spec entry.

- l_cpp:

  An integer specifying the listing columns per page\
  Specify this optional argument to modify the width of all of the
  listings display. Overridden for an individual slide by a `cpp` field
  on its spec entry.

- fig_editable:

  whether we want the figure to be editable in pptx viewers, defaults to
  FALSE

- font_size:

  Deck-wide default table font sizes, a named `list` with any of `body`,
  `header`, `footer` (point sizes). Per-slide sizes declared in the spec
  (a `font_size:` block on the entry) override these. Applied by
  wrapping the slide's `table_format` via
  [`with_font_sizes()`](https://pharmaverse.github.io/autoslider.core/reference/with_font_sizes.md).
  The footer defaults to the body size, or 8 pt when no body size is
  supplied; see Details.

- fig_margin:

  Margin in inches kept free on every side of a figure, to the slide
  edges and to the title and footer.

- fig_format:

  Image format for figures that are not editable: `"svg"` (the default)
  or `"png"`. PNG shows in every viewer, including Google Slides, which
  does not display SVG.

- fig_dpi:

  Resolution of PNG figures.

- ...:

  arguments passed to program

## Value

No return value, called for side effects

## Details

### Per-slide font size

Each output carries its spec entry as an attribute (set by
[`generate_outputs()`](https://pharmaverse.github.io/autoslider.core/reference/generate_outputs.md)).
`generate_slides()` reads two optional keys from it: `table_format` (a
formatter function) and `font_size` (a named list with
`body`/`header`/`footer`). The effective formatter for a slide is
`with_font_sizes(table_format, body, header, footer)`, so font sizes can
be set per slide directly in the spec, e.g.

    t_dm_slide_FAS:
      program: t_dm_slide
      suffix: FAS
      table_format: black_format_tb
      font_size:
        body: 6
        header: 6
        footer: 5

The `font_size` argument sets deck-wide defaults; per-slide values win.
When no footer size is supplied, the resolved body size is used, falling
back to 8 pt. This default is applied to the Confidential footnote on
every supported slide path, including `decor = FALSE`.

#### Per-slide pagination

Pagination density is resolved the same way. A spec entry may carry an
optional `lpp` (lines per page) and `cpp` (columns per page). When
present they override the deck-wide `t_lpp`/`t_cpp` (tables) or
`l_lpp`/`l_cpp` (listings) for that slide only, so a short demographics
table and a long adverse-event table can use different densities in the
same deck:

    t_dm_slide_FAS:
      program: t_dm_slide
      suffix: FAS
      lpp: 30
      cpp: 180

Entries without these fields keep the deck-wide value. Each must be a
single positive whole number; anything else is an error naming the
offending entry.

Note that pagination for `gtsummary` tables is recomputed from the slide
height, so a spec `lpp` does not change their pagination.

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
#> ✔ 2/59 outputs matched the filter condition `program %in% c("t_dm_slide")`.
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
