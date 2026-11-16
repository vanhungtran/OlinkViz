# Correlation matrix of protein expression

Computes pairwise correlations between proteins (or samples) and renders
a correlation matrix plot. Uses \`corrplot::corrplot()\` for
visualization.

## Usage

``` r
plot_corr(
  data,
  method = "spearman",
  assay_col = NULL,
  value_col = NULL,
  sample_col = NULL,
  wide = NULL,
  top_n = 30,
  corr_type = "upper",
  display_method = "color",
  order = "hclust",
  tl.cex = NULL,
  show_coef = FALSE,
  coef_cex = NULL,
  col = NULL,
  cl_pos = "r",
  ...
)
```

## Arguments

- data:

  A data.frame in long format (or wide if \`wide = TRUE\`), or an
  [OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md).

- method:

  Correlation method: "pearson", "spearman" (default), or "kendall".

- assay_col:

  Name of the assay column (long format). If NULL, auto-detected (e.g.
  "Assay").

- value_col:

  Name of the NPX value column (long format). If NULL, auto-detected
  (e.g. "NPX").

- sample_col:

  Name of the sample ID column (long format). If NULL, auto-detected
  (e.g. "SampleID").

- wide:

  If TRUE, data is in wide format with samples as rows. If NULL
  (default), format is detected automatically.

- top_n:

  Limit to the top N assays by variance (default 30).

- corr_type:

  Type of corrplot: "full", "upper", or "lower" (default "upper").

- display_method:

  Visual method for corrplot: "color" (default), "circle", "ellipse",
  "number", "shade", or "pie".

- order:

  Ordering method: "hclust" (default), "AOE", "FPC", "alphabet", or
  "original".

- tl.cex:

  Text label size. If NULL (default), 0.7; in journal-size mode
  (\`options(olinkviz.base_size)\` below 11) the tick-label size,
  \`(base_size - 1) / 12\`.

- show_coef:

  Logical; if TRUE, print the numeric correlation coefficient inside
  each cell (corrplot \`addCoef.col\`). Default FALSE. Use with
  \`display_method = "circle"\` for a triangular coefficient matrix.

- coef_cex:

  Size of the coefficient labels. If NULL (default), 0.7; in
  journal-size mode (\`options(olinkviz.base_size)\` below 11) the
  tick-label size, \`(base_size - 1) / 12\`.

- col:

  Optional color palette (character vector) passed to corrplot. Defaults
  to a blue-white-red diverging palette.

- cl_pos:

  Position of the color legend: "r" (right), "l" (left), "b" (bottom),
  "t" (top), or "n" (none). Default "r".

- ...:

  Additional arguments passed to \`corrplot::corrplot()\`.

## Value

Invisibly returns the correlation matrix.

## Examples

``` r
if (FALSE) { # \dontrun{
# Column names and long/wide format are detected automatically
plot_corr(beatmg_npx, top_n = 20)
plot_corr(pcnsl_olink, top_n = 20)
} # }
```
