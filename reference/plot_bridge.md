# Bridge sample comparison plot (Bland-Altman or scatter)

Evaluates bridging reference samples measured across two Olink batches,
plates, or studies. Given either two data objects (\`data1\`, \`data2\`)
sharing common bridge \`SampleID\`s and \`Assay\`s, or a single data
object with a \`batch_col\` column containing two batches, computes
per-(sample, assay) paired NPX values and draws either a Bland-Altman
difference-vs-mean plot (\`type = "bland_altman"\`, default) or an
identity scatter plot (\`type = "scatter"\`).

## Usage

``` r
plot_bridge(
  data1,
  data2 = NULL,
  batch_col = NULL,
  batches = NULL,
  type = c("bland_altman", "scatter"),
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

- data1:

  A data.frame in long format or an
  [OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md).
  If \`data2\` is \`NULL\`, \`data1\` must contain a \`batch_col\`
  column with two levels (or two batches selected via \`batches\`).

- data2:

  Optional second data.frame in long format or
  [OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md)
  representing the second batch/plate.

- batch_col:

  Name of the batch or plate column when \`data2\` is \`NULL\`. If
  \`NULL\`, auto-detected from \`Batch\`, \`PlateID\`, \`Plate\`, or
  \`Project\`.

- batches:

  Optional length-2 character vector naming the two levels of
  \`batch_col\` to compare when \`data2\` is \`NULL\`.

- type:

  \`"bland_altman"\` (default; difference \`batch2 - batch1\` vs mean
  NPX with mean bias and 95 percent limits of agreement) or
  \`"scatter"\` (\`batch2\` vs \`batch1\` with identity line and Pearson
  r).

- assay_col, value_col, sample_col, panel_col:

  Optional column names. If \`NULL\`, auto-detected.

- palette:

  Optional color palette for panels/assays.

- title:

  Plot title.

- ...:

  Additional arguments passed to \`ggplot2::geom_point()\`.

## Value

A ggplot object. \`p\$data\` contains the paired bridge measurements
with columns \`SampleID\`, \`Assay\`, \`.panel\`, \`.npx1\`, \`.npx2\`,
\`.mean\`, and \`.diff\`.

## Examples

``` r
# \donttest{
# Compare two plates sharing overlapping sample IDs
b1 <- probc[probc$Timepoint == 1, ]
b2 <- b1
b2$NPX <- b1$NPX + rnorm(nrow(b1), mean = 0.15, sd = 0.2)
plot_bridge(b1, b2)

plot_bridge(b1, b2, type = "scatter")

# }
```
