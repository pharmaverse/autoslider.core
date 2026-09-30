# Post-process PowerPoint Document

Performs final actions on the PowerPoint object, including optionally
saving the updated file. The saved filename includes a suffix indicating
the slide type that was appended.

## Usage

``` r
postprocessing_doc(doc, save_file, doc_o, type = "")
```

## Arguments

- doc:

  An \`officer::rpptx\` object to finalize.

- save_file:

  A boolean indicating whether to save the file to disk.

- doc_o:

  Original PowerPoint file path.

- type:

  A string suffix to label the output file, e.g., \`"cohort_sec"\` or
  \`"safety_sum_sec"\`.

## Value

The modified \`officer::rpptx\` object.

## Examples

``` r
tmp <- tempfile(fileext = ".pptx")
doc <- officer::read_pptx()
doc <- officer::add_slide(doc, layout = "Title Slide", master = "Office Theme")
print(doc, target = tmp)
doc <- officer::read_pptx(tmp)
# Call postprocessing_doc to save a modified version of doc
postprocessing_doc(doc, TRUE, tmp, type = "final")
#> pptx document with 1 slide
#> Available layouts and their associated master(s):
#>              layout       master
#> 1       Title Slide Office Theme
#> 2 Title and Content Office Theme
#> 3    Section Header Office Theme
#> 4       Two Content Office Theme
#> 5        Comparison Office Theme
#> 6        Title Only Office Theme
#> 7             Blank Office Theme
```
