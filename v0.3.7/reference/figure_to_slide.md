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
  figure_loc = NULL,
  fig_editable = FALSE,
  fig_margin = 0.25,
  fig_format = "svg",
  fig_dpi = 300,
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

  location of the figure. `NULL` (the default) fits the figure into the
  free area of the slide, see
  [`figure_fit()`](https://pharmaverse.github.io/autoslider.core/reference/figure_fit.md).

- fig_editable:

  whether we want the figure to be editable in pptx viewers

- fig_margin, fig_format, fig_dpi:

  See
  [`generate_slides()`](https://pharmaverse.github.io/autoslider.core/reference/generate_slides.md).

- ...:

  arguments passed to program

## Value

slide with the added content
