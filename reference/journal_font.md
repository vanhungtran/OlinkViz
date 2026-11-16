# First installed font family a journal asks for

Returns the first of the journal's preferred font families (for example
Arial for Cell Press, Helvetica for Science) that is installed on this
machine, or \`fallback\` when none is - so a theme never silently asks
the graphics device for a font it cannot find. Needs the (Suggested)
systemfonts package to look fonts up; without it \`fallback\` is
returned.

## Usage

``` r
journal_font(journal = "nature", fallback = "sans")
```

## Arguments

- journal:

  Any registered journal id (see \[journal_specs()\]).

- fallback:

  Family returned when no preferred font is installed.

## Value

A single font family name.

## See also

Other journal-specs:
[`journal_height()`](https://vanhungtran.github.io/OlinkViz/reference/journal_height.md),
[`journal_spec()`](https://vanhungtran.github.io/OlinkViz/reference/journal_spec.md),
[`journal_spec_add()`](https://vanhungtran.github.io/OlinkViz/reference/journal_spec_add.md),
[`journal_specs()`](https://vanhungtran.github.io/OlinkViz/reference/journal_specs.md),
[`journal_width()`](https://vanhungtran.github.io/OlinkViz/reference/journal_width.md)

## Examples

``` r
journal_font("cell")
#> [1] "Arial"
```
