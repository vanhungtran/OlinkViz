# Add a bold panel letter (a, b, c...) matching journal house style

Prefer \[olinkviz_combine()\] for multi-panel figures (whose \`journal\`
argument sets panel tags automatically, including the right case and
point size); this helper tags a single ggplot.

## Usage

``` r
labs_panel(label, size = NULL, journal = NULL)
```

## Arguments

- label:

  Panel letter. Without \`journal\` it is used as written; with
  \`journal\` it is converted to that journal's case (\`"lower"\` for
  Nature, \`"upper"\` for Cell Press, Science, PNAS, PLOS, JID).

- size:

  Font size in pt. \`NULL\` (default) uses the journal's panel-tag size
  when \`journal\` is given and 10 pt otherwise.

- journal:

  Optional registered journal id (see \[journal_specs()\]) whose
  panel-tag case and size to use.

## Value

A list of ggplot layers / theme elements to add with \`+\`.

## See also

Other export:
[`olinkviz_combine()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_combine.md),
[`save_olinkviz()`](https://vanhungtran.github.io/OlinkViz/reference/save_olinkviz.md)

## Examples

``` r
library(ggplot2)
ggplot(mtcars, aes(wt, mpg)) +
  geom_point() +
  theme_journal("nature") +
  labs_panel("a", journal = "nature")
```
