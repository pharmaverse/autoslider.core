# Fit a figure into the free area of a slide

Works out where a figure goes on a slide of `layout`: the free area is
the slide inside a margin of `margin` on every side, below the title
(and any other placeholder in the top half of the slide that the slide
writes, such as a subtitle) and above any placeholder it writes in the
bottom half (such as a footer), again with `margin` in between. The
figure is scaled to the largest size with the shape of `fig_width` x
`fig_height` that fits, and centered in that area. This keeps figures
inside the slide, clear of the title, with even margins, whatever the
template's size and layout.

## Usage

``` r
figure_fit(
  ppt,
  layout,
  master,
  fig_width,
  fig_height,
  margin = 0.25,
  targets = list()
)
```

## Arguments

- ppt:

  An `officer::rpptx` object.

- layout, master:

  The layout the figure's slide uses.

- fig_width, fig_height:

  The figure's shape (only their ratio matters).

- margin:

  Margin in inches.

- targets:

  Locations of other content written on the slide (officer
  `location_type` or `location_label` objects). The title placeholder
  always counts.

## Value

A `list` with the figure's `width` and `height` in inches and an officer
`location` for it.
