# OlinkViz color palette

Returns a vector of colors suitable for categorical grouping in OlinkViz
plots. Accepts any \`RColorBrewer\` qualitative palette name (default
\`"Dark2"\`), any palette in \[olinkviz_palettes()\] (\`"okabe_ito"\`,
\`"nature"\`, \`"npg"\`, \`"aaas"\`, \`"nejm"\`, \`"lancet"\`,
\`"jama"\`, \`"bmj"\`, \`"jco"\`, \`"editorial"\`, \`"sunbird"\`,
\`"redcap"\`, \`"jewel"\`, \`"scarlet"\`), or a custom character vector
of colors, extending or interpolating to length \`n\`.

## Usage

``` r
olinkviz_palette(n = 8, palette = "Dark2")
```

## Arguments

- n:

  Number of colors to return.

- palette:

  Name of an \`RColorBrewer\` palette (default \`"Dark2"\`), an OlinkViz
  / journal palette (see \[olinkviz_palettes()\]), or a character vector
  of color codes.

## Value

A character vector of hex color codes of length \`n\`.

## See also

Other palettes:
[`olinkviz_palettes()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_palettes.md),
[`scale_colour_olinkviz()`](https://vanhungtran.github.io/OlinkViz/reference/scale_colour_olinkviz.md)

## Examples

``` r
olinkviz_palette(4)
#> [1] "#1B9E77" "#D95F02" "#7570B3" "#E7298A"
olinkviz_palette(4, "okabe_ito")
#> [1] "#0072B2" "#D55E00" "#009E73" "#E69F00"
olinkviz_palette(6, "npg")
#> [1] "#E64B35" "#4DBBD5" "#00A087" "#3C5488" "#F39B7F" "#8491B4"
olinkviz_palette(12)  # interpolated beyond palette max
#>  [1] "#1B9E77" "#93752C" "#BD6332" "#7E6EA2" "#B3499C" "#CF3F76" "#7D8F31"
#>  [8] "#A0A811" "#E0A604" "#B78415" "#8E7037" "#666666"
```
