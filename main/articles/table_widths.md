# Controlling the width of data frame tables

## Overview

Data frame slides (the small tables made by `df_*` programs, for example
in dose-escalation decks) get their size from autoslider.core, not from
the PowerPoint theme. This guide shows how to control:

1.  the **width of the whole table** on the slide, and
2.  the **width of each column**.

Widths are in inches. A 16:9 slide is 13.33 in wide in `basic.pptx` and
10 in wide in the 10 x 5.625 in dose themes.

### How the width is set

When
[`generate_slides()`](https://pharmaverse.github.io/autoslider.core/reference/generate_slides.md)
turns a data frame into a table, it works in this order:

1.  **Size the columns.**
    - `dose_template = TRUE` (dose decks): each column is sized to its
      content
      ([`flextable::autofit()`](https://davidgohel.github.io/flextable/reference/autofit.html)),
      and the table is shrunk only if it is wider than 10 in
      (`flextable::fit_to_width(10)`). A small table stays small: it is
      **not** stretched to fill the slide or the placeholder.
    - `dose_template = FALSE` (the default): the columns take the widths
      in `col_width` (when given). If the table is then wider than 10
      in, all columns are scaled down to a total of 10.5 in.
2.  **Apply the table format** (`table_format`, e.g. `autoslider_format`
    or a study format).
3.  **Place the table** at `table_loc`. A placeholder location such as
    `officer::ph_location_label("Content Placeholder 2")` sets where the
    table goes, not how wide it is.

Two things follow from this order:

- `col_width` only has an effect when `dose_template = FALSE`.
- Anything the table format does to the widths comes **last**, so it
  always wins. A format function is therefore the way to control widths
  in a dose deck.

### Example data and a helper

\
[`library`](https://rdrr.io/r/base/library.html)`(`[`autoslider.core`](https://github.com/pharmaverse/autoslider.core)`)`\
\
`cohorts`` ``<-`` `[`data.frame`](https://rdrr.io/r/base/data.frame.html)`(`\
`  Cohort ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``"Cohort 1"``, ``"Cohort 2"``, ``"Cohort 3"``)``,`\
`  ``"IMP Dose"`` ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``"10 mg QW"``, ``"20 mg QW"``, ``"40 mg QW"``)``,`\
`  ``"No. pts dosed"`` ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``3``, ``3``, ``4``)``,`\
`  ``"DLT details"`` ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``"None"``, ``"Grade 3 rash in one patient"``, ``"None"``)``,`\
`  check.names ``=`` ``FALSE`\
`)`

The helper below reads the column widths of the table on the last slide
of a deck, so we can see what each setting does. It is only for this
guide; you do not need it in a study.

\
`slide_col_widths`` ``<-`` ``function``(``pptx``)`` ``{`\
`  ``dir`` ``<-`` `[`tempfile`](https://rdrr.io/r/base/tempfile.html)`(``)`\
`  ``utils``::`[`unzip`](https://rdrr.io/r/utils/unzip.html)`(``pptx``, exdir ``=`` ``dir``)`\
`  ``slides`` ``<-`` `[`list.files`](https://rdrr.io/r/base/list.files.html)`(`[`file.path`](https://rdrr.io/r/base/file.path.html)`(``dir``, ``"ppt"``, ``"slides"``)``, pattern ``=`` ``"^slide[0-9]+\\.xml$"``, full.names ``=`` ``TRUE``)`\
`  ``last`` ``<-`` ``slides``[`[`order`](https://rdrr.io/r/base/order.html)`(`[`as.integer`](https://rdrr.io/r/base/integer.html)`(`[`gsub`](https://rdrr.io/r/base/grep.html)`(``"\\D"``, ``""``, `[`basename`](https://rdrr.io/r/base/basename.html)`(``slides``)``)``)``)``]``[`[`length`](https://rdrr.io/r/base/length.html)`(``slides``)``]`\
`  ``cols`` ``<-`` ``xml2``::`[`xml_find_all`](http://xml2.r-lib.org/reference/xml_find_all.md)`(``xml2``::`[`read_xml`](http://xml2.r-lib.org/reference/read_xml.md)`(``last``)``, ``"//a:gridCol"``)`\
`  `[`round`](https://rdrr.io/r/base/Round.html)`(`[`as.numeric`](https://rdrr.io/r/base/numeric.html)`(``xml2``::`[`xml_attr`](http://xml2.r-lib.org/reference/xml_attr.md)`(``cols``, ``"w"``)``)`` ``/`` ``914400``, ``2``)`` ``# EMU to inches`\
`}`\
\
`make_slide`` ``<-`` ``function``(``...``, ``table_format`` ``=`` ``autoslider_dose_format``)`` ``{`\
`  ``out`` ``<-`` `[`tempfile`](https://rdrr.io/r/base/tempfile.html)`(``fileext ``=`` ``".pptx"``)`\
`  `[`generate_slides`](https://pharmaverse.github.io/autoslider.core/reference/generate_slides.md)`(`[`list`](https://rdrr.io/r/base/list.html)`(``cohorts ``=`` ``cohorts``)``, outfile ``=`` ``out``, table_format ``=`` ``table_format``, ``...``)`\
`  ``out`\
`}`

## Column widths

### Default: sized to the content

In a dose deck each column is as wide as its content needs:

\
`w`` ``<-`` ``slide_col_widths``(``make_slide``(``dose_template ``=`` ``TRUE``)``)`\
`w`\
`#> [1] 0.94 1.09 1.34 2.39`\
[`sum`](https://rdrr.io/r/base/sum.html)`(``w``)`\
`#> [1] 5.76`

### Set every column with `col_width`

Give one width per column. This needs `dose_template = FALSE`:

\
`slide_col_widths``(``make_slide``(``dose_template ``=`` ``FALSE``, col_width ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``1.2``, ``1.4``, ``1``, ``3``)``)``)`\
`#> [1] 1.2 1.4 1.0 3.0`

With `dose_template = TRUE`, `col_width` is ignored and the columns are
sized to their content again:

\
`slide_col_widths``(``make_slide``(``dose_template ``=`` ``TRUE``, col_width ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``1.2``, ``1.4``, ``1``, ``3``)``)``)`\
`#> [1] 0.94 1.09 1.34 2.39`

Note that `dose_template = FALSE` also builds the header from the data
frame’s variable labels (or the column names when there are none).

### Set some columns in a table format

To keep the dose layout and change just the columns you care about, set
their width in a table format. A format receives the slide’s font sizes
(`body_font_size`, `footer_font_size`, …) through `...`. Only pass `...`
on to a format that accepts them, such as
[`autoslider_format()`](https://pharmaverse.github.io/autoslider.core/reference/autoslider_format.md)
or a study format with those arguments;
[`autoslider_dose_format()`](https://pharmaverse.github.io/autoslider.core/reference/autoslider_format.md)
does not, so the examples here call it with `ft` alone.

Columns can be named or numbered:

\
`wide_dlt_format`` ``<-`` ``function``(``ft``, ``...``)`` ``{`\
`  ``ft`` ``<-`` `[`autoslider_dose_format`](https://pharmaverse.github.io/autoslider.core/reference/autoslider_format.md)`(``ft``)`\
`  ``flextable``::`[`width`](https://davidgohel.github.io/flextable/reference/width.html)`(``ft``, j ``=`` ``"DLT details"``, width ``=`` ``3.5``)`\
`}`\
\
`slide_col_widths``(``make_slide``(``dose_template ``=`` ``TRUE``, table_format ``=`` ``wide_dlt_format``)``)`\
`#> [1] 0.94 1.09 1.34 3.50`

Only the “DLT details” column changed; the others keep their content
width.

## Table width

### Shrink a wide table

[`flextable::fit_to_width()`](https://davidgohel.github.io/flextable/reference/fit_to_width.html)
scales the columns down so the table is at most `max_width` inches wide.
It never makes a table wider.

\
`narrow_format`` ``<-`` ``function``(``ft``, ``...``)`` ``{`\
`  ``ft`` ``<-`` `[`autoslider_dose_format`](https://pharmaverse.github.io/autoslider.core/reference/autoslider_format.md)`(``ft``)`\
`  ``flextable``::`[`fit_to_width`](https://davidgohel.github.io/flextable/reference/fit_to_width.html)`(``ft``, max_width ``=`` ``4``)`\
`}`\
\
`w`` ``<-`` ``slide_col_widths``(``make_slide``(``dose_template ``=`` ``TRUE``, table_format ``=`` ``narrow_format``)``)`\
`w`\
`#> [1] 0.60 0.70 0.94 1.53`\
[`sum`](https://rdrr.io/r/base/sum.html)`(``w``)`\
`#> [1] 3.77`

### Stretch a table to a set width

To make a small table fill the slide, scale all columns so they add up
to the width you want. The columns keep their relative sizes:

\
`table_width`` ``<-`` ``function``(``ft``, ``width``)`` ``{`\
`  ``widths`` ``<-`` ``flextable``::`[`flextable_dim`](https://davidgohel.github.io/flextable/reference/flextable_dim.html)`(``ft``)``$``widths`\
`  ``flextable``::`[`width`](https://davidgohel.github.io/flextable/reference/width.html)`(``ft``, width ``=`` `[`dim`](https://rdrr.io/r/base/dim.html)`(``ft``)``$``widths`` ``*`` ``width`` ``/`` ``widths``)`\
`}`\
\
`full_width_format`` ``<-`` ``function``(``ft``, ``...``)`` ``{`\
`  ``ft`` ``<-`` `[`autoslider_dose_format`](https://pharmaverse.github.io/autoslider.core/reference/autoslider_format.md)`(``ft``)`\
`  `[`table_width`](https://davidgohel.github.io/officer/reference/table_width.html)`(``ft``, width ``=`` ``9``)`\
`}`\
\
`w`` ``<-`` ``slide_col_widths``(``make_slide``(``dose_template ``=`` ``TRUE``, table_format ``=`` ``full_width_format``)``)`\
`w`\
`#> [1] 1.47 1.71 2.09 3.73`\
[`sum`](https://rdrr.io/r/base/sum.html)`(``w``)`\
`#> [1] 9`

On a 10 in dose slide, 9 in leaves a 0.5 in margin each side when the
table starts 0.5 in from the left edge.

### Fixed widths for every column

A format can also give every column a fixed width. The number of widths
must match the number of columns, so this only suits a format used by
one table:

\
`cohort_table_format`` ``<-`` ``function``(``ft``, ``...``)`` ``{`\
`  ``ft`` ``<-`` `[`autoslider_dose_format`](https://pharmaverse.github.io/autoslider.core/reference/autoslider_format.md)`(``ft``)`\
`  ``flextable``::`[`width`](https://davidgohel.github.io/flextable/reference/width.html)`(``ft``, width ``=`` `[`c`](https://rdrr.io/r/base/c.html)`(``1.2``, ``1.4``, ``1``, ``4.5``)``)`\
`}`\
\
`slide_col_widths``(``make_slide``(``dose_template ``=`` ``TRUE``, table_format ``=`` ``cohort_table_format``)``)`\
`#> [1] 1.2 1.4 1.0 4.5`

## Using this in a dose speclayout

Put the format functions in the study’s `R/formats.R` (which
`run_slides.R` sources), then name them per slide in
`dose_speclayout.yml`. Keep the font-size arguments so a per-slide
`font_size:` block still reaches the format:

\
`# R/formats.R`\
`full_width_gred`` ``<-`` ``function``(``ft``, ``body_font_size`` ``=`` ``8``, ``header_font_size`` ``=`` ``8``, ``...``)`` ``{`\
`  ``ft`` ``<-`` ``black_format_gred``(``ft``, body_font_size ``=`` ``body_font_size``, header_font_size ``=`` ``header_font_size``, ``...``)`\
`  ``widths`` ``<-`` ``flextable``::`[`flextable_dim`](https://davidgohel.github.io/flextable/reference/flextable_dim.html)`(``ft``)``$``widths`\
`  ``flextable``::`[`width`](https://davidgohel.github.io/flextable/reference/width.html)`(``ft``, width ``=`` `[`dim`](https://rdrr.io/r/base/dim.html)`(``ft``)``$``widths`` ``*`` ``9`` ``/`` ``widths``)`\
`}`

``` yaml
# Stretch this table to 9 in.
df_all_cohorts_demo1_DM:
  program: df_all_cohorts_demo1
  suffix: DM
  table_format: full_width_gred
  table_loc: officer::ph_location_label("Content Placeholder 2")

# Or set the column widths directly, without the dose layout.
df_patient_overview_slide_DM:
  program: df_patient_overview_slide
  suffix: DM
  dose_template: FALSE
  col_width: c(0.8, 0.8, 1.2, 1.5, 1, 1, 2)
```

Values in a dose speclayout are evaluated as R code, so `col_width` is
written as `c(...)`.

## Summary

| Goal | Dose deck (`dose_template = TRUE`) | `dose_template = FALSE` |
|----|----|----|
| Widths of all columns | Table format: `flextable::width(ft, width = c(...))` | `col_width = c(...)` |
| Width of one column | Table format: `flextable::width(ft, j = "name", width = )` | Table format, as for dose decks |
| Shrink the table to a maximum | Table format: `flextable::fit_to_width(ft, max_width = )` (wider than 10 in is shrunk automatically) | Automatic above 10 in (scaled to 10.5 in) |
| Stretch the table to a width | Table format: scale `dim(ft)$widths` to the total you want | Same, or choose `col_width` to add up to it |

Table position comes from `table_loc`; width comes from the steps above.
See also
[`vignette("using_formats")`](https://pharmaverse.github.io/autoslider.core/articles/using_formats.md)
for colors, fonts and borders.
