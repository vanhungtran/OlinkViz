# Maximum figure height for a journal

Maximum figure height for a journal

## Usage

``` r
journal_height(journal = "nature", fraction = 1, units = c("mm", "in"))
```

## Arguments

- journal:

  Any registered journal id (see \[journal_specs()\]).

- fraction:

  Fraction of the maximum height to return (\`0.5\` for half a page).

- units:

  \`"mm"\` (default) or \`"in"\`.

## Value

The height in the chosen units. An error if the journal's guide states
no maximum height (\`journal_spec(journal)\$max_height_mm\` is \`NA\`).

## See also

Other journal-specs:
[`journal_font()`](https://vanhungtran.github.io/OlinkViz/reference/journal_font.md),
[`journal_spec()`](https://vanhungtran.github.io/OlinkViz/reference/journal_spec.md),
[`journal_spec_add()`](https://vanhungtran.github.io/OlinkViz/reference/journal_spec_add.md),
[`journal_specs()`](https://vanhungtran.github.io/OlinkViz/reference/journal_specs.md),
[`journal_width()`](https://vanhungtran.github.io/OlinkViz/reference/journal_width.md)

## Examples

``` r
journal_height("nature", units = "mm")
#> [1] 170
journal_height("cell", fraction = 0.5)
#> [1] 100
```
