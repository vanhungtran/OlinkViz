# LMER point-range plot

Produces the "point-range" plot used in the NUMAB reports to visualize a
linear mixed model: observed mean +/- SE per combination of an x-axis
variable and a grouping variable, faceted by protein. If \`lme4\` is
available and a random-effect subject column is supplied, a linear mixed
model \`value ~ x \* group + (1 \| random)\` is fitted per protein and
the group-effect p-value is annotated on each panel.

## Usage

``` r
plot_lmer(
  data,
  assay = NULL,
  x = NULL,
  group = NULL,
  random = NULL,
  assay_col = NULL,
  value_col = NULL,
  lod_col = NULL,
  show_lod = FALSE,
  ci_level = 0.95,
  add_pvalue = FALSE,
  dodge_width = 0.2,
  palette = NULL,
  title = NULL,
  ...
)
```

## Arguments

- data:

  A data.frame in long format, or an
  [OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md).

- assay:

  Optional assay name(s) to plot. If NULL, all assays are plotted and
  the plot is faceted by assay.

- x:

  Name of the x-axis variable (e.g. "Timepoint"). If NULL,
  auto-detected.

- group:

  Column name for the grouping/color variable (e.g. "TreatGroup"). If
  NULL, auto-detected.

- random:

  Optional column name for the random-effect subject identifier (e.g.
  "PPID"). Required to fit the mixed model.

- assay_col:

  Name of the assay column. If NULL, auto-detected (e.g. "Assay").

- value_col:

  Name of the NPX value column. If NULL, auto-detected (e.g. "NPX").

- lod_col:

  Optional column name holding an LOD value; draws a dashed LOD
  reference line when supplied.

- show_lod:

  Logical; if \`TRUE\`, auto-detects the LOD column and draws a dashed
  reference line (default \`FALSE\`).

- ci_level:

  Confidence level for the error bars (default 0.95).

- add_pvalue:

  Logical; fit the mixed model and annotate the group-effect p-value per
  panel (default FALSE to keep the function dependency-light).

- dodge_width:

  Horizontal offset between groups at the same x (default 0.2).

- palette:

  Optional color palette for groups.

- title:

  Plot title.

- ...:

  Additional arguments passed to \`ggplot2::geom_errorbar()\`.

## Value

A ggplot object.

## Examples

``` r
if (FALSE) { # \dontrun{
plot_lmer(
  numab_probc, assay = "IL6", x = "Timepoint",
  group = "TreatGroup", random = "PPID"
)
} # }
```
