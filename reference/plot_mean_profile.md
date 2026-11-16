# Mean profile plot (mean +/- CI over time by group)

Computes the mean and confidence interval of one or more proteins at
each level of an x-axis variable (e.g. time point), separately for each
group, and plots points with error bars connected by lines. This is the
classic "mean NPX trajectory" plot for longitudinal group comparisons.

## Usage

``` r
plot_mean_profile(
  data,
  assay,
  x = NULL,
  group = NULL,
  assay_col = NULL,
  value_col = NULL,
  lod_col = NULL,
  show_lod = FALSE,
  ci_level = 0.95,
  error_bar_type = "ci",
  add_signif = FALSE,
  test = "wilcox.test",
  paired = FALSE,
  subject_id = NULL,
  comparisons = NULL,
  compare_groups = FALSE,
  show_p_value = FALSE,
  show_significant = FALSE,
  p_cutoff = 0.05,
  bracket_nudge_y = NULL,
  step_increase = 0.12,
  dodge_width = 0.2,
  palette = NULL,
  title = NULL,
  ...
)
```

## Arguments

- data:

  A data.frame in long format, or an
  [OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md).

- assay:

  Name(s) of the protein/assay(s) to plot (must match values in
  \`assay_col\`). When multiple assays are supplied, the plot is faceted
  by assay.

- x:

  Name of the x-axis variable (e.g. "Timepoint"). If NULL, auto-detected
  from common time/visit columns.

- group:

  Optional column name for the grouping variable (colored lines). If
  NULL, no grouping is used.

- assay_col:

  Name of the assay column. If NULL, auto-detected (e.g. "Assay").

- value_col:

  Name of the NPX value column. If NULL, auto-detected (e.g. "NPX").

- lod_col:

  Optional column name holding an LOD value; draws a dashed LOD
  reference line when supplied.

- show_lod:

  Logical; if \`TRUE\`, auto-detects the LOD column (or \`lod(oe)\`) and
  draws a dashed LOD reference line (default \`FALSE\`).

- ci_level:

  Confidence level for the error bars (default 0.95).

- error_bar_type:

  Either "ci" (confidence interval of the mean, default) or "se"
  (standard error).

- add_signif:

  Logical; annotate between-group p-values at each x level using
  \`ggpubr::stat_compare_means()\` (requires \`ggpubr\`, default FALSE).

- test:

  Statistical test for significance annotations: "wilcox.test" (default)
  or "t.test".

- paired:

  Logical; whether to perform paired statistical tests (default
  \`FALSE\`).

- subject_id:

  Optional subject ID column name used to align paired samples.

- comparisons:

  A list of length-2 vectors specifying pairwise comparisons between x
  levels (e.g. timepoints). If \`NULL\` and
  \`show_p_value\`/\`show_significant\` is used, every pair of x levels
  is compared.

- compare_groups:

  Logical; when \`TRUE\` and \`group\` is supplied, compare \`group\`
  levels within each \`x\` level rather than pooling across groups
  (default \`FALSE\`).

- show_p_value:

  Logical; annotate numeric p-values for each pairwise comparison.
  Requires \`ggpubr\` (default FALSE).

- show_significant:

  Logical; annotate significance stars (\*, \*\*, \*\*\*) for each
  pairwise comparison. Requires \`ggpubr\` (default FALSE).

- p_cutoff:

  Significance threshold: when \`show_significant = TRUE\`, only
  comparisons with p \< \`p_cutoff\` are drawn (default 0.05). Set to
  \`NULL\` to show every comparison.

- bracket_nudge_y:

  Numeric vertical offset for the comparison brackets so they are raised
  above the data. If \`NULL\` (default), ~10 is used automatically.

- step_increase:

  Fraction of the plot height between stacked brackets (default 0.12).

- dodge_width:

  Horizontal offset between groups at the same x (default 0.2).

- palette:

  Optional color palette for groups.

- title:

  Plot title. If NULL, uses the assay name (or NULL when faceted).

- ...:

  Additional arguments passed to \`ggplot2::geom_errorbar()\`.

## Value

A ggplot object.

## Examples

``` r
if (FALSE) { # \dontrun{
plot_mean_profile(
  probc, assay = "IL6", x = "Timepoint", group = "Project"
)
} # }
```
