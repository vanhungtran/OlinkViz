# PCA biplot of protein expression data

Performs principal component analysis on protein expression data and
plots the first two principal components. Samples are colored by an
optional grouping variable with confidence ellipses.

## Usage

``` r
plot_pca(
  data,
  color_by = NULL,
  label_by = NULL,
  assay_col = "Assay",
  value_col = "NPX",
  sample_col = "SampleID",
  scale = TRUE,
  center = TRUE,
  ellipse = TRUE,
  ellipse_level = 0.95,
  title = "PCA of Protein Expression",
  ...
)
```

## Arguments

- data:

  A data.frame in long format.

- color_by:

  Optional column name to color points by groups.

- label_by:

  Optional column name for sample point labels.

- assay_col:

  Name of the assay column (default "Assay").

- value_col:

  Name of the NPX value column (default "NPX").

- sample_col:

  Name of the sample ID column (default "SampleID").

- scale:

  Logical; scale variables to unit variance before PCA (default TRUE).

- center:

  Logical; center variables before PCA (default TRUE).

- ellipse:

  Logical; draw confidence ellipses around groups (default TRUE).

- ellipse_level:

  Confidence level for ellipses (default 0.95).

- title:

  Plot title.

- ...:

  Additional arguments passed to \`ggplot2::geom_point()\`.

## Value

A ggplot object.

## Examples

``` r
if (FALSE) { # \dontrun{
plot_pca(beatmg_npx, color_by = "Timepoint")
} # }
```
