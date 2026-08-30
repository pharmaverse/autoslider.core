# decorate list of grobs

decorate list of grobs

## Usage

``` r
# S3 method for class 'list'
decorate(x, titles, footnotes, paper = "L11", for_test = FALSE, ...)
```

## Arguments

- x:

  object to decorate

- titles:

  graph titles

- footnotes:

  graph footnotes

- paper:

  paper size. default is "L11".

- for_test:

  \`logic\` CICD parameter

- ...:

  additional arguments. not used

## Value

No return value, called for side effects

## Details

The paper default paper size, \`L11\`, indicate that the fontsize is 11.
The fontsize of the footnotes, is the fontsize of the titles minus 2.
