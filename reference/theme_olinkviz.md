# OlinkViz ggplot2 theme

A clean, publication-ready ggplot2 theme for OlinkViz plots. Builds on
\`theme_bw()\` with minimal gridlines and consistent typography.

## Usage

``` r
theme_olinkviz(
  base_size = .ov_base(),
  base_family = "sans",
  axes = getOption("olinkviz.axes", "box")
)
```

## Arguments

- base_size:

  Base font size in points. Defaults to
  \`getOption("olinkviz.base_size", 11)\`.

- base_family:

  Base font family (default "sans").

- axes:

  \`"box"\` (default; full panel frame) or \`"l"\` (left and bottom axis
  lines only). Defaults to \`getOption("olinkviz.axes", "box")\`.

## Value

A ggplot2 theme object.

## Details

All \`plot\_\*()\` functions size their text and marks from the same
base size, so a figure can be drawn at its final journal size. Set it
once per session:

“\` options(olinkviz.base_size = 7) \# 7 pt body text for a 89 mm column
options(olinkviz.axes = "l") \# left and bottom axis lines, no frame “\`

## See also

Other themes:
[`theme_editorial()`](https://vanhungtran.github.io/OlinkViz/reference/theme_editorial.md),
[`theme_journal()`](https://vanhungtran.github.io/OlinkViz/reference/theme_journal.md),
[`theme_journal_text()`](https://vanhungtran.github.io/OlinkViz/reference/theme_journal_text.md)

## Examples

``` r
library(ggplot2)
ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_olinkviz()

ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_olinkviz(base_size = 7, axes = "l")
```
