# Plot one or more dimensionality reductions of an OlinkExperiment

Creates a scatter plot of a low-dimensional representation of protein
expression data (PCA, t-SNE, UMAP, ...) with points colored by a sample
covariate. When several reductions are requested (e.g.
`type = c("pca", "umap")`) they are plotted \*\*jointly\*\* as a
combined multi-panel figure.

## Usage

``` r
plot_dim_reduc(
  olinkobject,
  type = c("pca", "tsne", "umap"),
  color = NULL,
  label = NULL,
  ellipse = TRUE,
  ellipse_level = 0.95,
  title = NULL,
  scale = TRUE,
  center = TRUE,
  n_neighbors = 15,
  min_dist = 0.1,
  metric = "euclidean",
  perplexity = 30,
  seed = 42,
  assay_col = NULL,
  value_col = NULL,
  sample_col = NULL,
  ncol = NULL,
  palette = NULL,
  color_by = NULL,
  ...
)
```

## Arguments

- olinkobject:

  An
  [OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md)
  object, or a data.frame in long format.

- type:

  Character vector of dimensionality reductions to plot: one or more of
  `"pca"`, `"tsne"`, `"umap"`, or any names stored in
  [`reducedDims()`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
  (matched case-insensitively). With several types the panels are
  combined into a single figure (via `patchwork`). Defaults to `"pca"`.

- color, color_by:

  Optional name of a sample covariate (a column of
  `colData(olinkobject)`) used to color the points.

- label:

  Optional name of a sample covariate used to label the points.

- ellipse:

  Logical; draw confidence ellipses around groups (default TRUE).

- ellipse_level:

  Confidence level for the ellipses (default 0.95).

- title:

  Overall plot title. For a single panel this replaces the default
  per-panel title; for a joint figure it becomes the combined figure
  title (default `NULL`).

- scale:

  Logical; scale variables to unit variance before PCA (default TRUE).

- center:

  Logical; center variables before PCA (default TRUE).

- n_neighbors:

  Number of neighbors for UMAP (default 15).

- min_dist:

  Minimum distance between embedded UMAP points (default 0.1).

- metric:

  Distance metric for UMAP (default "euclidean").

- perplexity:

  Perplexity for t-SNE (default 30).

- seed:

  Random seed for reproducibility (default 42).

- assay_col, value_col, sample_col:

  Optional column names (long-format input only). If `NULL`, they are
  auto-detected from common names.

- ncol:

  Number of columns when several reductions are combined into a joint
  figure (default `NULL`, i.e. auto).

- palette:

  Optional color palette for groups; uses
  [`olinkviz_palette()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_palette.md)
  if `NULL`.

- ...:

  Additional arguments passed to
  [`ggplot2::geom_point()`](https://ggplot2.tidyverse.org/reference/geom_point.html).

## Value

A ggplot object (single type) or a `patchwork` combined figure (several
types).

## Details

If a requested reduction is already stored in `reducedDims(olinkobject)`
(matched case-insensitively, e.g. `type = "pca"` matches a stored
`"PCA"`), the stored coordinates are used. Otherwise the reduction is
computed on the fly:

- `"pca"`: principal component analysis via
  [`stats::prcomp()`](https://rdrr.io/r/stats/prcomp.html).

- `"umap"`: UMAP via the `umap` package.

- `"tsne"`: t-SNE via the `Rtsne` package (optional dependency; install
  with `install.packages("Rtsne")`).

Any other `type` must match the (case-insensitive) name of an existing
entry in `reducedDimNames(olinkobject)`.

## Examples

``` r
if (FALSE) { # \dontrun{
oe <- oe_from_long(iris_longcovid)
plot_dim_reduc(oe, type = "pca", color = "long_covid")

# plot several reductions jointly
plot_dim_reduc(oe, type = c("pca", "umap", "tsne"), color = "long_covid")

# plot a reduction stored in reducedDims(oe)
reducedDim(oe, "UMAP") <- matrix(rnorm(ncol(oe) * 2), ncol = 2,
  dimnames = list(colnames(oe), c("UMAP1", "UMAP2")))
plot_dim_reduc(oe, type = "umap", color = "long_covid")
} # }
```
