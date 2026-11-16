# Combine ggplots into one tagged, journal-styled composite

Wrapper around patchwork that arranges several panels, wraps any panel
that is itself a composite (such as \[plot_upset()\]) so it receives a
single tag, applies the journal's panel-tag case and point size (\`"a"\`
at 8 pt bold for Nature, \`"A"\` at 9 pt for Cell Press, 10 pt for
Science), and collects shared legends. Requires the \`patchwork\`
package.

## Usage

``` r
olinkviz_combine(
  ...,
  ncol = NULL,
  nrow = NULL,
  design = NULL,
  widths = NULL,
  heights = NULL,
  guides = c("collect", "keep"),
  tag_levels = "a",
  journal = getOption("olinkviz.journal", "nature"),
  tag_size = NULL,
  title = NULL,
  subtitle = NULL
)
```

## Arguments

- ...:

  ggplot objects to combine, in row-major order, or a single list of
  them.

- ncol, nrow:

  Grid dimensions; leave both \`NULL\` to let patchwork choose a layout.

- design:

  Optional custom layout passed through to \[patchwork::wrap_plots()\].

- widths, heights:

  Relative panel widths / heights passed to
  \[patchwork::plot_layout()\].

- guides:

  \`"collect"\` (default) merges identical legends into one; \`"keep"\`
  leaves each panel's own legend in place.

- tag_levels:

  Panel-tag style passed to \[patchwork::plot_annotation()\] - \`"a"\`,
  \`"A"\`, \`"1"\`, or \`NULL\` to skip tagging. Leave unset to pick the
  case from \`journal\`.

- journal:

  Any registered journal id (see \[journal_specs()\]). Defaults to
  \`getOption("olinkviz.journal", "nature")\`.

- tag_size:

  Panel-tag size in pt; \`NULL\` (default) uses the journal's.

- title, subtitle:

  Composite-level title / subtitle.

## Value

A \`patchwork\` object ready for \[save_olinkviz()\] or
\[olinkviz_preflight()\].

## See also

Other export:
[`labs_panel()`](https://vanhungtran.github.io/OlinkViz/reference/labs_panel.md),
[`save_olinkviz()`](https://vanhungtran.github.io/OlinkViz/reference/save_olinkviz.md)

## Examples

``` r
if (requireNamespace("patchwork", quietly = TRUE)) {
  p1 <- plot_boxplot(probc[probc$Timepoint == 1, ], assay = "IL6",
                     group = "Project", test = "none")
  p2 <- plot_boxplot(probc[probc$Timepoint == 1, ], assay = "TNF",
                     group = "Project", test = "none")
  olinkviz_combine(p1, p2, journal = "nature", title = "Baseline cytokines")
}
```
