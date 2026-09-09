# Generating placeholder slides for your presentation

## Overview

This vignette shows how to add placeholder slides, including title
slides and section headers, to a PowerPoint presentation using
`autoslider.core`.

The main function for this is `append_all_slides`, which takes in a
structured `page_list` as input to define the slides you want to add.
This approach is ideal for quickly building a standardized presentation
from scratch.

## Generating a Deck with `append_all_slides`

The `append_all_slides` function automates adding multiple slides by
reading a `page_list` you provide. Each item in this list defines a
single slide’s properties.

Each slide definition in the `page_list` must be a list containing:

`type`: The kind of slide to add (“`title`” or “`section`”).

`to_page`: The page number where the slide should be inserted.

Content parameters:

For`type = "title"`, you need to provide a `study_id.`

For `type = "section"`, you need to provide a `section_title.`

## Example: Generating placeholder slides

Here’s a complete example. We’ll start with an empty presentation,
define a `page_list` for our slides, and then call `append_all_slides`
to generate the final deck and save it to a file.

[`library`](https://rdrr.io/r/base/library.html)`(`[`officer`](https://ardata-fr.github.io/officeverse/)`)`` `[`library`](https://rdrr.io/r/base/library.html)`(``tools``)`` `` ``# 1. Define a initial presentation file`` ``input`` ``<-`` ``"My_Presentation.pptx"`` `[`read_pptx`](https://davidgohel.github.io/officer/reference/read_pptx.html)`(``)`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)` `[`print`](https://rdrr.io/r/base/print.html)`(``target ``=`` ``input``)`` `` ``expected_output_file`` ``<-`` `[`file.path`](https://rdrr.io/r/base/file.path.html)`(`` `` `[`dirname`](https://rdrr.io/r/base/basename.html)`(``input``)``,`` `` `[`paste0`](https://rdrr.io/r/base/paste.html)`(`[`file_path_sans_ext`](https://rdrr.io/r/tools/fileutils.html)`(`[`basename`](https://rdrr.io/r/base/basename.html)`(``input``)``)``, ``"_final.pptx"``)`` ``)`` `` ``# 2. Define the presentation structure with a page_list`` ``my_page_list`` ``<-`` `[`list`](https://rdrr.io/r/base/list.html)`(`` `` `[`list`](https://rdrr.io/r/base/list.html)`(``type ``=`` ``"title"``, to_page ``=`` ``1``, study_id ``=`` ``"Project No.1"``)``,`` `` `[`list`](https://rdrr.io/r/base/list.html)`(``type ``=`` ``"section"``, to_page ``=`` ``2``, section_title ``=`` ``"Introduction"``)``,`` `` `[`list`](https://rdrr.io/r/base/list.html)`(``type ``=`` ``"section"``, to_page ``=`` ``3``, section_title ``=`` ``"Methodology"``)`` ``)`` `` ``# 3. Call append_all_slides to generate the deck`` ``# Set save_file = TRUE to write the result to a new file.`` ``` # If you have an existing pptx object to modify on, pass it into `doc_original`. ``` ``doc_result`` ``<-`` `[`append_all_slides`](https://pharmaverse.github.io/autoslider.core/reference/append_all_slides.md)`(`` `` doc_o ``=`` ``temp_pptx``,`` `` page_list ``=`` ``my_page_list``,`` `` doc_original ``=`` ``NULL``,`` `` save_file ``=`` ``TRUE`` ``)`` `` ``# 4. Verify the output`` `[`cat`](https://rdrr.io/r/base/cat.html)`(`[`paste`](https://rdrr.io/r/base/paste.html)`(``"Number of slides created:"``, `[`length`](https://rdrr.io/r/base/length.html)`(``doc_result``)``, ``"\n"``)``)`` `[`cat`](https://rdrr.io/r/base/cat.html)`(`[`paste`](https://rdrr.io/r/base/paste.html)`(``"Output file exists:"``, `[`file.exists`](https://rdrr.io/r/base/files.html)`(``expected_output_file``)``)``)`

This script produces a new PowerPoint file named
`My_Presentation_final.pptx`, containing the three slides defined in
`my_page_list.`

## Controlling slide text with metadata tokens

Rather than hard-coding study-level details (study number, data cut-off
date, …) into every slide, you can write `{token}` placeholders in the
slide text and let `autoslider.core` fill them in from a single,
user-controlled `metadata` list. This keeps values such as the study
number in *one* place instead of scattered across the deck.

A `metadata` list is a plain named list. You can define it inline, or
keep it in a small YAML file that you own and load with
[`yaml::read_yaml()`](https://yaml.r-lib.org/reference/read_yaml.html):

`metadata`` ``<-`` `[`list`](https://rdrr.io/r/base/list.html)`(``study ``=`` ``"BP12345"``, cutoff ``=`` ``"2026-01-15"``)`

Pass `metadata` to
[`append_all_slides()`](https://pharmaverse.github.io/autoslider.core/reference/append_all_slides.md)
and use `{token}` in `study_id` / `section_title`. Each `{token}` is
replaced with the matching value from `metadata`:

`my_page_list`` ``<-`` `[`list`](https://rdrr.io/r/base/list.html)`(`` `` `[`list`](https://rdrr.io/r/base/list.html)`(``type ``=`` ``"title"``, to_page ``=`` ``1``, study_id ``=`` ``"Study {study} "``)``,`` `` `[`list`](https://rdrr.io/r/base/list.html)`(``type ``=`` ``"section"``, to_page ``=`` ``2``, section_title ``=`` ``"Efficacy - Study {study}"``)``,`` `` `[`list`](https://rdrr.io/r/base/list.html)`(``type ``=`` ``"section"``, to_page ``=`` ``3``, section_title ``=`` ``"Data cut-off {cutoff}"``)`` ``)`` `` ``doc_result`` ``<-`` `[`append_all_slides`](https://pharmaverse.github.io/autoslider.core/reference/append_all_slides.md)`(`` `` doc_o ``=`` ``input``,`` `` page_list ``=`` ``my_page_list``,`` `` save_file ``=`` ``TRUE``,`` `` metadata ``=`` ``metadata`` ``)`

Here the section header reads *“Efficacy - Study BP12345”* on the
generated slide. The same `metadata` list also drives titles and
footnotes for tables, listings and graphs when passed to
[`read_spec()`](https://pharmaverse.github.io/autoslider.core/reference/read_spec.md)
(see
[`?read_spec`](https://pharmaverse.github.io/autoslider.core/reference/read_spec.md)),
so one list controls the text across the whole deck.

A few rules worth knowing:

- Tokens use `glue` syntax:
  [name](https://github.com/christopherkenny/name) is matched to the
  `name` element of `metadata`.
- An unknown token (e.g. a typo like `{studdy}`) raises an informative
  error rather than silently printing the literal text, so mistakes
  surface early.
- Text with no `{token}` and no `metadata` behaves exactly as before, so
  this feature is fully opt-in.

The underlying substitution is done by
[`apply_tokens()`](https://pharmaverse.github.io/autoslider.core/reference/apply_tokens.md),
which you can also call directly:

[`library`](https://rdrr.io/r/base/library.html)`(`[`autoslider.core`](https://github.com/pharmaverse/autoslider.core)`)`` ``#> Registered S3 method overwritten by 'tern':`` ``#> method from `` ``#> tidy.glm broom`` `[`apply_tokens`](https://pharmaverse.github.io/autoslider.core/reference/apply_tokens.md)`(``"Efficacy - Study {study}"``, `[`list`](https://rdrr.io/r/base/list.html)`(``study ``=`` ``"BP12345"``)``)`` ``#> Efficacy - Study BP12345`

### Notes

- `to_page` parameter: The function validates that it does not exceed
  the maximum possible slide position (number of slides + 1). After a
  slide is inserted at a specific page, all subsequent page numbers
  shift. Plan your `page_list` sequence accordingly.

- The functions are designed to work with standard `officer` layouts.
  They will fail if PowerPoint does not support the specified layouts
  (“Title and Content”, “Section Header”) and master theme (“Office
  Theme”).
