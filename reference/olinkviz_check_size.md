# Check figure dimensions (and raster resolution) against a journal

Compares an intended figure size with the journal's registry entry: a
width beyond the journal's widest column and a height beyond its maximum
(where the guide states one) raise a \[warning()\], as does a raster
resolution below the journal's halftone requirement when \`dpi\` is
given.

## Usage

``` r
olinkviz_check_size(
  width = "double",
  height = 100,
  journal = getOption("olinkviz.journal", "nature"),
  units = c("mm", "in", "cm"),
  dpi = NULL
)
```

## Arguments

- width, height:

  Figure size, in \`units\`. \`width\` may also be a width keyword for
  \[journal_width()\] (\`"single"\`, \`"double"\`, ...).

- journal:

  Any registered journal id (see \[journal_specs()\]).

- units:

  \`"mm"\` (default), \`"in"\` or \`"cm"\` for numeric
  \`width\`/\`height\`.

- dpi:

  Optional raster resolution of the file you will submit.

## Value

A data frame with one row per problem (\`check\`, \`value\`, \`limit\`,
\`message\`), invisibly.

## See also

Other checks:
[`olinkviz_check_colour()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_colour.md),
[`olinkviz_check_fit()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_fit.md),
[`olinkviz_check_lines()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_lines.md),
[`olinkviz_check_text()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_text.md),
[`olinkviz_preflight()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_preflight.md)

## Examples

``` r
olinkviz_check_size(width = "double", height = 100, journal = "nature")
res <- suppressWarnings(olinkviz_check_size(180, 200, "nature", units = "mm"))
res$message
#> [1] "height 200 mm exceeds the 170 mm maximum for nature"
```
