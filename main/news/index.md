# Changelog

## autoslider.core 0.3.3.9000

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
