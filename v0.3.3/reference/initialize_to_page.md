# Determine Slide Insertion Page Number

Computes the appropriate page number at which to insert a new slide into
the PowerPoint deck. Defaults to appending to the end if no value is
provided.

## Usage

``` r
initialize_to_page(doc_original, to_page)
```

## Arguments

- doc_original:

  An \`officer::rpptx\` object representing the PowerPoint file.

- to_page:

  Desired slide index to insert the new slide. If \`NA\`, appends to the
  last page.

## Value

A single integer value indicating the validated page number for slide
insertion.

## Examples

``` r
tmp <- tempfile(fileext = ".pptx")
doc <- officer::read_pptx()
doc <- officer::add_slide(doc, layout = "Title Slide", master = "Office Theme")
print(doc, target = tmp)
doc <- officer::read_pptx(tmp)
initialize_to_page(doc, NA) # append to end
#> [1] 1
initialize_to_page(doc, 1) # insert at page 1
#> [1] 1
```
