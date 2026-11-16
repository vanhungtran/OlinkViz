# Set OlinkViz sizing options

Convenience wrapper around the two options that control how every
\`plot\_\*()\` function sizes its text and marks: \`olinkviz.base_size\`
(body text in points) and \`olinkviz.axes\` (\`"box"\` or \`"l"\`). See
\[theme_olinkviz()\].

## Usage

``` r
olinkviz_options(base_size = NULL, axes = NULL)
```

## Arguments

- base_size:

  Body text size in points (between 4 and 40). The default of the
  package is 11.

- axes:

  \`"box"\` (full panel frame, the default) or \`"l"\` (left and bottom
  axis lines only).

## Value

Invisibly, the previous values of the options, so they can be restored
with \`options(old)\`.

## Details

Draw a figure at its final size instead of shrinking it afterwards: for
a 89 mm single column use \`base_size = 7\`, then export with
\[save_olinkviz()\] at that width.

Tick labels and legend text are \`base_size - 1\` points, the smallest
text in a plot, so choose a base size one point above the smallest text
your journal allows: 7 for most journals, 9 where the minimum is 8 pt.
Any base size below the 11 pt default also switches on the behaviour
that depends on the canvas: long titles and facet labels wrap,
\`-log10\` labels are plain text, \`plot_corr_triangle()\` fits its
circles to the grid and \`plot_heatmap()\` leaves out sample names that
cannot be read.

## Examples

``` r
old <- olinkviz_options(base_size = 7, axes = "l")
getOption("olinkviz.base_size")
#> [1] 7
options(old)  # back to the previous settings
```
