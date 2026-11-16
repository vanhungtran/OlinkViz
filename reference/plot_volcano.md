# Volcano plot for differential expression results

Creates a publication-ready volcano plot showing fold change versus
statistical significance for each protein/assay. Points are colored by
significance threshold.

## Usage

``` r
plot_volcano(
  data,
  pval_col = NULL,
  fc_col = NULL,
  label_col = NULL,
  assay_col = NULL,
  pval_threshold = 0.05,
  fc_threshold = 1,
  transform_fc = FALSE,
  max_labels = 15,
  title = NULL,
  padj_col = NULL,
  use_padj = FALSE,
  p_adjust_method = "BH",
  palette = NULL,
  ...
)
```

## Arguments

- data:

  A data.frame containing differential expression results. P-value and
  fold-change columns are auto-detected from common names (e.g.
  \`p.value\`/\`pval\` and \`log2FC\`/\`estimate\`).

- pval_col:

  Name of the column containing p-values. If NULL, auto-detected.

- fc_col:

  Name of the column containing fold changes (on log2 scale if already
  transformed; set \`transform_fc = TRUE\` for raw ratios). If NULL,
  auto-detected.

- label_col:

  Optional column with labels to display (e.g., protein names for
  significant hits). If NULL, \`assay_col\` is used for significant
  points.

- assay_col:

  Name of the assay/protein identifier column. If NULL, auto-detected
  (e.g. "Assay").

- pval_threshold:

  P-value (or adjusted p-value) threshold for significance (default
  0.05).

- fc_threshold:

  Absolute log2 fold change threshold (default 1, i.e. 2-fold).

- transform_fc:

  If TRUE, log2-transform the fold change column (default FALSE).

- max_labels:

  Maximum number of top significant points to label (default 15).

- title:

  Plot title.

- padj_col:

  Optional name of a column containing multiple-testing adjusted
  p-values (e.g. \`"Adjusted_pval"\`, \`"padj"\`, \`"FDR"\`). Used when
  \`use_padj = TRUE\` or when explicitly supplied.

- use_padj:

  Logical; if \`TRUE\`, plot and threshold on adjusted p-values
  (\`padj_col\` if present, otherwise \`stats::p.adjust(pvals, method =
  p_adjust_method)\`). Default \`FALSE\` (uses \`pval_col\`, unless
  \`padj_col\` is explicitly supplied).

- p_adjust_method:

  Method passed to \`stats::p.adjust()\` when \`use_padj = TRUE\` and no
  \`padj_col\` column is present in \`data\` (default \`"BH"\`).

- palette:

  Optional named or length-3 color vector for \`c("Up", "Down", "NS")\`.

- ...:

  Additional arguments passed to \`ggplot2::geom_point()\`.

## Value

A ggplot object.

## Examples

``` r
if (FALSE) { # \dontrun{
# Standard columns are detected automatically
plot_volcano(bansal_univariate)

# Plot adjusted p-values (BH FDR)
plot_volcano(bansal_univariate, use_padj = TRUE)
} # }
```
