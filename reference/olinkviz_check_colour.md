# Check that discrete colours stay distinguishable (colour-vision deficiency)

Collects the discrete colours each panel maps (up to 12 per layer),
simulates deuteranopia, protanopia, tritanopia and greyscale (Machado et
al. 2009), and reports the smallest CIEDE2000 distance between any two
colours in each. Below about 10 two groups are hard to tell apart; add a
shape, line type or direct labels.

## Usage

``` r
olinkviz_check_colour(plot, min_delta = 10)
```

## Arguments

- plot:

  A ggplot or patchwork object.

- min_delta:

  CIEDE2000 distance below which a pair is flagged.

## Value

A data frame of flagged panel / vision combinations (\`panel\`,
\`vision\`, \`min_delta\`, \`n_colours\`, \`pair\`, \`issue\`),
invisibly.

## See also

Other checks:
[`olinkviz_check_fit()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_fit.md),
[`olinkviz_check_lines()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_lines.md),
[`olinkviz_check_size()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_size.md),
[`olinkviz_check_text()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_text.md),
[`olinkviz_preflight()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_preflight.md)

## Examples

``` r
library(ggplot2)
p <- ggplot(mtcars, aes(wt, mpg, colour = factor(cyl))) +
  geom_point() +
  scale_colour_olinkviz("okabe_ito")
olinkviz_check_colour(p)
```
