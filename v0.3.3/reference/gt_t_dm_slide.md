# Demographic table with gtsummary

Demographic table with gtsummary

## Usage

``` r
gt_t_dm_slide(adsl, arm = "TRT01P", vars = c("AGE", "SEX", "RACE"))
```

## Arguments

- adsl:

  ADSL data set, dataframe

- arm:

  Arm variable, character, "\`TRT01P" by default.

- vars:

  Characters of variables

## Value

gtsummary object

## Note

\* Default arm variables are set to \`"TRT01A"\` for safety output, and
\`"TRT01P"\` for efficacy output

## Examples

``` r
library(dplyr)
adsl <- eg_adsl
out1 <- gt_t_dm_slide(adsl, "TRT01P", c("SEX", "AGE", "RACE", "ETHNIC", "COUNTRY"))
print(out1)
#> <div id="ybhaaglvij" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
#>   <style>#ybhaaglvij table {
#>   font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
#>   -webkit-font-smoothing: antialiased;
#>   -moz-osx-font-smoothing: grayscale;
#> }
#> 
#> #ybhaaglvij thead, #ybhaaglvij tbody, #ybhaaglvij tfoot, #ybhaaglvij tr, #ybhaaglvij td, #ybhaaglvij th {
#>   border-style: none;
#> }
#> 
#> #ybhaaglvij p {
#>   margin: 0;
#>   padding: 0;
#> }
#> 
#> #ybhaaglvij .gt_table {
#>   display: table;
#>   border-collapse: collapse;
#>   line-height: normal;
#>   margin-left: auto;
#>   margin-right: auto;
#>   color: #333333;
#>   font-size: 16px;
#>   font-weight: normal;
#>   font-style: normal;
#>   background-color: #FFFFFF;
#>   width: auto;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #A8A8A8;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #A8A8A8;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#> }
#> 
#> #ybhaaglvij .gt_caption {
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#> }
#> 
#> #ybhaaglvij .gt_title {
#>   color: #333333;
#>   font-size: 125%;
#>   font-weight: initial;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-color: #FFFFFF;
#>   border-bottom-width: 0;
#> }
#> 
#> #ybhaaglvij .gt_subtitle {
#>   color: #333333;
#>   font-size: 85%;
#>   font-weight: initial;
#>   padding-top: 3px;
#>   padding-bottom: 5px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-color: #FFFFFF;
#>   border-top-width: 0;
#> }
#> 
#> #ybhaaglvij .gt_heading {
#>   background-color: #FFFFFF;
#>   text-align: center;
#>   border-bottom-color: #FFFFFF;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #ybhaaglvij .gt_bottom_border {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #ybhaaglvij .gt_col_headings {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #ybhaaglvij .gt_col_heading {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 6px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   overflow-x: hidden;
#> }
#> 
#> #ybhaaglvij .gt_column_spanner_outer {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: normal;
#>   text-transform: inherit;
#>   padding-top: 0;
#>   padding-bottom: 0;
#>   padding-left: 4px;
#>   padding-right: 4px;
#> }
#> 
#> #ybhaaglvij .gt_column_spanner_outer:first-child {
#>   padding-left: 0;
#> }
#> 
#> #ybhaaglvij .gt_column_spanner_outer:last-child {
#>   padding-right: 0;
#> }
#> 
#> #ybhaaglvij .gt_column_spanner {
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: bottom;
#>   padding-top: 5px;
#>   padding-bottom: 5px;
#>   overflow-x: hidden;
#>   display: inline-block;
#>   width: 100%;
#> }
#> 
#> #ybhaaglvij .gt_spanner_row {
#>   border-bottom-style: hidden;
#> }
#> 
#> #ybhaaglvij .gt_group_heading {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   text-align: left;
#> }
#> 
#> #ybhaaglvij .gt_empty_group_heading {
#>   padding: 0.5px;
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   vertical-align: middle;
#> }
#> 
#> #ybhaaglvij .gt_from_md > :first-child {
#>   margin-top: 0;
#> }
#> 
#> #ybhaaglvij .gt_from_md > :last-child {
#>   margin-bottom: 0;
#> }
#> 
#> #ybhaaglvij .gt_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   margin: 10px;
#>   border-top-style: solid;
#>   border-top-width: 1px;
#>   border-top-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 1px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 1px;
#>   border-right-color: #D3D3D3;
#>   vertical-align: middle;
#>   overflow-x: hidden;
#> }
#> 
#> #ybhaaglvij .gt_stub {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #ybhaaglvij .gt_stub_row_group {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   font-size: 100%;
#>   font-weight: initial;
#>   text-transform: inherit;
#>   border-right-style: solid;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   vertical-align: top;
#> }
#> 
#> #ybhaaglvij .gt_row_group_first td {
#>   border-top-width: 2px;
#> }
#> 
#> #ybhaaglvij .gt_row_group_first th {
#>   border-top-width: 2px;
#> }
#> 
#> #ybhaaglvij .gt_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #ybhaaglvij .gt_first_summary_row {
#>   border-top-style: solid;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #ybhaaglvij .gt_first_summary_row.thick {
#>   border-top-width: 2px;
#> }
#> 
#> #ybhaaglvij .gt_last_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #ybhaaglvij .gt_grand_summary_row {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   text-transform: inherit;
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #ybhaaglvij .gt_first_grand_summary_row {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-top-style: double;
#>   border-top-width: 6px;
#>   border-top-color: #D3D3D3;
#> }
#> 
#> #ybhaaglvij .gt_last_grand_summary_row_top {
#>   padding-top: 8px;
#>   padding-bottom: 8px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#>   border-bottom-style: double;
#>   border-bottom-width: 6px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #ybhaaglvij .gt_striped {
#>   background-color: rgba(128, 128, 128, 0.05);
#> }
#> 
#> #ybhaaglvij .gt_table_body {
#>   border-top-style: solid;
#>   border-top-width: 2px;
#>   border-top-color: #D3D3D3;
#>   border-bottom-style: solid;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#> }
#> 
#> #ybhaaglvij .gt_footnotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #ybhaaglvij .gt_footnote {
#>   margin: 0px;
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #ybhaaglvij .gt_sourcenotes {
#>   color: #333333;
#>   background-color: #FFFFFF;
#>   border-bottom-style: none;
#>   border-bottom-width: 2px;
#>   border-bottom-color: #D3D3D3;
#>   border-left-style: none;
#>   border-left-width: 2px;
#>   border-left-color: #D3D3D3;
#>   border-right-style: none;
#>   border-right-width: 2px;
#>   border-right-color: #D3D3D3;
#> }
#> 
#> #ybhaaglvij .gt_sourcenote {
#>   font-size: 90%;
#>   padding-top: 4px;
#>   padding-bottom: 4px;
#>   padding-left: 5px;
#>   padding-right: 5px;
#> }
#> 
#> #ybhaaglvij .gt_left {
#>   text-align: left;
#> }
#> 
#> #ybhaaglvij .gt_center {
#>   text-align: center;
#> }
#> 
#> #ybhaaglvij .gt_right {
#>   text-align: right;
#>   font-variant-numeric: tabular-nums;
#> }
#> 
#> #ybhaaglvij .gt_font_normal {
#>   font-weight: normal;
#> }
#> 
#> #ybhaaglvij .gt_font_bold {
#>   font-weight: bold;
#> }
#> 
#> #ybhaaglvij .gt_font_italic {
#>   font-style: italic;
#> }
#> 
#> #ybhaaglvij .gt_super {
#>   font-size: 65%;
#> }
#> 
#> #ybhaaglvij .gt_footnote_marks {
#>   font-size: 75%;
#>   vertical-align: 0.4em;
#>   position: initial;
#> }
#> 
#> #ybhaaglvij .gt_asterisk {
#>   font-size: 100%;
#>   vertical-align: 0;
#> }
#> 
#> #ybhaaglvij .gt_indent_1 {
#>   text-indent: 5px;
#> }
#> 
#> #ybhaaglvij .gt_indent_2 {
#>   text-indent: 10px;
#> }
#> 
#> #ybhaaglvij .gt_indent_3 {
#>   text-indent: 15px;
#> }
#> 
#> #ybhaaglvij .gt_indent_4 {
#>   text-indent: 20px;
#> }
#> 
#> #ybhaaglvij .gt_indent_5 {
#>   text-indent: 25px;
#> }
#> 
#> #ybhaaglvij .katex-display {
#>   display: inline-flex !important;
#>   margin-bottom: 0.75em !important;
#> }
#> 
#> #ybhaaglvij div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
#>   height: 0px !important;
#> }
#> </style>
#>   <table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
#>   <!--/html_preserve--><caption class='gt_caption'><span class='gt_from_md'>Demographic slide</span></caption><!--html_preserve-->
#>   <thead>
#>     <tr class="gt_col_headings">
#>       <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="label"><span class='gt_from_md'><strong>Characteristic</strong></span></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_1"><span class='gt_from_md'><strong>A: Drug X</strong><br />
#> N = 134</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_2"><span class='gt_from_md'><strong>B: Placebo</strong><br />
#> N = 134</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
#>       <th class="gt_col_heading gt_columns_bottom_border gt_center" rowspan="1" colspan="1" scope="col" id="stat_3"><span class='gt_from_md'><strong>C: Combination</strong><br />
#> N = 132</span><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span></th>
#>     </tr>
#>   </thead>
#>   <tbody class="gt_table_body">
#>     <tr><td headers="label" class="gt_row gt_left">Sex</td>
#> <td headers="stat_1" class="gt_row gt_center"><br /></td>
#> <td headers="stat_2" class="gt_row gt_center"><br /></td>
#> <td headers="stat_3" class="gt_row gt_center"><br /></td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    F</td>
#> <td headers="stat_1" class="gt_row gt_center">79 (59%)</td>
#> <td headers="stat_2" class="gt_row gt_center">82 (61%)</td>
#> <td headers="stat_3" class="gt_row gt_center">70 (53%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    M</td>
#> <td headers="stat_1" class="gt_row gt_center">55 (41%)</td>
#> <td headers="stat_2" class="gt_row gt_center">52 (39%)</td>
#> <td headers="stat_3" class="gt_row gt_center">62 (47%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">Age</td>
#> <td headers="stat_1" class="gt_row gt_center">33 (28, 39)</td>
#> <td headers="stat_2" class="gt_row gt_center">35 (30, 40)</td>
#> <td headers="stat_3" class="gt_row gt_center">35 (30, 40)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">Race</td>
#> <td headers="stat_1" class="gt_row gt_center"><br /></td>
#> <td headers="stat_2" class="gt_row gt_center"><br /></td>
#> <td headers="stat_3" class="gt_row gt_center"><br /></td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    ASIAN</td>
#> <td headers="stat_1" class="gt_row gt_center">68 (51%)</td>
#> <td headers="stat_2" class="gt_row gt_center">67 (50%)</td>
#> <td headers="stat_3" class="gt_row gt_center">73 (55%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    BLACK OR AFRICAN AMERICAN</td>
#> <td headers="stat_1" class="gt_row gt_center">31 (23%)</td>
#> <td headers="stat_2" class="gt_row gt_center">28 (21%)</td>
#> <td headers="stat_3" class="gt_row gt_center">32 (24%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    WHITE</td>
#> <td headers="stat_1" class="gt_row gt_center">27 (20%)</td>
#> <td headers="stat_2" class="gt_row gt_center">26 (19%)</td>
#> <td headers="stat_3" class="gt_row gt_center">21 (16%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    AMERICAN INDIAN OR ALASKA NATIVE</td>
#> <td headers="stat_1" class="gt_row gt_center">8 (6.0%)</td>
#> <td headers="stat_2" class="gt_row gt_center">11 (8.2%)</td>
#> <td headers="stat_3" class="gt_row gt_center">6 (4.5%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    MULTIPLE</td>
#> <td headers="stat_1" class="gt_row gt_center">0 (0%)</td>
#> <td headers="stat_2" class="gt_row gt_center">1 (0.7%)</td>
#> <td headers="stat_3" class="gt_row gt_center">0 (0%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER</td>
#> <td headers="stat_1" class="gt_row gt_center">0 (0%)</td>
#> <td headers="stat_2" class="gt_row gt_center">1 (0.7%)</td>
#> <td headers="stat_3" class="gt_row gt_center">0 (0%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    OTHER</td>
#> <td headers="stat_1" class="gt_row gt_center">0 (0%)</td>
#> <td headers="stat_2" class="gt_row gt_center">0 (0%)</td>
#> <td headers="stat_3" class="gt_row gt_center">0 (0%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    UNKNOWN</td>
#> <td headers="stat_1" class="gt_row gt_center">0 (0%)</td>
#> <td headers="stat_2" class="gt_row gt_center">0 (0%)</td>
#> <td headers="stat_3" class="gt_row gt_center">0 (0%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">Ethnicity</td>
#> <td headers="stat_1" class="gt_row gt_center"><br /></td>
#> <td headers="stat_2" class="gt_row gt_center"><br /></td>
#> <td headers="stat_3" class="gt_row gt_center"><br /></td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">     NOT REPORTED</td>
#> <td headers="stat_1" class="gt_row gt_center">6 (4.5%)</td>
#> <td headers="stat_2" class="gt_row gt_center">10 (7.5%)</td>
#> <td headers="stat_3" class="gt_row gt_center">11 (8.3%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    HISPANIC OR LATINO</td>
#> <td headers="stat_1" class="gt_row gt_center">15 (11%)</td>
#> <td headers="stat_2" class="gt_row gt_center">18 (13%)</td>
#> <td headers="stat_3" class="gt_row gt_center">15 (11%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    NOT HISPANIC OR LATINO</td>
#> <td headers="stat_1" class="gt_row gt_center">104 (78%)</td>
#> <td headers="stat_2" class="gt_row gt_center">103 (77%)</td>
#> <td headers="stat_3" class="gt_row gt_center">101 (77%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    UNKNOWN</td>
#> <td headers="stat_1" class="gt_row gt_center">9 (6.7%)</td>
#> <td headers="stat_2" class="gt_row gt_center">3 (2.2%)</td>
#> <td headers="stat_3" class="gt_row gt_center">5 (3.8%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">Country</td>
#> <td headers="stat_1" class="gt_row gt_center"><br /></td>
#> <td headers="stat_2" class="gt_row gt_center"><br /></td>
#> <td headers="stat_3" class="gt_row gt_center"><br /></td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    CHN</td>
#> <td headers="stat_1" class="gt_row gt_center">74 (55%)</td>
#> <td headers="stat_2" class="gt_row gt_center">81 (60%)</td>
#> <td headers="stat_3" class="gt_row gt_center">64 (48%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    USA</td>
#> <td headers="stat_1" class="gt_row gt_center">10 (7.5%)</td>
#> <td headers="stat_2" class="gt_row gt_center">13 (9.7%)</td>
#> <td headers="stat_3" class="gt_row gt_center">17 (13%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    BRA</td>
#> <td headers="stat_1" class="gt_row gt_center">13 (9.7%)</td>
#> <td headers="stat_2" class="gt_row gt_center">7 (5.2%)</td>
#> <td headers="stat_3" class="gt_row gt_center">10 (7.6%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    PAK</td>
#> <td headers="stat_1" class="gt_row gt_center">12 (9.0%)</td>
#> <td headers="stat_2" class="gt_row gt_center">9 (6.7%)</td>
#> <td headers="stat_3" class="gt_row gt_center">10 (7.6%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    NGA</td>
#> <td headers="stat_1" class="gt_row gt_center">8 (6.0%)</td>
#> <td headers="stat_2" class="gt_row gt_center">7 (5.2%)</td>
#> <td headers="stat_3" class="gt_row gt_center">11 (8.3%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    RUS</td>
#> <td headers="stat_1" class="gt_row gt_center">5 (3.7%)</td>
#> <td headers="stat_2" class="gt_row gt_center">8 (6.0%)</td>
#> <td headers="stat_3" class="gt_row gt_center">6 (4.5%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    JPN</td>
#> <td headers="stat_1" class="gt_row gt_center">5 (3.7%)</td>
#> <td headers="stat_2" class="gt_row gt_center">4 (3.0%)</td>
#> <td headers="stat_3" class="gt_row gt_center">9 (6.8%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    GBR</td>
#> <td headers="stat_1" class="gt_row gt_center">4 (3.0%)</td>
#> <td headers="stat_2" class="gt_row gt_center">3 (2.2%)</td>
#> <td headers="stat_3" class="gt_row gt_center">2 (1.5%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    CAN</td>
#> <td headers="stat_1" class="gt_row gt_center">3 (2.2%)</td>
#> <td headers="stat_2" class="gt_row gt_center">2 (1.5%)</td>
#> <td headers="stat_3" class="gt_row gt_center">3 (2.3%)</td></tr>
#>     <tr><td headers="label" class="gt_row gt_left">    CHE</td>
#> <td headers="stat_1" class="gt_row gt_center">0 (0%)</td>
#> <td headers="stat_2" class="gt_row gt_center">0 (0%)</td>
#> <td headers="stat_3" class="gt_row gt_center">0 (0%)</td></tr>
#>   </tbody>
#>   <tfoot>
#>     <tr class="gt_footnotes">
#>       <td class="gt_footnote" colspan="4"><span class="gt_footnote_marks" style="white-space:nowrap;font-style:italic;font-weight:normal;line-height:0;"><sup>1</sup></span> <span class='gt_from_md'>n (%); Median (Q1, Q3)</span></td>
#>     </tr>
#>   </tfoot>
#> </table>
#> </div>
generate_slides(out1, paste0(tempdir(), "/dm.pptx"))
#> [1] "Demographic slide"
#> [1] "Demographic slide (cont.)"
#> [1] "Demographic slide (cont.)"
#> [1] "Demographic slide (cont.)"
```
