# PCA loadings plot

Shows the variables (proteins) with the largest loadings for each of the
top principal components. Accepts either a fitted \`prcomp\` object or
long-format NPX data (PCA is computed internally).

## Usage

``` r
plot_loadings(
  x,
  assay_col = NULL,
  value_col = NULL,
  sample_col = NULL,
  scale = TRUE,
  center = TRUE,
  components = 1:5,
  top_n = 10,
  title = NULL,
  ...
)
```

## Arguments

- x:

  A \`prcomp\` object or a data.frame in long format.

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

- components:

  Which principal components to show (default 1:5).

- top_n:

  Number of top loading variables to display per PC (default 10).

- title:

  Plot title.

- ...:

  Additional arguments passed to \`ggplot2::geom_col()\`.

## Value

A ggplot object.

## Examples

``` r
if (FALSE) { # \dontrun{
plot_loadings(beatmg_npx_merged[beatmg_npx_merged$Timepoint == 1, ],
              components = 1:4, top_n = 8)
} # }
```
