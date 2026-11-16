# OlinkViz themed palettes (named list)

Returns all themed palettes as a named list, or a single palette by
name.

## Usage

``` r
olinkviz_palettes(name = NULL)
```

## Arguments

- name:

  Optional palette name: \`"sunbird"\`, \`"redcap"\`, \`"jewel"\`, or
  \`"scarlet"\`. If NULL (default), all palettes are returned as a named
  list.

## Value

A named list of palettes if \`name\` is NULL, otherwise a single
character vector of hex color codes.

## Examples

``` r
olinkviz_palettes()
#> $sunbird
#> [1] "#E8D024" "#3B2A56" "#959423" "#4A535A" "#759477"
#> 
#> $redcap
#> [1] "#D80D16" "#111316" "#C5C6A1" "#8C5C42" "#87B0D3"
#> 
#> $jewel
#> [1] "#0C8542" "#592263" "#9E1231" "#2A2C46" "#4CAF34"
#> 
#> $scarlet
#> [1] "#D50015" "#6B7184" "#E9DE66" "#221F24" "#588B44"
#> 
olinkviz_palettes("jewel")
#> [1] "#0C8542" "#592263" "#9E1231" "#2A2C46" "#4CAF34"
```
