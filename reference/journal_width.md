# Journal figure widths and heights

Looks a column width up in the journal registry (\[journal_spec()\]) and
returns it in millimetres or inches, ready for \[save_olinkviz()\] or
\[ggplot2::ggsave()\].

## Usage

``` r
journal_width(
  width = c("single", "1.5", "double", "triple"),
  journal = "nature",
  units = c("mm", "in")
)
```

## Arguments

- width:

  One of \`"single"\`, \`"1.5"\`, \`"double"\`, \`"triple"\`,
  \`"full"\`, \`"1col"\`, \`"2col"\`, \`"3col"\` (partial matches work),
  or a number, which is returned unchanged.

- journal:

  Any registered journal id (see \[journal_specs()\]).

- units:

  \`"mm"\` (default) or \`"in"\`.

## Value

The width in the chosen units.

## Width keywords

\`"single"\` is the one-column width, \`"1.5"\` (or \`"onehalf"\`) the
intermediate width, \`"double"\` (or \`"full"\`) the full page width,
and \`"triple"\` a third width where a journal quotes one. Journals on a
three-column grid (Science) also answer to the column counts \`"1col"\`,
\`"2col"\` and \`"3col"\`: for Science \`"2col"\` is 121 mm (the same as
\`"1.5"\`) and \`"3col"\` / \`"double"\` is 184 mm; for a two-column
journal \`"2col"\` is the full width.

## See also

Other journal-specs:
[`journal_font()`](https://vanhungtran.github.io/OlinkViz/reference/journal_font.md),
[`journal_height()`](https://vanhungtran.github.io/OlinkViz/reference/journal_height.md),
[`journal_spec()`](https://vanhungtran.github.io/OlinkViz/reference/journal_spec.md),
[`journal_spec_add()`](https://vanhungtran.github.io/OlinkViz/reference/journal_spec_add.md),
[`journal_specs()`](https://vanhungtran.github.io/OlinkViz/reference/journal_specs.md)

## Examples

``` r
journal_width("double", "nature")
#> [1] 180
journal_width("2col", "science", units = "mm")
#> [1] 121
journal_width("single", "jid", units = "mm")
#> [1] 90
```
