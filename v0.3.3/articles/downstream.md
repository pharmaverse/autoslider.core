# Guidelines for building downstream autoslider.\* packages

I recommend to build your own customized TLG templates into downstream
`R` packages.

Please refer to [Good Software Engineering Practice for R
Packages](https://pharmarug.github.io/pharmasug2024-r-workshop/) for how
to build an R package.

Recommend adding the following dependencies to your customized
downstream package:

    Depends:
        R (>= 3.5.0)
    Imports:
        assertthat (>= 0.2.1),
        checkmate (>= 2.3.2),
        cli (>= 3.6.3),
        dplyr (>= 1.1.4),
        flextable (>= 0.9.4),
        forcats (>= 1.0.0),
        ggplot2 (>= 3.5.1),
        ggpubr (>= 0.6.0),
        grid,
        gridExtra (>= 2.3),
        methods,
        officer (>= 0.3.18),
        rlang (>= 1.1.4),
        rlistings (>= 0.2.10),
        rtables (>= 0.6.11),
        rvg (>= 0.2.5),
        stringr (>= 1.5.1),
        survival,
        tern (>= 0.9.7),
        tidyr (>= 1.3.1),
        yaml (>= 2.3.10)
    Suggests:
        devtools (>= 2.4.5),
        filters (>= 0.3.1),
        formatters (>= 0.5.10),
        glue (>= 1.8.0),
        htmltools (>= 0.5.8.1),
        httr (>= 1.4.7),
        knitr (>= 1.49),
        lubridate (>= 1.9.4),
        mime (>= 0.12),
        nestcolor,
        purrr (>= 1.0.4),
        rmarkdown (>= 2.23),
        rsvg (>= 0.3.4),
        R.utils (>= 2.12.3),
        styler (>= 1.10.2),
        svglite (>= 2.1.2),
        testthat (>= 3.2.0),
        withr
