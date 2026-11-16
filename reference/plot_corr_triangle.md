# Triangular correlation matrix with coefficient labels

Reproduces the classic "correlation triangle" style: a lower-triangular
matrix of pairwise assay (protein) correlations drawn as coloured
circles with the numeric correlation printed inside each circle. Row
labels on the left, column labels on the bottom.

## Usage

``` r
plot_corr_triangle(
  data,
  method = "spearman",
  assay_col = NULL,
  value_col = NULL,
  sample_col = NULL,
  wide = NULL,
  top_n = 30,
  show_values = NULL,
  circle_size = NULL,
  order = "hclust",
  title = NULL,
  palette = NULL,
  x_angle = NULL,
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

  Name of the assay column (long format). If NULL, auto-detected.

- value_col:

  Name of the NPX value column (long format). If NULL, auto-detected.

- sample_col:

  Name of the sample ID column (long format). If NULL, auto-detected.

- wide:

  If TRUE, data is in wide format with samples as rows. If NULL
  (default), format is detected automatically.

- top_n:

  Limit to the top N assays by variance (default 30).

- show_values:

  Logical; if TRUE, print the numeric correlation coefficient inside
  each circle. If NULL (default), values are shown, except in
  journal-size mode (\`options(olinkviz.base_size)\` below 11) when the
  circles are too small to hold them at the tick-label size (under about
  6.4 mm at 7 pt).

- circle_size:

  Diameter of the circles (ggplot mm). If NULL (default), 14 mm; in
  journal-size mode (\`options(olinkviz.base_size)\` below 11) the
  circles instead fill their grid cell in a single 89 mm column: 85
  percent of 65 mm divided by the number of assays, at most 14 mm. Set
  it explicitly for a wider figure.

- order:

  Ordering of rows/columns: "hclust" (default), "AOE", "FPC",
  "alphabet", or "original".

- title:

  Plot title.

- palette:

  Optional themed palette for the circle fills: a palette name from
  \`olinkviz_palettes()\` (e.g. \`"jewel"\`) or a character vector of 5
  hex colors. Correlations are mapped onto 5 diverging bins (strong
  negative ... strong positive). If NULL (default), the classic
  rose/green/orange scheme is used (rose for negative, green/orange for
  positive).

- x_angle:

  Angle of the column labels in degrees. If NULL (default), 60; 90
  (vertical, which never overlaps its neighbours) in journal-size mode
  (\`options(olinkviz.base_size)\` below 11).

- ...:

  Additional arguments passed to \`ggplot2::theme()\`.

## Value

A ggplot object.

## Details

Circles are filled rose/pink for negative correlations, green (weak) or
orange (strong) for positive correlations; the circle border encodes
significance tiers (blue / orange / red), and strong correlations get a
thick border - the same green/orange + border style as the reference
correlation-triangle plot, with negatives in rose/pink.

## Examples

``` r
if (FALSE) { # \dontrun{
plot_corr_triangle(beatmg_npx, top_n = 20)
} # }
```
