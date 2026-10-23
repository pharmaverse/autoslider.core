# Import slide layouts from another PowerPoint template

Copies one or more slide layouts, together with the images they use,
from \`source\` into \`target\` and writes the result to \`outfile\`.
This builds a mixed template: content slides keep the study theme's own
layouts, and placeholder pages can use layouts that only exist in
another template, such as a corporate theme with cover and divider
layouts.

## Usage

``` r
import_layouts(
  target,
  source,
  layouts,
  outfile = tempfile(fileext = ".pptx"),
  master = NULL
)
```

## Arguments

- target:

  Path to the template to extend (it is not modified).

- source:

  Path to the template holding the layouts to copy.

- layouts:

  Character vector of layout names to copy from \`source\`.

- outfile:

  Path of the \`.pptx\` to write. Defaults to a temporary file.

- master:

  Optional name of the master in \`target\` to attach the layouts to. By
  default each layout goes to the target master with the same name as
  its source master.

## Value

The path to \`outfile\`, invisibly.

## Details

Each imported layout is attached to the master in \`target\` with the
same name as its master in \`source\`, or to \`master\` when given. The
layout keeps its own shapes, placeholders and images; theme colors and
fonts come from the target master. Layouts that \`target\` already has
are skipped, so the call is safe to repeat.

Masters are not copied: a layout whose master is missing from \`target\`
raises an error unless \`master\` names a master that \`target\` does
have.

## See also

\[place_speclayout_placeholders()\]

## Examples

``` r
# \donttest{
# officer's default template lacks the "Content with Caption" layout that
# autoslider.core's basic.pptx has; both use the "Office Theme" master.
mixed <- import_layouts(
  target = system.file("template/template.pptx", package = "officer"),
  source = system.file("theme/basic.pptx", package = "autoslider.core"),
  layouts = "Content with Caption"
)
officer::layout_summary(officer::read_pptx(mixed))
#>                 layout       master
#> 1          Title Slide Office Theme
#> 2    Title and Content Office Theme
#> 3       Section Header Office Theme
#> 4          Two Content Office Theme
#> 5           Comparison Office Theme
#> 6           Title Only Office Theme
#> 7                Blank Office Theme
#> 8 Content with Caption Office Theme
# }
```
