# Decorate outputs

Decorate outputs with titles and footnotes

## Usage

``` r
decorate_outputs(
  outputs,
  generic_title = NULL,
  generic_footnote = "Confidential and for internal use only",
  version_label = get_version_label_output(),
  for_test = FALSE
)
```

## Arguments

- outputs:

  \`list\` of output objects as created by \`generate_outputs\`

- generic_title:

  \`character\` vector of titles

- generic_footnote:

  \`character\` vector of footnotes

- version_label:

  \`character\`. A version label to be added to the title.

- for_test:

  \`logic\` CICD parameter

## Value

No return value, called for side effects

## Details

\`generic_title\` and \`generic_footnote\` will be added to \*all\*
outputs. The use case is to add information such as protocol number and
snapshot date defined in a central place (e.g. metadata.yml) to
\*every\* output.

\`version_label\` must be either \`"DRAFT"\`, \`"APPROVED"\` or
\`NULL\`. By default, when outputs are created on the master branch it
is set to \`NULL\`, i.e. no version label will be displayed. Otherwise
\`"DRAFT"\` will be added. To add \`"APPROVED"\` to the title you will
need to explicitly set \`version_label = "APPROVED"\`.
