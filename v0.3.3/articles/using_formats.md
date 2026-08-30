# Customizing TLG Visual Formats

## Overview

This guide will walk you through utilizing functions for styling your
tables. We have implemented a base formatting function and several
simple theme wrappers, and you can easily switch between different
visual styles. For a complete list of implementations we have for you,
please go to `R/ft_formats.R`.

#### Pattern A: autoslider Base Theme

The `autoslider_format` function is a great example of a base theme. It
defines a “zebra-striped” layout and accepts many arguments for colors
and fonts, giving you full control.

`autoslider_format`` ``<-`` ``function``(``ft``,`` `` ``odd_header`` ``=`` ``"#0EAED5"``,`` `` ``odd_body`` ``=`` ``"#EBF5FA"``,`` `` ``even_body`` ``=`` ``"#D0E4F2"``,`` `` ``...``)`` ``{`` `` ``ft`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)` `` ``flextable``::`[`theme_zebra`](https://davidgohel.github.io/flextable/reference/theme_zebra.html)`(`` `` odd_header ``=`` ``odd_header``,`` `` odd_body ``=`` ``odd_body``,`` `` even_header ``=`` ``odd_header``, ``# Use same color for even header`` `` even_body ``=`` ``even_body`` `` ``)`` `` ``# ... other general formatting ...`` ``}`

#### Pattern B: Simple Theme Wrappers

Wrapper functions call the base theme with predefined colors. This makes
it easy to switch between styles.

`blue_format`` ``<-`` ``function``(``ft``, ``...``)`` ``{`` `` ``# Calls the base function with specific blue colors`` `` ``ft`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)` `[`autoslider_format`](https://pharmaverse.github.io/autoslider.core/reference/autoslider_format.md)`(`` `` odd_header ``=`` ``"#0B41CD"``,`` `` odd_body ``=`` ``"#1482FA"``,`` `` even_body ``=`` ``"#BDE3FF"``,`` `` ``...`` `` ``)`` ``}`

#### Pattern C: Standalone Formats

For unique tables, you can create a standalone function that doesn’t use
the base theme at all, like `black_format_tb.`

`black_format_tb`` ``<-`` ``function``(``ft``, ``...``)`` ``{`` `` ``ft`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)` `` ``flextable``::`[`theme_booktabs`](https://davidgohel.github.io/flextable/reference/theme_booktabs.html)`(``)`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)` `` ``flextable``::`[`color`](https://davidgohel.github.io/flextable/reference/color.html)`(``color ``=`` ``"blue"``, part ``=`` ``"header"``)`` `` ``# ... other specific formatting ...`` ``}`

### How to Apply Your Custom Formats

If you have special demands that require customized implementation of
TLG formats, feel free to implement them on your own. The most direct
way to use and test these functions is to apply them to a `flextable`
object after it has been created.

The workflow involves three steps:

- Generate your list of outputs.

- Convert a specific output into a `flextable` object.

- Pass the resulting `flextable` object directly to your formatting
  function.

##### Example: Visualize the output of your format implementation

`outputs`` ``<-`` ``spec_file`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)` `` `[`read_spec`](https://pharmaverse.github.io/autoslider.core/reference/read_spec.md)`(``)`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)` `` `[`filter_spec`](https://pharmaverse.github.io/autoslider.core/reference/filter_spec.md)`(``program`` `[`%in%`](https://rdrr.io/r/base/match.html)` `[`c`](https://rdrr.io/r/base/c.html)`(``"t_dm_slide"``)``)`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)` `` `[`generate_outputs`](https://pharmaverse.github.io/autoslider.core/reference/generate_outputs.md)`(``datasets ``=`` ``my_data``)`` `[`%>%`](https://magrittr.tidyverse.org/reference/pipe.html)` `` `[`decorate_outputs`](https://pharmaverse.github.io/autoslider.core/reference/decorate_outputs.md)`(``)`` `` ``# Step 2: Convert a specific output to a flextable object`` ``dm_table`` ``<-`` `[`to_flextable`](https://pharmaverse.github.io/autoslider.core/reference/to_flextable.md)`(``outputs``$``t_dm_slide_ITT``)`` ``# The to_flextable() function returns a list, so we get the first element`` ``dm_flextable`` ``<-`` ``dm_table``[[``1``]``]``$``ft`` `` ``# Step 3: Apply your formatting functions`` ``black_ft`` ``<-`` ``my_own_format``(``dm_flextable``)`` `[`print`](https://rdrr.io/r/base/print.html)`(``black_ft``)`
