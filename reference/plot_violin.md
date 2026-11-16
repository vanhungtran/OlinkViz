# Violin + boxplot of one or more proteins

Creates a violin plot with an overlaid boxplot for one or more assays
across a categorical x-axis (e.g. time point), optionally filled by
group. Mirrors the "distribution of NPX over time" figures in the NUMAB
reports.

## Usage

``` r
plot_violin(
  data,
  assay,
  x = NULL,
  group = NULL,
  assay_col = NULL,
  value_col = NULL,
  lod_col = NULL,
  show_lod = FALSE,
  show_boxplot = TRUE,
  comparisons = NULL,
  compare_groups = FALSE,
  test = "wilcox.test",
  paired = FALSE,
  subject_id = NULL,
  show_p_value = FALSE,
  show_significant = FALSE,
  p_cutoff = 0.05,
  bracket_nudge_y = NULL,
  step_increase = 0.12,
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

  Optional column name for the fill color (violins split by group).

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

- show_boxplot:

  Logical; overlay a boxplot on the violins (default TRUE).

- comparisons:

  A list of length-2 vectors specifying pairwise comparisons for
  statistical brackets. If \`NULL\` and
  \`show_p_value\`/\`show_significant\` is used, every pair of x levels
  (e.g. timepoints) is compared.

- compare_groups:

  Logical; when \`TRUE\` and \`group\` is supplied, compare \`group\`
  levels within each \`x\` level rather than pooling across groups
  (default \`FALSE\`).

- test:

  Statistical test: "wilcox.test" (default) or "t.test".

- paired:

  Logical; whether to perform paired statistical tests (default
  \`FALSE\`).

- subject_id:

  Optional subject ID column name used to align paired samples.

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

- palette:

  Optional color palette for groups.

- title:

  Plot title. If NULL, uses the assay name (or NULL when faceted).

- ...:

  Additional arguments passed to \`ggplot2::geom_violin()\`.

## Value

A ggplot object.

## Examples

``` r
if (FALSE) { # \dontrun{
plot_violin(
  numab_probc, assay = "IL6", x = "Timepoint", group = "TreatGroup"
)
} # }
```
