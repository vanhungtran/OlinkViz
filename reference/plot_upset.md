# UpSet plot of overlapping protein sets

Native \`ggplot2\` + \`patchwork\` UpSet plot showing exclusive
intersection sizes across two or more protein/biomarker sets (e.g.
significant hits across cohorts, timepoints, or contrasts), with
optional per-set size bars on the left.

## Usage

``` r
plot_upset(
  sets,
  n_intersections = 15,
  order = c("size", "degree"),
  min_size = 1,
  set_bars = TRUE,
  colour = "#0072B2",
  title = NULL,
  subtitle = NULL
)
```

## Arguments

- sets:

  Named list of two or more character vectors (protein/assay IDs).

- n_intersections:

  Maximum number of intersections to display (default \`15\`).

- order:

  \`"size"\` (default; largest intersection first) or \`"degree"\`
  (fewest sets first, then size).

- min_size:

  Minimum intersection size to include (default \`1\`).

- set_bars:

  Logical; show total set-size bars on the left (default \`TRUE\`).

- colour:

  Fill colour for the intersection size bars (default \`"#0072B2"\`).

- title, subtitle:

  Optional plot title and subtitle.

## Value

A \`patchwork\` object (or \`ggplot\` bar chart with a warning if
\`patchwork\` is not installed).

## Examples

``` r
sets <- list(
  CohortA = c("IL6", "TNF", "CXCL10", "CD40", "CCL2"),
  CohortB = c("IL6", "TNF", "IFNG", "IL10"),
  CohortC = c("IL6", "CD40", "IL10", "VEGFA")
)
plot_upset(sets, title = "Shared Significant Proteins")
```
