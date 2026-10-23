# Placeholder layout roles

Returns the lookup that maps each layout \*role\* used by placeholder
slides (such as \`section\`) to a template layout and the placeholders
it fills.

## Usage

``` r
placeholder_layouts(
  overrides = getOption(option, list()),
  defaults = placeholder_layout_defaults(),
  option = "autoslider.core.placeholder_layouts"
)
```

## Arguments

- overrides:

  A named \`list\` of role overrides. Defaults to the option named by
  \`option\`.

- defaults:

  The roles to start from.

- option:

  Name of the option holding session-wide overrides.

## Value

A named \`list\` of roles.

## Details

Each role is a \`list\` with: \* \`layout\`, \`master\`: the template
layout to add the slide on. \* \`labels\`: field name to placeholder
label (\`ph_label\` in \[officer::layout_properties()\]), and/or \*
\`types\`: field name to placeholder type (\`type\` in
\[officer::layout_properties()\], e.g. \`"title"\`, \`"body"\`). A label
wins over a type for the same field. \* \`fallbacks\`: field name to
another field. Text for a field the layout has no placeholder for is
added to the other field, before its own text. The default \`section\`
role (the "Section Header" layout has a title and a text box, but no
subtitle) sends \`subtitle\` to \`text\`, so a speclayout written for a
template with a subtitle still renders without losing text.

Overrides are merged per role, and \`labels\`, \`types\` and
\`fallbacks\` per field, so changing one layout name or one label keeps
everything else. New roles can be added the same way.

## See also

\[validate_placeholder_layouts()\], \[append_section_slides()\]

## Examples

``` r
placeholder_layouts()$section
#> $layout
#> [1] "Section Header"
#> 
#> $master
#> [1] "Office Theme"
#> 
#> $types
#> $types$title
#> [1] "title"
#> 
#> $types$text
#> [1] "body"
#> 
#> 
#> $fallbacks
#> $fallbacks$subtitle
#> [1] "text"
#> 
#> 

# A template whose divider layout is called "Chapter divider"
placeholder_layouts(list(section = list(layout = "Chapter divider")))$section$layout
#> [1] "Chapter divider"
```
