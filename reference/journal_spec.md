# Look up a journal specification

Every size, limit, and style rule in OlinkViz comes from one registry of
journal specifications: column widths, the maximum figure height, the
smallest (and, where a guide states one, largest) text size, the minimum
stroke weight, the panel-tag style, and the raster resolution the
journal asks for. \[journal_width()\], \[save_olinkviz()\],
\[olinkviz_combine()\], \[theme_journal()\] and the
\`olinkviz_check\_\*()\` pre-flight checks all read it.

## Usage

``` r
journal_spec(journal = "nature")
```

## Arguments

- journal:

  A registered journal id (see \[journal_specs()\]; matching is
  case-insensitive), or a spec object, which is returned unchanged.

## Value

An object of class \`olinkviz_journal_spec\`: a list with \`id\`,
\`name\`, \`publisher\`, \`kind\`, \`widths_mm\` (named column widths:
\`minimal\`, \`single\`, \`onehalf\`, \`double\`, \`triple\`),
\`widths_alt_mm\` (alternative widths a publisher quotes elsewhere),
\`grid\` (2 or 3 columns), \`max_height_mm\`, \`font\`, \`font_min_pt\`,
\`font_max_pt\`, \`body_pt\`, \`line_min_pt\`, \`tag_case\`, \`tag_pt\`,
\`dpi\` (\`line\`, \`halftone\`, \`combination\`), \`formats\`,
\`colour\`, \`checked\`, \`verified\`, \`sources\`, \`notes\` and
\`filled\`. \`NA\` means the guide does not state the value.

## Details

The registry holds

\- \*\*hand-checked presets\*\*: \`"nature"\`, \`"cell"\` and
\`"science"\` (read from each publisher's own figure pages),
\`"natcomms"\`, \`"pnas"\`, \`"plos"\`, \`"jid"\`, and a
journal-agnostic \`"default"\` (90 / 180 mm, at most 240 mm tall, 7 pt
minimum text, 300 dpi); - \*\*researched presets\*\* for 53 further
journals and publishers (dermatology, allergy, microbiome,
bioinformatics, pharmacology, statistics, general medicine) compiled
from each author guide, with the source URLs and the date checked. Where
a guide does not state a value it was filled from the publisher's
generic artwork guide or a package default; those fields are listed in
\`\$filled\` and starred by \`print()\`; - \*\*purpose presets\*\*
(\`"slides"\`, \`"poster"\`, \`"thesis"\`, \`"grant"\`, \`"preprint"\`,
\`"web"\`) that are house conventions, not journal rules; - anything you
add with \[journal_spec_add()\].

Author guidelines change and several journals deviate from their
publisher's flagship rules: re-check the live guide of your target
journal before final submission. Each spec's \`\$verified\`,
\`\$checked\` and \`\$sources\` say how far to trust it.

## See also

Other journal-specs:
[`journal_font()`](https://vanhungtran.github.io/OlinkViz/reference/journal_font.md),
[`journal_height()`](https://vanhungtran.github.io/OlinkViz/reference/journal_height.md),
[`journal_spec_add()`](https://vanhungtran.github.io/OlinkViz/reference/journal_spec_add.md),
[`journal_specs()`](https://vanhungtran.github.io/OlinkViz/reference/journal_specs.md),
[`journal_width()`](https://vanhungtran.github.io/OlinkViz/reference/journal_width.md)

## Examples

``` r
journal_spec("nature")
#> <journal spec> nature: Nature (Springer Nature) [journal]
#>   widths      single 90 | 1.5 120 | double 180 mm  (also quoted: 89 / 183 mm)
#>   max height  170 mm
#>   text        5-7 pt (body 7 pt)
#>   lines       not stated *
#>   panel tags  lower-case, 8 pt bold
#>   raster dpi  halftone >= 300
#>   fonts       Arial, Helvetica
#>   formats     PDF, EPS, AI
#>   colour      RGB
#>   provenance  publisher page, checked 2026-10
#>               https://research-figure-guide.nature.com/figures/building-and-exporting-figure-panels/
#>               https://research-figure-guide.nature.com/figures/preparing-figures-our-specifications/
#>   * not stated by the guide:
#>       line_min_pt: none stated; checks use 0.25 pt
#>   notes:
#>     Text must be 5-7 pt at final size (guide: 'Minimum text size: 5 pt', 'Maximum
#>     text size: 7 pt'); panel labels are 8-pt bold, upright, lower-case; the
#>     maximum figure height is 170 mm. Nature's figure guide quotes 89 / 183 mm
#>     columns while its author formatting guide quotes 90 / 180 mm: 90 / 180 is
#>     used here and 89 / 183 is accepted as an alternative. The 120 mm
#>     one-and-a-half column is the Nature Portfolio convention, not a
#>     flagship-Nature number. A 7 pt 'minimum' sometimes quoted for Nature is its
#>     maximum text size.
journal_spec("cell")$max_height_mm
#> [1] 200
journal_spec("science")$widths_mm
#>  single onehalf  double 
#>      57     121     184 
```
