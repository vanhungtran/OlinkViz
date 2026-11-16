# OlinkViz color palette

Returns a vector of colors suitable for categorical grouping in OlinkViz
plots. Accepts any \`RColorBrewer\` qualitative palette name (default
\`"Dark2"\`), one of the OlinkViz themed palettes (\`"sunbird"\`,
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
  themed palette (\`"sunbird"\`, \`"redcap"\`, \`"jewel"\`,
  \`"scarlet"\`), or a character vector of color codes.

## Value

A character vector of hex color codes of length \`n\`.

## Examples

``` r
olinkviz_palette(4)
#> [1] "#1B9E77" "#D95F02" "#7570B3" "#E7298A"
olinkviz_palette(4, "jewel")
#> [1] "#0C8542" "#592263" "#9E1231" "#2A2C46"
olinkviz_palette(12)  # interpolated beyond palette max
#>  [1] "#1B9E77" "#93752C" "#BD6332" "#7E6EA2" "#B3499C" "#CF3F76" "#7D8F31"
#>  [8] "#A0A811" "#E0A604" "#B78415" "#8E7037" "#666666"
```
