# Adding custom templates to autoslider.core as a developer

## Overview

This vignette shows how developers can add their own custom table
templates to the autoslider.core package. This is useful if you’re
extending the package with your own commonly used table logic and want
it to integrate with the
[`list_all_templates()`](https://pharmaverse.github.io/autoslider.core/reference/list_all_templates.md)
and
[`use_template()`](https://pharmaverse.github.io/autoslider.core/reference/use_template.md)
framework.

## Step 1: Write your template

First, navigate to the `R/` directory. For example, if you are creating
a new custom table:

``` bash
cd ~/autoslider.core/R
nano t_my_custom_table.R
```

Then you can start editing the template contents inside the file. Be
sure to follow naming conventions: templates should start with `t_`,
`l_`, or `g_` to be detected.

## Step 2: Create a softlink in inst/templates/

For your new template to be recognized by
[`list_all_templates()`](https://pharmaverse.github.io/autoslider.core/reference/list_all_templates.md),
it must be found under the `inst/templates/` folder.

Navigate to that folder and link your new template file:

``` bash
cd ~/autoslider.core/inst/templates
ln -s ../../R/t_my_custom_table.R # creates softlinks
```

This creates a softlink to the file in the `R/` folder, meaning
autoslider.core doesn’t duplicate the file, but still picks it up.

## Step 3: Verify with `list_all_templates()`

Load the package and call:

`devtools``::`[`load_all`](https://devtools.r-lib.org/reference/load_all.html)`(``)`` `[`list_all_templates`](https://pharmaverse.github.io/autoslider.core/reference/list_all_templates.md)`(``)`

Your new template `t_my_custom_table` should appear in the list.

## Step 4: Generate with `use_template()`

You can now use your template like any built-in one:

[`use_template`](https://pharmaverse.github.io/autoslider.core/reference/use_template.md)`(`` `` template ``=`` ``"t_my_custom_table"``,`` `` function_name ``=`` ``"custom_table_slide"``,`` `` open ``=`` ``TRUE`` ``)`

This will create a new file at `./programs/R/custom_table_slide.R` based
on your template.
