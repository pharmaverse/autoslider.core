# Check that a template has the layouts and placeholders of some roles

Confirms every requested role resolves to a layout that exists in the
template, and that each placeholder label or type the role writes into
exists in that layout. Problems are reported together, with the layouts
the template does have, before any slide is added.

## Usage

``` r
validate_placeholder_layouts(
  x,
  roles = names(layouts),
  layouts = placeholder_layouts()
)
```

## Arguments

- x:

  An `officer::rpptx` object or a path to a `.pptx` file.

- roles:

  Roles to check. Defaults to all roles in `layouts`.

- layouts:

  The role lookup, see
  [`placeholder_layouts()`](https://pharmaverse.github.io/autoslider.core/reference/placeholder_layouts.md).

## Value

Invisibly `TRUE`; otherwise an error.

## Examples

``` r
validate_placeholder_layouts(system.file("theme/basic.pptx", package = "autoslider.core"))
```
