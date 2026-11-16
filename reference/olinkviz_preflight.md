# Run every pre-flight check on a figure and print one report

Runs the selected checks - size (\[olinkviz_check_size()\]), title fit
(\[olinkviz_check_fit()\]), text sizes (\[olinkviz_check_text()\]),
stroke weights (\[olinkviz_check_lines()\]) and colour-vision
distinguishability (\[olinkviz_check_colour()\]) - against one journal
and prints a one-screen report instead of raising a warning per finding.

## Usage

``` r
olinkviz_preflight(
  plot,
  journal = getOption("olinkviz.journal", "nature"),
  width = "double",
  height = 100,
  units = c("mm", "in", "cm"),
  dpi = NULL,
  checks = .cm_all_checks
)
```

## Arguments

- plot:

  A ggplot or patchwork object.

- journal:

  Any registered journal id (see \[journal_specs()\]).

- width, height:

  Intended save size in \`units\`; \`width\` may be a width keyword for
  \[journal_width()\]. \`height = "max"\` uses the journal's maximum.

- units:

  \`"mm"\` (default), \`"in"\` or \`"cm"\` for numeric
  \`width\`/\`height\`.

- dpi:

  Optional raster resolution of the file you will submit.

- checks:

  Which checks to run: any of \`"size"\`, \`"fit"\`, \`"text"\`,
  \`"lines"\`, \`"colour"\`.

## Value

An object of class \`olinkviz_preflight\` (a list with \`journal\`,
\`width_mm\`, \`height_mm\`, \`status\` - one of \`"ok"\`, \`"note"\`,
\`"warn"\`, \`"skip"\` per check - and the raw \`results\`), invisibly
after printing.

## See also

Other checks:
[`olinkviz_check_colour()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_colour.md),
[`olinkviz_check_fit()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_fit.md),
[`olinkviz_check_lines()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_lines.md),
[`olinkviz_check_size()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_size.md),
[`olinkviz_check_text()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_text.md)

## Examples

``` r
library(ggplot2)
p <- ggplot(mtcars, aes(wt, mpg, colour = factor(cyl))) +
  geom_point() +
  scale_colour_olinkviz("okabe_ito") +
  labs(title = "Fuel economy") +
  theme_journal("nature")
olinkviz_preflight(p, "nature", width = "single", height = 70)
#> Pre-flight: Nature [nature] - 90 x 70 mm (3.54 x 2.76 in)
#>   size    OK    single column width; height within 170 mm
#>   fit     OK    title, subtitle and caption fit
#>   text    OK    6-7 pt across 17 text item(s)
#>   lines   OK    thinnest stroke 0.64 pt (minimum 0.25 pt)
#>   colour  OK    min CIEDE2000 12.1 (tritan vision, 3 colours)
#>   all clear
```
