# Dot plot for multiple proteins grouped by condition

Creates a Cleveland-style dot plot showing effect sizes or mean
differences for multiple assays across groups. Dot size encodes
significance and color encodes direction or magnitude.

## Usage

``` r
plot_dotplot(
  data,
  assays = NULL,
  group = NULL,
  assay_col = NULL,
  value_col = NULL,
  sample_col = NULL,
  ref_group = NULL,
  top_n = 20,
  p_adjust_method = "none",
  palette = NULL,
  title = NULL,
  ...
)
```

## Arguments

- data:

  A data.frame in long format.

- assays:

  Character vector of assay names to include. If NULL, uses all unique
  assays (use with caution on large panels).

- group:

  Column name for the grouping variable. If NULL, auto-detected from
  common group-like columns (e.g. \`Timepoint\`, \`Condition\`,
  \`long_covid\`).

- assay_col:

  Name of the assay column. If NULL, auto-detected (e.g. "Assay").

- value_col:

  Name of the NPX value column. If NULL, auto-detected (e.g. "NPX").

- sample_col:

  Name of the sample identifier column. If NULL, auto-detected (e.g.
  "SampleID"). Used to keep sample IDs out of the grouping detection.

- ref_group:

  Reference group for computing fold changes. If NULL, uses the first
  level of the group factor.

- top_n:

  Limit to the top N assays by inter-group difference (default 20).

- p_adjust_method:

  Multiple-testing correction method passed to \`stats::p.adjust()\`
  (e.g. \`"BH"\`, \`"bonferroni"\`, or \`"none"\`). Default \`"none"\`.

- palette:

  Color palette for the dot fill.

- title:

  Plot title.

- ...:

  Additional arguments passed to \`ggplot2::geom_point()\`.

## Value

A ggplot object.

## Examples

``` r
if (FALSE) { # \dontrun{
# Grouping column is auto-detected from the data
plot_dotplot(beatmg_npx, top_n = 15)

# Or specify the grouping explicitly and adjust p-values (BH FDR)
plot_dotplot(beatmg_npx, group = "Timepoint", top_n = 15, p_adjust_method = "BH")
} # }
```
