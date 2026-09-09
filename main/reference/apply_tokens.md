# Substitute metadata tokens in text

Replaces \`glue\`-style \`token\` placeholders in a character vector
with values taken from a user-controlled \`metadata\` list. This lets
study-level information (e.g. study number, data cut-off date) be
injected into slide titles, footnotes and placeholder slides without
editing the deck or the spec text directly.

## Usage

``` r
apply_tokens(text, metadata = NULL)
```

## Arguments

- text:

  \`character\` vector possibly containing \`token\` placeholders.

- metadata:

  Named \`list\` (or \`NULL\`) supplying token values. Typically the
  spec entry produced by \[read_spec()\], into which the \`metadata\`
  argument has already been merged.

## Value

A length-one \`character\` (\`glue\`) value with tokens substituted and
the input collapsed by newlines, matching the previous \`glue::glue()\`
behavior.

## Details

Token values are looked up first in \`metadata\`, then in the calling
environment (preserving the existing \`glue\` behavior used across
\`decorate\` methods). A \`token\` that resolves to neither raises an
informative error, so typos are caught early rather than silently
producing a broken slide.

## Examples

``` r
apply_tokens("Demographics - Study {study}", list(study = "BP12345"))
#> Demographics - Study BP12345
apply_tokens(c("Line 1 {study}", "Line 2"), list(study = "BP12345"))
#> Line 1 BP12345
#> Line 2
```
