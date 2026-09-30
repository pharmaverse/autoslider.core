# decorate method for tbl_roche_summary (NEST 2 gtsummary subclass)

Handles objects whose class vector is set to just `"tbl_roche_summary"`
(losing the full gtsummary hierarchy) as well as those with the full
`c("tbl_roche_summary", "tbl_summary", "gtsummary")` hierarchy.

## Usage

``` r
# S3 method for class 'tbl_roche_summary'
decorate(x, ...)
```

## Arguments

- x:

  tbl_roche_summary object to decorate

- ...:

  arguments passed to `decorate.gtsummary`
