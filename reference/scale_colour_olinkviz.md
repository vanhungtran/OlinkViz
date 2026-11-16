# Discrete colour and fill scales using OlinkViz and journal palettes

Convenience \`ggplot2\` discrete scales backed by
\[olinkviz_palette()\].

## Usage

``` r
scale_colour_olinkviz(palette = "okabe_ito", ...)

scale_color_olinkviz(palette = "okabe_ito", ...)

scale_fill_olinkviz(palette = "okabe_ito", ...)
```

## Arguments

- palette:

  Palette name passed to \[olinkviz_palette()\] (default
  \`"okabe_ito"\`), or a custom character vector of hex colors.

- ...:

  Additional arguments passed to \[ggplot2::discrete_scale()\].

## Value

A \`ggplot2\` scale object.

## See also

Other palettes:
[`olinkviz_palette()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_palette.md),
[`olinkviz_palettes()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_palettes.md)

## Examples

``` r
library(ggplot2)
ggplot(mtcars, aes(wt, mpg, colour = factor(cyl))) +
  geom_point(size = 2) +
  scale_colour_olinkviz("okabe_ito") +
  theme_journal("nature")
```
