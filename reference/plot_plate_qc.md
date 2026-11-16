# Plate / batch NPX distribution plot

Summarizes sample-level or assay-level NPX distributions across plates
or batches to diagnose batch shifts before or after bridging
normalization. Draws a boxplot and jittered sample medians for each
plate/batch, with a dashed global median reference line.

## Usage

``` r
plot_plate_qc(
  data,
  plate_col = NULL,
  assay_col = NULL,
  value_col = NULL,
  sample_col = NULL,
  panel_col = NULL,
  palette = NULL,
  title = NULL,
  ...
)
```

## Arguments

- data:

  A data.frame in long format or an
  [OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md).

- plate_col:

  Name of the plate or batch column. If \`NULL\`, auto-detected from
  \`PlateID\`, \`Plate\`, \`Batch\`, \`batch\`, or \`Project\`.

- assay_col, value_col, sample_col, panel_col:

  Optional column names. If \`NULL\`, auto-detected.

- palette:

  Optional color palette for plates/batches.

- title:

  Plot title.

- ...:

  Additional arguments passed to \`ggplot2::geom_boxplot()\`.

## Value

A ggplot object. \`p\$data\` has one row per \`(sample, plate, panel)\`
with column \`.median\` holding the sample's median NPX.

## Examples

``` r
# \donttest{
plot_plate_qc(probc)

# }
```
