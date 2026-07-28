# decorate gtsummary

decorate gtsummary

## Usage

``` r
# S3 method for class 'gtsummary'
decorate(x, titles = "", footnotes = "", paper = "L11", for_test = FALSE, ...)
```

## Arguments

- x:

  gtsummary object to decorate

- titles:

  graph titles

- footnotes:

  graph footnotes

- paper:

  paper size. default is "L8".

- for_test:

  \`logic\` CICD parameter

- ...:

  Additional arguments. not used.

## Value

No return value, called for side effects

## Details

The paper default paper size, \`L11\`, indicate that the fontsize is 11.
The fontsize of the footnotes, is the fontsize of the titles minus 2.#'
