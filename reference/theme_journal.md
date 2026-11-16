# Journal theme driven by the journal specification registry

Clean white canvas with hairline L-axes, no panel border, and text
sizes, font family, panel-tag size, and minimum stroke weight read from
a journal's specification (\[journal_spec()\]). No text falls below the
journal's minimum (\`font_min_pt\`) and the plot title never exceeds the
journal's maximum (\`font_max_pt\`, e.g. 7 pt for Nature).

## Usage

``` r
theme_journal(
  journal = getOption("olinkviz.journal", "nature"),
  base_size = NULL,
  base_family = NULL,
  grid = c("none", "y", "x", "both"),
  axis_line = TRUE,
  bold_axis_titles = FALSE,
  legend_position = "bottom"
)
```

## Arguments

- journal:

  Any registered journal id (see \[journal_specs()\]). Defaults to
  \`getOption("olinkviz.journal", "nature")\`.

- base_size:

  Body size in pt. \`NULL\` (default) uses the journal's recommended
  body size.

- base_family:

  Font family. \`NULL\` (default) uses \[journal_font()\].

- grid:

  One of \`"none"\` (default), \`"y"\`, \`"x"\`, \`"both"\`.

- axis_line:

  Draw left and bottom axis lines (\`TRUE\` by default).

- bold_axis_titles:

  Bold axis and legend titles (\`TRUE\` matches Cell Press house style;
  default \`FALSE\`).

- legend_position:

  Legend position (\`"bottom"\` by default).

## Value

A \[ggplot2::theme()\] object.

## Details

Pair it with \[journal_width()\] / \[save_olinkviz()\] at the same
\`journal\`, and with \`olinkviz_combine(journal = )\` for panel tags.
To adjust only the text sizes of an existing plot without replacing its
axis or legend theme settings, use \[theme_journal_text()\].

## See also

Other themes:
[`theme_editorial()`](https://vanhungtran.github.io/OlinkViz/reference/theme_editorial.md),
[`theme_journal_text()`](https://vanhungtran.github.io/OlinkViz/reference/theme_journal_text.md),
[`theme_olinkviz()`](https://vanhungtran.github.io/OlinkViz/reference/theme_olinkviz.md)

## Examples

``` r
library(ggplot2)
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_journal("nature")

ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_journal("cell", bold_axis_titles = TRUE)
```
