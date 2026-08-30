# \[EXPERIMENTAL\] Create new output function based on a template.

We have separate templates for listings, tables, and graphs. There is
also a template to set up the \`run_all\` script.

## Usage

``` r
use_template(
  template = "t_dm_slide",
  function_name = "default",
  save_path = "./programs/R",
  overwrite = FALSE,
  open = interactive(),
  package = "autoslider.core"
)
```

## Arguments

- template:

  Must be one of \`list_all_templates(package = "autoslider.core")\`.

- function_name:

  Name of the output function you want to create. Defaults to "default".

- save_path:

  Path to save the function. Defaults to "./programs/R".

- overwrite:

  Whether to overwrite an existing file.

- open:

  Whether to open the file after creation.

- package:

  Which package to search for the template file. Defaults to
  "autoslider.core".

## Value

No return value. Called for side effects (writes a file).

## Details

Use \`list_all_templates(package = "autoslider.core")\` to discover
which templates are available.

## Examples

``` r
if (interactive()) {
  use_template("t_dm_slide", function_name = "my_table", package = "autoslider.core")
}
```
