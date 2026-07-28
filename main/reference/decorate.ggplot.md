# Decorate ggplot object

Decorate ggplot object

## Usage

``` r
# S3 method for class 'ggplot'
decorate(x, titles = "", footnotes = "", paper = "L11", for_test = FALSE, ...)
```

## Arguments

- x:

  An object to decorate

- titles:

  Plot titles

- footnotes:

  Plot footnotes

- paper:

  Paper size, by default "L11"

- for_test:

  \`logic\` CICD parameter

- ...:

  additional arguments. not used.

## Value

No return value, called for side effects

## Details

The paper default paper size, \`L11\`, indicate that the fontsize is 11.
The fontsize of the footnotes, is the fontsize of the titles minus 2.
