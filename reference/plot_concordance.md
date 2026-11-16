# Cross-cohort or cross-contrast effect-size concordance scatter plot

Plots per-protein effect sizes from two cohorts, platforms, or contrasts
against each other, annotates Pearson r, Spearman rho, and
sign-concordance percentage, and optionally labels the top concordant or
discordant proteins.

## Usage

``` r
plot_concordance(
  data,
  x_col,
  y_col,
  assay_col = "Assay",
  max_labels = 10,
  show_stats = TRUE,
  show_smooth = TRUE,
  identity_line = FALSE,
  colors = c(Same = "#009E73", Opposite = "#D55E00"),
  xlab = x_col,
  ylab = y_col,
  title = NULL
)
```

## Arguments

- data:

  A data.frame with one row per shared protein.

- x_col, y_col:

  Names of the two numeric effect-size columns.

- assay_col:

  Optional protein label column name (default \`"Assay"\`).

- max_labels:

  Number of top extreme proteins (by \`\|x\| + \|y\|\`) to label when
  \`assay_col\` is present (default \`10\`; \`0\` disables).

- show_stats:

  Logical; annotate Pearson r, Spearman rho, and in the subtitle
  (default \`TRUE\`).

- show_smooth:

  Logical; overlay a linear regression line with 95 (default \`TRUE\`).

- identity_line:

  Logical; draw the \`y = x\` dashed diagonal (default \`FALSE\`).

- colors:

  Named vector of length 2 for \`"Same"\` and \`"Opposite"\` sign
  quadrants.

- xlab, ylab:

  Axis labels (default \`x_col\`, \`y_col\`).

- title:

  Optional plot title.

## Value

A \`ggplot\` object.

## Examples

``` r
set.seed(42)
df <- data.frame(
  Assay = paste0("P", 1:60),
  cohort1 = rnorm(60),
  cohort2 = rnorm(60)
)
df$cohort2 <- 0.65 * df$cohort1 + rnorm(60, 0, 0.5)
plot_concordance(df, "cohort1", "cohort2", title = "Cohort Replication")
```
