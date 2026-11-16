# Boxplot of one or more proteins by group

Creates a boxplot with overlaid jittered points for one or more assays,
grouped by a categorical variable. Optionally adds statistical
comparison annotations and a horizontal Limit of Detection (LOD) line.

## Usage

``` r
plot_boxplot(
  data,
  assay,
  group = NULL,
  assay_col = NULL,
  value_col = NULL,
  sample_col = NULL,
  lod_col = NULL,
  show_lod = FALSE,
  comparisons = NULL,
  test = "wilcox.test",
  paired = FALSE,
  subject_id = NULL,
  show_p_value = FALSE,
  show_significant = FALSE,
  p_cutoff = 0.05,
  bracket_nudge_y = NULL,
  step_increase = 0.12,
  jitter_width = 0.2,
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

- lod_col:

  Optional column name holding an LOD value; draws a dashed LOD
  reference line when supplied.

- show_lod:

  Logical; if \`TRUE\`, auto-detects the LOD column (or \`lod(oe)\`) and
  draws a dashed LOD reference line (default \`FALSE\`).

- comparisons:

  A list of length-2 vectors specifying pairwise comparisons for
  statistical brackets (passed to \`ggpubr::stat_compare_means()\` if
  \`ggpubr\` is available). If \`NULL\` and
  \`show_p_value\`/\`show_significant\` is used, every pair of group
  levels is compared.

- test:

  Statistical test: "wilcox.test", "t.test", or "none" (default
  "wilcox.test").

- paired:

  Logical; whether to perform paired statistical tests (default
  \`FALSE\`).

- subject_id:

  Optional subject ID column name used to align paired samples.

- show_p_value:

  Logical; annotate numeric p-values for each pairwise comparison
  between groups (e.g. "p = 0.03"). Requires \`ggpubr\` (default FALSE).

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

- jitter_width:

  Width of the jitter (default 0.2).

- palette:

  Optional color palette; uses \`olinkviz_palette()\` if NULL.

- title:

  Plot title. If NULL, uses the assay name (or NULL when faceted).

- ...:

  Additional arguments passed to \`ggplot2::geom_boxplot()\`.

## Value

A ggplot object.

## Examples

``` r
if (FALSE) { # \dontrun{
# Grouping column is auto-detected from the data
plot_boxplot(beatmg_npx, assay = "CD27")

# Multiple assays faceted automatically
plot_boxplot(beatmg_npx, assay = c("CD27", "IL6"), group = "Timepoint")
} # }
```
