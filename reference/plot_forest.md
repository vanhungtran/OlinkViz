# Forest plot of protein effect sizes and confidence intervals

Draws a horizontal forest plot of per-protein estimates and 95
intervals, optionally grouped by cohort, contrast, or significance.
Accepts either explicit \`lower_col\`/\`upper_col\` bounds or a
standard-error column (\`se_col\`), computing Wald intervals
automatically.

## Usage

``` r
plot_forest(
  data,
  assay_col = "Assay",
  estimate_col = "estimate",
  lower_col = NULL,
  upper_col = NULL,
  se_col = NULL,
  conf_level = 0.95,
  group = NULL,
  sig_col = NULL,
  top_n = NULL,
  order_by_effect = TRUE,
  ref = 0,
  palette = "okabe_ito",
  xlab = "Effect size (95% CI)",
  title = NULL
)
```

## Arguments

- data:

  A data.frame with one row per protein (or protein x group).

- assay_col:

  Name of the protein/label column (default \`"Assay"\`).

- estimate_col:

  Name of the effect-size column (default \`"estimate"\`).

- lower_col, upper_col:

  Optional column names for the lower and upper CI bounds. If omitted,
  \`se_col\` is used to compute \`estimate +/- z \* se\`.

- se_col:

  Optional standard-error column used when \`lower_col\` and
  \`upper_col\` are \`NULL\`.

- conf_level:

  Confidence level for Wald intervals when \`se_col\` is used (default
  \`0.95\`).

- group:

  Optional grouping column name for colour (e.g. cohort or panel).

- sig_col:

  Optional logical column name distinguishing filled (TRUE) vs open
  (FALSE) points.

- top_n:

  Optional integer: keep only the top \`top_n\` rows ranked by
  \`abs(estimate)\` when \`data\` is large.

- order_by_effect:

  Logical; sort assays by effect size (default \`TRUE\`).

- ref:

  Reference vertical line (default \`0\`).

- palette:

  Optional colour palette name or vector when \`group\` is used.

- xlab:

  x-axis label (default \`"Effect size (95% CI)"\`).

- title:

  Optional plot title.

## Value

A \`ggplot\` object.

## Examples

``` r
plot_forest(bansal_univariate, assay_col = "Assay", estimate_col = "estimate",
            lower_col = "conf.low", upper_col = "conf.high", top_n = 15)
```
