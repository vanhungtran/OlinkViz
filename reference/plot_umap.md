# UMAP projection of protein expression data

Performs Uniform Manifold Approximation and Projection (UMAP) on protein
expression data and plots the first two embedding dimensions. Requires
the \`umap\` package.

## Usage

``` r
plot_umap(
  data,
  color_by = NULL,
  assay_col = NULL,
  value_col = NULL,
  sample_col = NULL,
  n_neighbors = 15,
  min_dist = 0.1,
  metric = "euclidean",
  seed = 42,
  ellipse = TRUE,
  title = "UMAP of Protein Expression",
  palette = NULL,
  color = NULL,
  ...
)
```

## Arguments

- data:

  A data.frame in long format, or an
  [OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md).

- color_by, color:

  Optional column name to color points by groups.

- assay_col:

  Name of the assay column. If NULL, auto-detected (e.g. "Assay").

- value_col:

  Name of the NPX value column. If NULL, auto-detected (e.g. "NPX").

- sample_col:

  Name of the sample ID column. If NULL, auto-detected (e.g. "SampleID"
  or "SubjectID").

- n_neighbors:

  Number of neighbors for UMAP (default 15).

- min_dist:

  Minimum distance between embedded points (default 0.1).

- metric:

  Distance metric (default "euclidean").

- seed:

  Random seed for reproducibility.

- ellipse:

  Logical; draw confidence ellipses around groups (default TRUE).

- title:

  Plot title.

- palette:

  Optional color palette for groups; uses \`olinkviz_palette()\` if
  NULL.

- ...:

  Additional arguments passed to \`umap::umap()\`.

## Value

A ggplot object.

## Examples

``` r
if (FALSE) { # \dontrun{
plot_umap(beatmg_npx, color_by = "Timepoint", n_neighbors = 10)
} # }
```
