# ROC curves for one or more proteins

Draws receiver operating characteristic (ROC) curves of individual
proteins for a two-group comparison, with the area under the curve (AUC)
and its 95 percent confidence interval (DeLong) in the legend. Requires
the \`pROC\` package.

## Usage

``` r
plot_roc(
  data,
  assays = NULL,
  group = NULL,
  positive = NULL,
  assay_col = NULL,
  value_col = NULL,
  sample_col = NULL,
  ci = TRUE,
  add_ci = FALSE,
  boot_n = 200L,
  seed = 42L,
  smooth_method = c("none", "binormal", "density"),
  show_empirical = TRUE,
  sort_by_auc = TRUE,
  compare = FALSE,
  reference = NULL,
  compare_method = c("delong", "bootstrap"),
  p_adjust = "none",
  direction = c("auto", "<", ">"),
  show_direction = FALSE,
  palette = NULL,
  title = NULL,
  ...
)
```

## Arguments

- data:

  A data.frame in long format (one row per sample and assay), an
  [OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md),
  or an \`aucmat_screen\` object (from \`aucmat::aucmat(..., retain_data
  = TRUE)\`).

- assays:

  Character vector of assay (protein) names, one curve each. Optional
  when \`data\` is an \`aucmat_screen\` object (defaults to the top 6
  biomarkers by \`auc_strength\`).

- group:

  Name of the grouping column. If NULL, auto-detected. It must have
  exactly two levels; subset the data first if it has more.

- positive:

  Level of \`group\` treated as the event (the "case"). If NULL
  (default), the second level (alphabetical, or factor order) is used.

- assay_col:

  Name of the assay column. If NULL, auto-detected.

- value_col:

  Name of the NPX value column. If NULL, auto-detected.

- sample_col:

  Name of the sample ID column. If NULL, auto-detected.

- ci:

  Logical; add the 95 percent confidence interval of the AUC to the
  legend (default \`TRUE\`).

- add_ci:

  Logical; add bootstrap sensitivity confidence ribbons around each ROC
  curve via \`pROC::ci.se()\` (default \`FALSE\`).

- boot_n:

  Number of bootstrap replicates when \`add_ci = TRUE\` or
  \`compare_method = "bootstrap"\` (default \`200\`).

- seed:

  Optional RNG seed for reproducible bootstrap CI ribbons (default
  \`42\`).

- smooth_method:

  ROC smoothing method: \`"none"\` (empirical step curve, default),
  \`"binormal"\`, or \`"density"\` (via \`pROC::smooth()\`). When
  smoothed, the empirical AUC and DeLong CI are still reported in the
  legend.

- show_empirical:

  Logical; when \`smooth_method != "none"\`, overlay the empirical step
  curve as a faint dashed line (default \`TRUE\`).

- sort_by_auc:

  Logical; order curves and legend entries from highest AUC to lowest
  AUC (default \`TRUE\`).

- compare:

  Logical; run paired statistical tests (\`pROC::roc.test()\`) comparing
  each ROC curve against \`reference\` (default \`FALSE\`). Results are
  annotated in the legend/subtitle and returned in \`attr(p,
  "roc_test")\`.

- reference:

  Name of the reference assay in \`assays\` when \`compare = TRUE\`. If
  \`NULL\` (default), uses the highest-AUC curve (when \`sort_by_auc =
  TRUE\`) or the first curve.

- compare_method:

  Statistical test for comparing ROC curves: \`"delong"\` (default) or
  \`"bootstrap"\`.

- p_adjust:

  Multiple-testing adjustment method passed to \[stats::p.adjust()\]
  across pairwise comparisons against \`reference\` (default \`"none"\`,
  or e.g. \`"BH"\`).

- direction:

  \`"auto"\` (default), \`"\<"\` (cases have higher values) or \`"\>"\`
  (cases have lower values).

- show_direction:

  Logical; if \`TRUE\`, appends \`(+)\` or \`(-)\` to each legend label
  indicating whether cases have higher (\`\<\`) or lower (\`\>\`) NPX
  values than controls (default \`FALSE\`).

- palette:

  Optional character vector or palette name, one colour per curve.

- title:

  Plot title.

- ...:

  Additional arguments passed to \`ggplot2::geom_path()\`.

## Value

A ggplot object. \`p\$data\` has one row per point of each curve, with
the columns \`Assay\`, \`.fpr\`, \`.sens\`, \`.auc\`, \`.lower\`,
\`.upper\`, \`.direction\`. When \`compare = TRUE\` (or \`reference\` is
given), \`attr(p, "roc_test")\` contains a data.frame of pairwise
comparison results (\`reference\`, \`assay\`, \`auc_ref\`,
\`auc_assay\`, \`delta_auc\`, \`p_value\`, \`p_adj\`, \`method\`).

## Details

Replicate rows (the same sample and assay more than once, for example a
protein measured on two Olink panels) are averaged. By default the
direction of each marker is chosen so that the AUC is at least 0.5 (a
protein may be higher or lower in cases); set \`direction\` to fix it.
Curves are ordered by descending AUC (\`sort_by_auc = TRUE\`), and can
optionally display \`aucmat\`-style bootstrap sensitivity confidence
ribbons (\`add_ci = TRUE\`), binormal/density-smoothed ROC curves
(\`smooth_method = "binormal"\`), and paired statistical comparisons
between ROC curves (\`compare = TRUE\` via \`pROC::roc.test()\`). Each
curve is the apparent performance of a single protein on these samples,
with no cross-validation.

## Examples

``` r
# \donttest{
d <- probc[probc$Timepoint == 1, ]
plot_roc(d, assays = c("IL6", "TNF", "IL8"), group = "Project")

plot_roc(d, assays = c("IL6", "TNF", "IL8"), group = "Project",
         compare = TRUE, add_ci = TRUE)

# }
```
