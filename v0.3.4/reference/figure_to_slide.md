# Add figure to slides

Add figure to slides

## Usage

``` r
figure_to_slide(
  ppt,
  content,
  decor = TRUE,
  fig_width,
  fig_height,
  layout = "Title and Content",
  figure_loc = ph_location_type("body"),
  fig_editable = FALSE,
  ...
)
```

## Arguments

- ppt:

  slide page

- content:

  content to be added

- decor:

  should decoration be added

- fig_width:

  user specified figure width

- fig_height:

  user specified figure height

- layout:

  theme layout

- figure_loc:

  location of the figure. Defaults to \`ph_location_type("body")\`

- fig_editable:

  whether we want the figure to be editable in pptx viewers

- ...:

  arguments passed to program

## Value

slide with the added content
