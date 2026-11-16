# Check text sizes against a journal's limits

Walks the drawn plot (axis labels, titles, legends, facet strips,
\`geom_text()\` / \`annotate()\` / ggrepel labels, panel tags) and
compares every text size, in points, with the journal's limits:
\*\*below the minimum\*\* is a \[warning()\] (text a journal may reject
as illegible); \*\*above a maximum the guide states\*\* (Nature: 7 pt)
is a \[message()\]. Panel tags have their own size and are exempt from
the maximum.

## Usage

``` r
olinkviz_check_text(
  plot,
  journal = getOption("olinkviz.journal", "nature"),
  min_pt = NULL,
  max_pt = NULL
)
```

## Arguments

- plot:

  A ggplot or patchwork object.

- journal:

  Any registered journal id (see \[journal_specs()\]).

- min_pt, max_pt:

  Override the journal's smallest / largest text size, in points (\`NA\`
  for no limit).

## Value

A data frame with one row per offending run of text (\`element\`,
\`label\`, \`size_pt\`, \`n\` items, \`issue\`, \`limit_pt\`),
invisibly; zero rows means everything is within the limits.

## See also

Other checks:
[`olinkviz_check_colour()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_colour.md),
[`olinkviz_check_fit()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_fit.md),
[`olinkviz_check_lines()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_lines.md),
[`olinkviz_check_size()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_size.md),
[`olinkviz_preflight()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_preflight.md)

## Examples

``` r
library(ggplot2)
p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  annotate("text", x = 4, y = 30, label = "tiny", size = 1.2) +
  theme_journal("nature")
res <- suppressWarnings(olinkviz_check_text(p, "nature"))
res
#> <text check, journal 'nature'> 1 issue row(s)
#>       element label size_pt n     issue limit_pt
#>  in-plot text  tiny   3.414 1 below_min        5
```
