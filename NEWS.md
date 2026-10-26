# autoslider.core 0.3.6.7

 * Figures are now placed to fit the slide (#143). Before, a figure was always
   `fig_width` x `fig_height` (9 x 5 in) and centered on a slide 17% taller than the
   real one, so on 10 x 5.625 in templates it ran off the bottom and could overlap
   the title. The figure is now scaled, keeping the shape of `fig_width` x
   `fig_height`, to fill the area below the title and above any footer the slide
   writes, with an even margin (new `fig_margin`, default 0.25 in), and centered
   there; it is drawn at that size, so plot text keeps its point size. New
   `fig_format = "png"` (with `fig_dpi`) embeds a PNG instead of an SVG, for viewers
   such as Google Slides; `ph_with_img()` gains the same two arguments. A study
   replacement of `ph_with_img()` with the older five arguments keeps working and
   receives the fitted size and position.
 * Placeholder slides (section dividers, cover and other non-TLG pages) can now be
   declared in a speclayout and placed by their order among the TLG entries with
   `place_speclayout_placeholders()`; no page numbers need to be typed. Built-in
   types are `section` (new `append_section_slides()`), `title` and `custom`
   (new `append_custom_slides()`, any layout, placeholders by label). On
   `basic.pptx`, `section` uses the "Section Header" layout, which has a title and
   a text box but no subtitle: a `subtitle` goes into the text box, before `text`.
   Text may contain `{token}`s filled from `metadata`. Layout roles
   (`placeholder_layouts()`, `validate_placeholder_layouts()`) and slide types
   (`placeholder_types()`) can be extended per call or through the
   `autoslider.core.placeholder_layouts` / `autoslider.core.placeholder_types`
   options, and `append_placeholder_slides()` / `placeholder_slide()` are the
   building blocks for new types. `import_layouts()` copies layouts between
   templates. Adds `xml2` and `zip` to Imports. Moved from autoslideR.
 * `generate_slides()` no longer fails with "formal argument \"lpp\" matched by
   multiple actual arguments" when `lpp`/`cpp` reach it both through a spec entry and
   as an argument (as study scripts that pass every spec key to `generate_slides()`
   do). The spec value still wins; an `lpp`/`cpp` passed only as an argument now
   acts as a per-call default instead of raising an error.
 * A program that fails with an rlang/cli-style error (e.g. a dplyr/tidyselect
   "Can't select columns that don't exist") no longer aborts `generate_outputs()`.
   These errors leave `e$message` empty, which made `autoslider_error()` fail
   inside the error handler; the handler now uses `conditionMessage()`, so the
   output becomes an `autoslider_error` with the full message and the remaining
   outputs still run. `generate_slides()` now also accepts a single failed
   output on its own (reporting and skipping it, as it does inside a list).
 * The "; " separator that flextable adds after an inline footnote now uses the
   same font size as the footnote text. Previously only the text was resized, so
   with a small `font_size$footer` the semicolon showed at the larger table
   default size.

# autoslider.core 0.3.5

 * Minor bug fixing in `tlg_template.R`.

# autoslider.core 0.3.4

 * Per-slide pagination: a spec entry may now carry an optional `lpp:` (lines per
   page) and `cpp:` (columns per page), overriding the deck-wide `t_lpp`/`t_cpp`
   (tables) and `l_lpp`/`l_cpp` (listings) arguments of `generate_slides()` for
   that slide only, so a short table and a long one can use different densities
   in the same deck. Entries without the fields are unchanged. Note that the
   gtsummary path still recomputes `lpp` from the slide height (#121), so a spec
   `lpp` does not yet affect it (#126).
 * Confidential footnotes now render at 8 pt by default, or follow the resolved
   body size when one is supplied. The size is applied on both the decorated
   and `decor = FALSE` slide paths, so no PPTX/XML post-processing is needed.
 * `with_font_sizes()` now forwards additional formatter arguments supplied by
   its caller.
 * Added `t_mh_slide()` integration and a reproducibly generated synthetic
   `eg_admh` example dataset for medical-history summaries.
 * Added `add_ai_story()` (and an `add_ai_story` MCP tool): a post-processing step
   that reads a generated `.pptx`, asks an LLM to tell the story of the tables, and
   inserts real content slides -- a summary section at the front and a conclusions
   section at the end -- instead of hidden speaker notes. `get_ai_story()` and
   `add_story_slides()` expose the LLM call and the (network-free) slide insertion
   separately. `get_ellmer_chat()` now also supports the `"anthropic"` platform.
   `get_ai_story()` falls back to plain-text JSON mode for providers that do not
   support native structured output (e.g. DeepSeek).
 * Per-slide font sizes: `generate_slides()` now reads an optional `font_size:`
   block (`body`/`header`/`footer`) and `table_format` from each output's spec
   entry, and a deck-wide `font_size` argument. Sizes are applied via the new
   exported `with_font_sizes()` helper, which injects sizes into any table
   formatter (only forwarding sizes the formatter accepts).
 * `autoslider_format()` and `black_format_tb()` gain a `footer_font_size`
   argument.
 * `to_flextable.data.frame()`: `font_size` now defaults to `NULL` and the
   uniform font override is only applied when it is explicitly set, so font
   sizes coming from `table_format` are no longer overwritten. Note: plain
   data-frame slides that previously rendered at the hard-coded 9pt now follow
   the sizes from `table_format` unless `font_size` is supplied.
 * Added `apply_tokens()` to substitute `{token}` placeholders (e.g. `{study}`) in titles, footnotes and placeholder slides with values from a user-controlled `metadata` list, so study-level text can be driven from metadata instead of edited in the deck.
 * Added `read_metadata()` and an example `metadata.yml` (`system.file("metadata.yml", package = "autoslider.core")`) so `{token}` values can be kept in a yaml file. `read_spec()` now also accepts a metadata file path for its `metadata` argument and reads it for you, e.g. `read_spec("spec.yml", metadata = "metadata.yml")`.

# autoslider.core 0.3.3

 * Adding mcp server.
 * Fix gtsummary code, now supports NEST 2.0.

# autoslider.core 0.3.2

 * Update dependency version.

# autoslider.core 0.3.1

 * Fix vignette builder.

# autoslider.core 0.3.0

 * Fix layout, adding assertion.

# autoslider.core 0.2.9

 * Dependency version bump for `officer` version 0.7.0.

# autoslider.core 0.2.8

 * Renamed AI functionality from footnotes to speaker notes in documentation and function references.
 * Added CRAN test skips to reduce test execution time.
 * Removed `styler` from suggests.

# autoslider.core 0.2.7

 * Revert `officer` dependency on function `layout_default`.
 * Realign table to the slide centre.
 * Remove thinking messages.

# autoslider.core 0.2.6

 * Added support for custom templates via symbolic links in `inst/templates/`.
 * Added vignette `tlg_templates` , `adding_templates`, `use_LLM`, and `using_format`.
 * Added support for `use_templates` for specified packages.
 * Added support for adding placeholder slides (e.g. title, section headers) using `append_all_slides()`
 * Enabled function generation from templates.
 * Enabled automatic plot title generation.
 * Split out specific plot functions (e.g., `g_vs_slide`) from `g_mean_general() `.
 * Integrated AI insights to data analytics, written detailed instructions in vignette `use_LLM`.
 * Provided the option of making plots editable or fixed on generated slides.
 * Fixed ggplot graphs location and size on generated slides.
 
 
 
# autoslider.core 0.2.5

 * Dropping dependencies level.
 * Adding `ellmer` dependency, enable AI prompt.
 * Bug fix in side by side plot rendering.
 * Code enhancement when using `split_rows_by` and `analysis` on the same variable multiple times, enhancing the table paths. Upstream enhancement from `rtables`.

# autoslider.core 0.2.4.433

### Miscellaneous

 * Align upstream packages (formatters/rtables/rlistings/tern) to the latest releases. 
 * Allow structured header for side-by-side tables.
 * Fixed bugs in decoration. 
 * Support gtsummary.
 * Support slides creation from rds files.

# autoslider.core 0.2.3

### Miscellaneous

 * Align upstream packages (formatters/rtables/rlistings/tern) to the latest releases. 

# autoslider.core 0.2.2

### Miscellaneous
 
 * Plots in slides are now editable.
 * Keep indentation in tables.
 * Added vignette for open-sourcing.

# autoslider.core 0.2.1

### Miscellaneous

 * Trim `l_ae_slide` example.

# autoslider.core 0.2.0

### New features
 
 * Added new templates `g_lb_slide`, `g_eg_slide`, `g_vs_slide`, `l_ae_slide` and `t_ds_slide`.

### Miscellaneous
 
 * Added vignette
 * Improved test coverage

# autoslider.core 0.1.0

### Miscellaneous
 * First release.
