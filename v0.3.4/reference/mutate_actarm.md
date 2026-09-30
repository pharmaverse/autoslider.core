# Refactor active arm

Refactor active arm

## Usage

``` r
mutate_actarm(
  df,
  arm_var = "TRT01A",
  levels = c("PLACEBO + PACLITAXEL + CISPLATIN",
    "ATEZOLIZUMAB + TIRAGOLUMAB + PACLITAXEL + CISPLATIN"),
  labels = c("Pbo+Pbo+PC", "Tira+Atezo+PC")
)
```

## Arguments

- df:

  Input dataframe

- arm_var:

  Arm variable

- levels:

  factor levels

- labels:

  factor labels

## Value

Dataframe with re-level and re-labelled arm variable.
