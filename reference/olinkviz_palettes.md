# OlinkViz themed and journal palettes (named list)

Returns the OlinkViz themed palettes as a named list (or all built-in +
journal palettes when \`include_journal = TRUE\`), or a single palette
by name. Supported names include \`"sunbird"\`, \`"redcap"\`,
\`"jewel"\`, \`"scarlet"\`, \`"okabe_ito"\`, \`"nature"\`, \`"npg"\`,
\`"aaas"\` (\`"science"\`), \`"nejm"\`, \`"lancet"\`, \`"jama"\`,
\`"bmj"\`, \`"jco"\`, and \`"editorial"\`.

## Usage

``` r
olinkviz_palettes(name = NULL, include_journal = FALSE)
```

## Arguments

- name:

  Optional palette name. If \`NULL\` (default), palettes are returned as
  a named list.

- include_journal:

  Logical; if \`TRUE\` and \`name\` is \`NULL\`, also include the
  journal-inspired and Okabe-Ito palettes (default \`FALSE\` for
  backward compatibility).

## Value

A named list of palettes if \`name\` is \`NULL\`, otherwise a character
vector of hex color codes.

## See also

Other palettes:
[`olinkviz_palette()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_palette.md),
[`scale_colour_olinkviz()`](https://vanhungtran.github.io/OlinkViz/reference/scale_colour_olinkviz.md)

## Examples

``` r
names(olinkviz_palettes())
#> [1] "sunbird" "redcap"  "jewel"   "scarlet"
names(olinkviz_palettes(include_journal = TRUE))
#>  [1] "sunbird"   "redcap"    "jewel"     "scarlet"   "okabe_ito" "nature"   
#>  [7] "npg"       "aaas"      "science"   "nejm"      "lancet"    "jama"     
#> [13] "bmj"       "jco"       "editorial"
olinkviz_palettes("okabe_ito")
#> [1] "#0072B2" "#D55E00" "#009E73" "#E69F00" "#56B4E9" "#CC79A7" "#F0E442"
#> [8] "#000000"
olinkviz_palettes("npg")
#>  [1] "#E64B35" "#4DBBD5" "#00A087" "#3C5488" "#F39B7F" "#8491B4" "#91D1C2"
#>  [8] "#DC0000" "#7E6148" "#B09C85"
```
