# Regression scatter plot with linear smooth

Scatter plot of one or more proteins' values against an x-axis variable
(e.g. time) with an overlaid linear (or other) smooth, optionally
colored by a grouping variable and/or faceted by a second variable.

## Usage

``` r
plot_regression(
  data,
  assay,
  x = NULL,
  color_by = NULL,
  facet_by = NULL,
  assay_col = NULL,
  value_col = NULL,
  method = "lm",
  se = TRUE,
  alpha_point = 0.7,
  palette = NULL,
  title = NULL,
  color = NULL,
  facet = NULL,
  ...
)
```

## Arguments

- data:

  A data.frame in long format, or an
  [OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md).

- assay:

  Name(s) of the protein/assay(s) to plot (must match values in
  \`assay_col\`).

- x:

  Name of the x-axis variable (e.g. "Time"). If NULL, auto-detected.

- color_by, color:

  Optional column name to color points and fits by.

- facet_by, facet:

  Optional column name to facet the plot by.

- assay_col:

  Name of the assay column. If NULL, auto-detected (e.g. "Assay").

- value_col:

  Name of the NPX value column. If NULL, auto-detected (e.g. "NPX").

- method:

  Smoothing method passed to \`ggplot2::stat_smooth()\`: "lm", "loess",
  "gam", etc. (default "lm").

- se:

  Logical; show confidence band around the smooth (default TRUE).

- alpha_point:

  Alpha for the points (default 0.7).

- palette:

  Optional color palette for \`color_by\`.

- title:

  Plot title. If NULL, uses the assay name.

- ...:

  Additional arguments passed to \`ggplot2::stat_smooth()\`.

## Value

A ggplot object.

## Examples

``` r
if (FALSE) { # \dontrun{
plot_regression(
  probc, assay = "IL6", x = "Time",
  color_by = "TreatGroup", facet_by = "TreatGroup"
)
} # }
```
