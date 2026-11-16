# PCA scatter plot of protein expression data

Convenience wrapper around \[plot_dim_reduc()\] with \`type = "pca"\`.

## Usage

``` r
plot_pca(data, color_by = NULL, color = NULL, ...)
```

## Arguments

- data:

  A data.frame in long format, or an
  [OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md).

- color_by, color:

  Optional column name to color points by groups.

- ...:

  Additional arguments passed to \[plot_dim_reduc()\].

## Value

A ggplot object.
