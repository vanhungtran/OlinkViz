# Assay detectability: percent of samples above the limit of detection

For every assay (and panel) computes the percentage of samples whose NPX
is above the limit of detection (LOD) and draws the assays ranked from
least to most detectable. Assays below \`threshold\` are highlighted and
the least detectable ones are labelled. A quick way to decide which
proteins are worth analysing.

## Usage

``` r
plot_lod(
  data,
  assay_col = NULL,
  value_col = NULL,
  lod_col = NULL,
  panel_col = NULL,
  threshold = 50,
  label_below = TRUE,
  max_labels = 10,
  title = NULL,
  ...
)
```

## Arguments

- data:

  A data.frame in long format (one row per sample and assay) with an LOD
  column.

- assay_col:

  Name of the assay column. If NULL, auto-detected.

- value_col:

  Name of the NPX value column. If NULL, auto-detected.

- lod_col:

  Name of the LOD column. If NULL (default), the first of \`LOD\`,
  \`PlateLOD\` and \`MaxLOD\` that is present is used.

- panel_col:

  Name of the Olink panel column. If NULL (default), a column called
  \`Panel\` is used when present. With several panels, one facet per
  panel is drawn.

- threshold:

  Percentage of samples above LOD below which an assay is flagged
  (default 50). This is a convention, not a rule: adjust it to your
  study.

- label_below:

  Logical; label the least detectable assays that fall below
  \`threshold\` (default TRUE).

- max_labels:

  Maximum number of labels per panel (default 10).

- title:

  Plot title.

- ...:

  Additional arguments passed to \`ggplot2::geom_point()\`.

## Value

A ggplot object. \`p\$data\` has one row per assay and panel with the
columns \`.pct_above\`, \`.n\` and \`.below\`.

## Examples

``` r
# \donttest{
plot_lod(probc, threshold = 75)

# }
```
