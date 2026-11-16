# Sample QC plot: median NPX versus interquartile range

The standard sample-level quality check for Olink data. For every sample
(and every panel, when the data has a \`Panel\` column) the median and
the interquartile range (IQR) of its NPX values are computed and drawn
against each other. A sample whose median or IQR lies more than
\`sd_cutoff\` standard deviations from the mean of all samples on that
panel is flagged as an outlier; dashed lines mark the cut-offs. Samples
that carry an Olink \`QC_Warning\` are drawn as triangles.

## Usage

``` r
plot_qc(
  data,
  assay_col = NULL,
  value_col = NULL,
  sample_col = NULL,
  panel_col = NULL,
  qc_col = NULL,
  color_by = NULL,
  sd_cutoff = 3,
  label_outliers = TRUE,
  title = NULL,
  ...
)
```

## Arguments

- data:

  A data.frame in long format (one row per sample and assay).

- assay_col:

  Name of the assay column. If NULL, auto-detected.

- value_col:

  Name of the NPX value column. If NULL, auto-detected.

- sample_col:

  Name of the sample ID column. If NULL, auto-detected.

- panel_col:

  Name of the column that identifies the Olink panel. If NULL (default),
  a column called \`Panel\` is used when present; otherwise all samples
  form a single group.

- qc_col:

  Name of the Olink QC flag column. If NULL (default), a column called
  \`QC_Warning\` is used when present. Any value other than \`"Pass"\`
  counts as a warning; a sample is marked when one of its values on that
  panel carries a warning.

- color_by:

  Optional sample-level column (for example plate or group) used for the
  point colour. If NULL (default), points are coloured by outlier
  status.

- sd_cutoff:

  Number of standard deviations from the panel mean beyond which a
  sample is an outlier (default 3).

- label_outliers:

  Logical; label the outlier samples with their ID (default TRUE; uses
  \`ggrepel\` when installed).

- title:

  Plot title.

- ...:

  Additional arguments passed to \`ggplot2::geom_point()\`.

## Value

A ggplot object. \`p\$data\` has one row per sample and panel with the
columns \`.median\`, \`.iqr\`, \`.outlier\` and \`.qc_warning\`.

## Examples

``` r
# \donttest{
plot_qc(probc)

plot_qc(probc, color_by = "PlateID", sd_cutoff = 2.5)

# }
```
