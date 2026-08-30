# Save an Output

Save an Output

## Usage

``` r
save_output(output, file_name, save_rds = TRUE)

save_output(output, file_name, save_rds = TRUE)

save_output.autoslider_error(output, file_name, save_rds = TRUE)

# S4 method for class 'dVTableTree'
save_output(output, file_name, save_rds = TRUE)

save_output.decoratedGrob(output, file_name, save_rds = TRUE)

save_output.decoratedGrobSet(output, file_name, save_rds = TRUE)

save_output.dgtsummary(output, file_name, save_rds = TRUE)

save_output.dlisting(output, file_name, save_rds = TRUE)
```

## Arguments

- output:

  Output object, e.g. an \`rtable\` or \`grob\`

- file_name:

  Full path of the new file \*excluding\* the extension

- save_rds:

  Saved as an \`.rds\` files

## Value

The input \`object\` invisibly

No return value, called for side effects

The input \`object\` invisibly

The input \`object\` invisibly

The input \`object\` invisibly

The input \`object\` invisibly

## Details

Tables are saved as RDS file

## Examples

``` r
library(dplyr)
adsl <- eg_adsl %>%
  filter(SAFFL == "Y") %>%
  mutate(TRT01P = factor(TRT01P, levels = c("A: Drug X", "B: Placebo")))
output_dir <- tempdir()
t_dm_slide(adsl, "TRT01P", c("SEX", "AGE", "RACE", "ETHNIC", "COUNTRY")) %>%
  decorate(
    title = "Demographic table",
    footnote = ""
  ) %>%
  save_output(
    file_name = file.path(output_dir, "t_dm_SE"),
    save_rds = TRUE
  )
```
