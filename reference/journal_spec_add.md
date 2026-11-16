# Register a journal specification for this session

Adds (or, with \`overwrite = TRUE\`, replaces) a spec so that every
function that takes \`journal =\` can use it. Specs live for the R
session; put the call in a project setup script to keep it.

## Usage

``` r
journal_spec_add(id, widths_mm, ..., base = NULL, overwrite = FALSE)
```

## Arguments

- id:

  Short id for the spec (letters, digits, \`\_\`, \`.\`, \`-\`; stored
  lower-case).

- widths_mm:

  Named column widths in mm, any of \`minimal\`, \`single\`,
  \`onehalf\`, \`double\`, \`triple\`: \`c(single = 84, double = 174)\`.

- ...:

  Further spec fields; see \[journal_spec()\] for the list
  (\`max_height_mm\`, \`font_min_pt\`, \`font_max_pt\`, \`body_pt\`,
  \`line_min_pt\`, \`tag_case\`, \`tag_pt\`, \`dpi\`, \`font\`,
  \`grid\`, \`name\`, \`sources\`, \`notes\`, ...). Unnamed fields keep
  their defaults.

- base:

  Optional id (or spec) to inherit every field you do not give, e.g.
  \`base = "cell"\` for a Cell Press three-column format.

- overwrite:

  Replace an existing spec with this id (built-in or yours).

## Value

The new spec, invisibly.

## See also

Other journal-specs:
[`journal_font()`](https://vanhungtran.github.io/OlinkViz/reference/journal_font.md),
[`journal_height()`](https://vanhungtran.github.io/OlinkViz/reference/journal_height.md),
[`journal_spec()`](https://vanhungtran.github.io/OlinkViz/reference/journal_spec.md),
[`journal_specs()`](https://vanhungtran.github.io/OlinkViz/reference/journal_specs.md),
[`journal_width()`](https://vanhungtran.github.io/OlinkViz/reference/journal_width.md)

## Examples

``` r
journal_spec_add(
  "mydemo", widths_mm = c(single = 84, double = 174),
  max_height_mm = 220, font_min_pt = 6, name = "My target journal"
)
journal_width("single", "mydemo", units = "mm")
#> [1] 84
```
