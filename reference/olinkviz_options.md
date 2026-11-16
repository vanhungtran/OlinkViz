# Set OlinkViz sizing and journal options

Convenience wrapper around the options that control how every
\`plot\_\*()\` function sizes its text and marks: \`olinkviz.base_size\`
(body text in points), \`olinkviz.axes\` (\`"box"\` or \`"l"\`), and
\`olinkviz.journal\` (registered journal specification id; see
\[journal_specs()\]). See \[theme_olinkviz()\] and \[theme_journal()\].

## Usage

``` r
olinkviz_options(base_size = NULL, axes = NULL, journal = NULL)
```

## Arguments

- base_size:

  Body text size in points (between 4 and 40). The default of the
  package is 11.

- axes:

  \`"box"\` (full panel frame, the default) or \`"l"\` (left and bottom
  axis lines only).

- journal:

  Optional journal specification id (e.g. \`"nature"\`, \`"cell"\`,
  \`"science"\`, \`"plos"\`, \`"jid"\`). Sets \`olinkviz.journal\` and
  defaults \`base_size\` and \`axes = "l"\`.

## Value

Invisibly, the previous values of the options, so they can be restored
with \`options(old)\`.

## Details

Passing \`journal = "nature"\` (or any id from \[journal_specs()\])
automatically sets \`base_size\` to the journal's recommended body size
(or \`font_min_pt + 1\` so tick labels stay at or above the journal's
minimum) and switches \`axes\` to \`"l"\` unless overridden explicitly.

## Examples

``` r
old <- olinkviz_options(base_size = 7, axes = "l")
getOption("olinkviz.base_size")
#> [1] 7
options(old)

old <- olinkviz_options(journal = "nature")
getOption("olinkviz.journal")
#> [1] "nature"
options(old)
```
