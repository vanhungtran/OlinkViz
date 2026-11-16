# Journal text sizes, added to a plot without touching anything else

Applies the text sizes of \[theme_journal()\] to an existing ggplot or
patchwork composite (with \`+\` or \`&\`) while leaving hidden axes
(\`element_blank()\`), legend placement, and panel borders untouched.

## Usage

``` r
theme_journal_text(
  journal = getOption("olinkviz.journal", "nature"),
  base_size = NULL
)
```

## Arguments

- journal:

  Any registered journal id (see \[journal_specs()\]).

- base_size:

  Body size in pt. \`NULL\` (default) uses the journal's recommended
  body size.

## Value

An object of class \`olinkviz_text_theme\` to add to a plot with \`+\`
or \`&\`.

## See also

Other themes:
[`theme_editorial()`](https://vanhungtran.github.io/OlinkViz/reference/theme_editorial.md),
[`theme_journal()`](https://vanhungtran.github.io/OlinkViz/reference/theme_journal.md),
[`theme_olinkviz()`](https://vanhungtran.github.io/OlinkViz/reference/theme_olinkviz.md)

## Examples

``` r
p <- plot_volcano(bansal_univariate, pval_col = "p.value", fc_col = "estimate",
                  fc_threshold = 0.1)
p + theme_journal_text("nature")
```
