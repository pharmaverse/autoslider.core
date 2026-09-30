# Initialize PowerPoint Document Object

This function ensures a PowerPoint document (\`officer::rpptx\` object)
is loaded. If a \`doc_original\` is provided, it is directly returned.
Otherwise, the function reads the presentation from the given file path.

## Usage

``` r
initialize_doc_original(doc_original, doc_o)
```

## Arguments

- doc_original:

  An existing \`officer::rpptx\` object, or \`NULL\` to read from file.

- doc_o:

  Path to a PowerPoint (\`.pptx\`) file. Used only if \`doc_original\`
  is \`NULL\`.

## Value

An \`officer::rpptx\` PowerPoint object.

## Examples

``` r
example <- tempfile(fileext = ".pptx")
doc <- officer::read_pptx()
doc <- officer::add_slide(doc, layout = "Title and Content")
print(doc, target = example)
doc <- initialize_doc_original(NULL, example)
```
