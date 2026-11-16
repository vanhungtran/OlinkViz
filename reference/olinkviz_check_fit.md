# Check whether the title/subtitle/caption will overflow the save width

Measures the natural (single-line, unwrapped) width of the plot title,
subtitle, and caption against the width you intend to save at, and
reports anything that would run past the page edge.

## Usage

``` r
olinkviz_check_fit(
  plot,
  width = "double",
  height = 100,
  journal = getOption("olinkviz.journal", "nature"),
  units = c("mm", "in", "cm"),
  margin_in = 0.2
)
```

## Arguments

- plot:

  A ggplot or patchwork object.

- width:

  Width in \`units\`, or a width keyword passed to \[journal_width()\].

- height:

  Height in \`units\`.

- journal:

  Any registered journal id; used when \`width\` is a keyword.

- units:

  \`"mm"\` (default), \`"in"\` or \`"cm"\`.

- margin_in:

  Estimated combined left+right plot margin, in inches.

## Value

A data frame with one row per overflowing element (\`element\`,
\`width_in\`, \`available_in\`, \`overflow_in\`), invisibly.

## See also

Other checks:
[`olinkviz_check_colour()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_colour.md),
[`olinkviz_check_lines()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_lines.md),
[`olinkviz_check_size()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_size.md),
[`olinkviz_check_text()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_text.md),
[`olinkviz_preflight()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_preflight.md)

## Examples

``` r
library(ggplot2)
p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  labs(title = "A title", subtitle = "A quite long subtitle that will not fit a narrow figure")
suppressWarnings(olinkviz_check_fit(p, width = "single"))
```
