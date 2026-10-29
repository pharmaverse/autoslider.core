# Placeholder slide types

Maps each placeholder `type:` used in a speclayout to the function that
inserts it (`fn`), the number of slides it adds (`n`, used to place
later slides) and the layout roles it uses (`roles`, checked before any
slide is inserted).

## Usage

``` r
placeholder_types(
  extra = getOption(option, list()),
  builtin = placeholder_type_defaults(),
  option = "autoslider.core.placeholder_types"
)
```

## Arguments

- extra:

  A named `list` of additional types. Defaults to the option named by
  `option`.

- builtin:

  The types to start from.

- option:

  Name of the option holding session-wide types.

## Value

A named `list` of types, each `list(fn, n, roles)`.

## Details

Add types for a session through the option named by `option`, or pass
them as `extra`. Each entry is a function or
`list(fn = , n = , roles = )`; `n` defaults to 1. The function must
accept `doc_o`, `doc_original`, `to_page` and `save_file`, and return
the `officer::rpptx` object. Other fields of the speclayout entry are
passed on when the function has an argument of that name, as are
`layouts` and `metadata`. A type with the same name as a built-in one
replaces it.

## Examples

``` r
names(placeholder_types())
#> [1] "section" "title"   "custom" 

# A study type that adds two section slides
two_sections <- function(doc_o, label = "Part", to_page = NA, doc_original = NULL, save_file = FALSE) {
  append_placeholder_slides(doc_o, list(
    placeholder_slide("section", title = paste(label, "A")),
    placeholder_slide("section", title = paste(label, "B"))
  ), to_page = to_page, doc_original = doc_original, save_file = save_file)
}
names(placeholder_types(list(two_sections = list(fn = two_sections, n = 2, roles = "section"))))
#> [1] "section"      "title"        "custom"       "two_sections"
```
