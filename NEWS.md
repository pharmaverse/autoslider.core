# autoslider.core 0.3.4.9000

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
