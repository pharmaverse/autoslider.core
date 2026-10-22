# survival time afun

survival time afun

## Usage

``` r
s_surv_time_1(df, .var, is_event, control = control_surv_time())
```

## Arguments

- df:

  data

- .var:

  variable of interest

- is_event:

  vector indicating event

- control:

  \`control_surv_time()\` by default

## Value

A function suitable for use in rtables::analyze() with element
selection, reformatting, and relabeling performed automatically.
