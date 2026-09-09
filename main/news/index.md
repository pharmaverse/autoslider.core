# Changelog

## autoslider.core 0.3.3.9003

- Added
  [`add_ai_story()`](https://pharmaverse.github.io/autoslider.core/reference/add_ai_story.md)
  (and an `add_ai_story` MCP tool): a post-processing step that reads a
  generated `.pptx`, asks an LLM to tell the story of the tables, and
  inserts real content slides – a summary section at the front and a
  conclusions section at the end – instead of hidden speaker notes.
  [`get_ai_story()`](https://pharmaverse.github.io/autoslider.core/reference/get_ai_story.md)
  and
  [`add_story_slides()`](https://pharmaverse.github.io/autoslider.core/reference/add_story_slides.md)
  expose the LLM call and the (network-free) slide insertion separately.
  [`get_ellmer_chat()`](https://pharmaverse.github.io/autoslider.core/reference/get_ellmer_chat.md)
  now also supports the `"anthropic"` platform.
  [`get_ai_story()`](https://pharmaverse.github.io/autoslider.core/reference/get_ai_story.md)
  falls back to plain-text JSON mode for providers that do not support
  native structured output (e.g. DeepSeek).
- Per-slide font sizes:
  [`generate_slides()`](https://pharmaverse.github.io/autoslider.core/reference/generate_slides.md)
  now reads an optional `font_size:` block (`body`/`header`/`footer`)
  and `table_format` from each output’s spec entry, and a deck-wide
  `font_size` argument. Sizes are applied via the new exported
  [`with_font_sizes()`](https://pharmaverse.github.io/autoslider.core/reference/with_font_sizes.md)
  helper, which injects sizes into any table formatter (only forwarding
  sizes the formatter accepts).
- [`autoslider_format()`](https://pharmaverse.github.io/autoslider.core/reference/autoslider_format.md)
  and
  [`black_format_tb()`](https://pharmaverse.github.io/autoslider.core/reference/autoslider_format.md)
  gain a `footer_font_size` argument.
- [`to_flextable.data.frame()`](https://pharmaverse.github.io/autoslider.core/reference/to_flextable.data.frame.md):
  `font_size` now defaults to `NULL` and the uniform font override is
  only applied when it is explicitly set, so font sizes coming from
  `table_format` are no longer overwritten. Note: plain data-frame
  slides that previously rendered at the hard-coded 9pt now follow the
  sizes from `table_format` unless `font_size` is supplied.
- Added
  [`apply_tokens()`](https://pharmaverse.github.io/autoslider.core/reference/apply_tokens.md)
  to substitute `{token}` placeholders (e.g. `{study}`) in titles,
  footnotes and placeholder slides with values from a user-controlled
  `metadata` list, so study-level text can be driven from metadata
  instead of edited in the deck.
- Added
  [`read_metadata()`](https://pharmaverse.github.io/autoslider.core/reference/read_metadata.md)
  and an example `metadata.yml`
  (`system.file("metadata.yml", package = "autoslider.core")`) so
  `{token}` values can be kept in a yaml file.
  [`read_spec()`](https://pharmaverse.github.io/autoslider.core/reference/read_spec.md)
  now also accepts a metadata file path for its `metadata` argument and
  reads it for you,
  e.g. `read_spec("spec.yml", metadata = "metadata.yml")`.

## autoslider.core 0.3.3

CRAN release: 2026-08-29

- Adding mcp server.
- Fix gtsummary code, now supports NEST 2.0.

## autoslider.core 0.3.2

CRAN release: 2026-01-12

- Update dependency version.

## autoslider.core 0.3.1

CRAN release: 2025-09-25

- Fix vignette builder.

## autoslider.core 0.3.0

- Fix layout, adding assertion.

## autoslider.core 0.2.9

- Dependency version bump for `officer` version 0.7.0.

## autoslider.core 0.2.8

CRAN release: 2025-08-25

- Renamed AI functionality from footnotes to speaker notes in
  documentation and function references.
- Added CRAN test skips to reduce test execution time.
- Removed `styler` from suggests.

## autoslider.core 0.2.7

CRAN release: 2025-07-25

- Revert `officer` dependency on function `layout_default`.
- Realign table to the slide centre.
- Remove thinking messages.

## autoslider.core 0.2.6

CRAN release: 2025-07-22

- Added support for custom templates via symbolic links in
  `inst/templates/`.
- Added vignette `tlg_templates` , `adding_templates`, `use_LLM`, and
  `using_format`.
- Added support for `use_templates` for specified packages.
- Added support for adding placeholder slides (e.g. title, section
  headers) using
  [`append_all_slides()`](https://pharmaverse.github.io/autoslider.core/reference/append_all_slides.md)
- Enabled function generation from templates.
- Enabled automatic plot title generation.
- Split out specific plot functions (e.g., `g_vs_slide`) from
  [`g_mean_general()`](https://pharmaverse.github.io/autoslider.core/reference/g_mean_general.md).
- Integrated AI insights to data analytics, written detailed
  instructions in vignette `use_LLM`.
- Provided the option of making plots editable or fixed on generated
  slides.
- Fixed ggplot graphs location and size on generated slides.

## autoslider.core 0.2.5

CRAN release: 2025-06-13

- Dropping dependencies level.
- Adding `ellmer` dependency, enable AI prompt.
- Bug fix in side by side plot rendering.
- Code enhancement when using `split_rows_by` and `analysis` on the same
  variable multiple times, enhancing the table paths. Upstream
  enhancement from `rtables`.

## autoslider.core 0.2.4.433

#### Miscellaneous

- Align upstream packages (formatters/rtables/rlistings/tern) to the
  latest releases.
- Allow structured header for side-by-side tables.
- Fixed bugs in decoration.
- Support gtsummary.
- Support slides creation from rds files.

## autoslider.core 0.2.3

CRAN release: 2025-01-17

#### Miscellaneous

- Align upstream packages (formatters/rtables/rlistings/tern) to the
  latest releases.

## autoslider.core 0.2.2

CRAN release: 2025-01-08

#### Miscellaneous

- Plots in slides are now editable.
- Keep indentation in tables.
- Added vignette for open-sourcing.

## autoslider.core 0.2.1

CRAN release: 2024-12-23

#### Miscellaneous

- Trim `l_ae_slide` example.

## autoslider.core 0.2.0

#### New features

- Added new templates `g_lb_slide`, `g_eg_slide`, `g_vs_slide`,
  `l_ae_slide` and `t_ds_slide`.

#### Miscellaneous

- Added vignette
- Improved test coverage

## autoslider.core 0.1.0

CRAN release: 2024-11-27

#### Miscellaneous

- First release.
