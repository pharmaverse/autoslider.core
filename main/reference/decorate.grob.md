# decorate grob

decorate grob

## Usage

``` r
# S3 method for class 'grob'
decorate(
  x,
  titles = "",
  footnotes = "",
  paper = "L11",
  for_test = FALSE,
  metadata = NULL,
  ...
)
```

## Arguments

- x:

  object to decorate

- titles:

  graph titles

- footnotes:

  graph footnotes

- paper:

  paper size. default is "L8".

- for_test:

  \`logic\` CICD parameter

- metadata:

  Named \`list\` (or \`NULL\`) of token values used to substitute
  \`token\` placeholders in \`titles\`/\`footnotes\`. See
  \[apply_tokens()\].

- ...:

  Additional arguments. not used.

## Value

No return value, called for side effects

## Details

The paper default paper size, \`L11\`, indicate that the fontsize is 11.
The fontsize of the footnotes, is the fontsize of the titles minus 2.
