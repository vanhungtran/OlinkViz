# PCA scree plot (variance explained)

Plots the proportion of variance explained by each principal component,
with a cumulative line. Accepts either a fitted \`prcomp\` object or
long-format NPX data (PCA is computed internally).

## Usage

``` r
plot_scree(
  x,
  assay_col = NULL,
  value_col = NULL,
  sample_col = NULL,
  scale = TRUE,
  center = TRUE,
  n_pcs = 10,
  cumulative = TRUE,
  title = NULL,
  ...
)
```

## Arguments

- x:

  A \`prcomp\` object, an
  [OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md),
  or a data.frame in long format.

- assay_col:

  Name of the assay column (long format). If NULL, auto-detected (e.g.
  "Assay").

- value_col:

  Name of the NPX value column (long format). If NULL, auto-detected
  (e.g. "NPX").

- sample_col:

  Name of the sample ID column (long format). If NULL, auto-detected
  (e.g. "SampleID").

- scale:

  Logical; scale variables to unit variance before PCA (default TRUE).

- center:

  Logical; center variables before PCA (default TRUE).

- n_pcs:

  Number of principal components to display (default 10).

- cumulative:

  Logical; overlay the cumulative variance line (default TRUE).

- title:

  Plot title.

- ...:

  Additional arguments passed to \`ggplot2::geom_col()\`.

## Value

A ggplot object.

## Examples

``` r
if (FALSE) { # \dontrun{
# From long-format data
plot_scree(beatmg_npx_merged[beatmg_npx_merged$Timepoint == 1, ])

# From an existing prcomp object
pc <- prcomp(scale = TRUE, x = NULL)
plot_scree(pc)
} # }
```
