# Check stroke weights against a journal's minimum line weight

Walks the drawn plot and finds the thinnest visible stroke (axis lines,
ticks, grid lines, error bars, outlines), in points. Strokes thinner
than the journal's minimum weight raise a \[warning()\]; a journal whose
guide states no minimum is checked against 0.25 pt.

## Usage

``` r
olinkviz_check_lines(
  plot,
  journal = getOption("olinkviz.journal", "nature"),
  min_pt = NULL
)
```

## Arguments

- plot:

  A ggplot or patchwork object.

- journal:

  Any registered journal id (see \[journal_specs()\]).

- min_pt:

  Override the minimum line weight, in points.

## Value

A data frame with one row per offending run of strokes (\`element\`,
\`lw_pt\`, \`n\`, \`limit_pt\`), invisibly.

## See also

Other checks:
[`olinkviz_check_colour()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_colour.md),
[`olinkviz_check_fit()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_fit.md),
[`olinkviz_check_size()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_size.md),
[`olinkviz_check_text()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_text.md),
[`olinkviz_preflight()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_preflight.md)

## Examples

``` r
library(ggplot2)
p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_smooth(method = "lm", formula = y ~ x, linewidth = 0.05) +
  theme_journal("cell")
res <- suppressWarnings(olinkviz_check_lines(p, "cell"))
res
#> <lines check, journal 'cell'> 1 issue row(s)
#>      element     lw_pt n limit_pt
#>  data stroke 0.1066978 1      0.5
```
