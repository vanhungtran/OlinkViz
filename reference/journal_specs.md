# List the registered journal specifications

List the registered journal specifications

## Usage

``` r
journal_specs(kind = NULL)
```

## Arguments

- kind:

  Optional filter: one or more of \`"journal"\`, \`"publisher"\`
  (generic publisher artwork rules), \`"purpose"\` (slides, poster,
  thesis, ...) and \`"default"\`.

## Value

A data frame with one row per spec: \`id\`, \`name\`, \`kind\`, the
\`single_mm\` / \`onehalf_mm\` / \`double_mm\` widths,
\`max_height_mm\`, \`font_min_pt\`, \`font_max_pt\`, \`line_min_pt\`,
\`tag_case\`, \`dpi_halftone\`, \`verified\`, \`checked\`, and
\`n_filled\` (how many fields the guide did not state). Use
\[journal_spec()\] for the full record of one journal.

## See also

Other journal-specs:
[`journal_font()`](https://vanhungtran.github.io/OlinkViz/reference/journal_font.md),
[`journal_height()`](https://vanhungtran.github.io/OlinkViz/reference/journal_height.md),
[`journal_spec()`](https://vanhungtran.github.io/OlinkViz/reference/journal_spec.md),
[`journal_spec_add()`](https://vanhungtran.github.io/OlinkViz/reference/journal_spec_add.md),
[`journal_width()`](https://vanhungtran.github.io/OlinkViz/reference/journal_width.md)

## Examples

``` r
head(journal_specs())
#>               id                         name    kind single_mm onehalf_mm
#> 1        default Default (generic submission) default        90         NA
#> 2         actadv   Acta Dermato-Venereologica journal        85         NA
#> 3        allergy                      Allergy journal        80         NA
#> 4         annals  Annals of Internal Medicine journal        85         NA
#> 5            bib  Briefings in Bioinformatics journal        85         NA
#> 6 bioinformatics               Bioinformatics journal        86         NA
#>   double_mm max_height_mm font_min_pt font_max_pt line_min_pt tag_case
#> 1       180           240           7          NA        0.25    lower
#> 2       175            NA           6          NA        0.25    upper
#> 3       180            NA           6          NA        0.25    upper
#> 4       175            NA           6          NA        0.25    upper
#> 5       175            NA           6          NA        0.30    upper
#> 6       178            NA           6          NA        0.30    upper
#>   dpi_halftone      verified checked n_filled
#> 1          300 user-supplied 2026-10        3
#> 2          300 research file 2026-09        4
#> 3          300 research file 2026-09        3
#> 4           NA research file 2026-09        4
#> 5          300 research file 2026-09        4
#> 6          350 research file 2026-09        3
subset(journal_specs(), double_mm >= 180 & !is.na(max_height_mm))[, 1:6]
#>             id                                         name    kind single_mm
#> 1      default                 Default (generic submission) default        90
#> 19 dermatology                                  Dermatology journal        NA
#> 24        embo                             The EMBO Journal journal        87
#> 34         jci            Journal of Clinical Investigation journal        90
#> 35  jciinsight                                  JCI Insight journal        90
#> 37         jid         Journal of Investigative Dermatology journal        90
#> 44    natcomms                        Nature Communications journal        88
#> 45      natmed                              Nature Medicine journal        89
#> 46    natmicro                          Nature Microbiology journal        89
#> 47      nature                                       Nature journal        90
#> 49        plos PLOS (ONE, Biology, Genetics, Medicine, ...) journal       132
#> 52      sciadv                             Science Advances journal        90
#> 53     science                                      Science journal        57
#> 63      poster                                 Poster panel purpose       250
#> 65      slides                                Slides (16:9) purpose       155
#> 67         web                         Web page (SVG / PNG) purpose       120
#>    onehalf_mm double_mm
#> 1          NA     180.0
#> 19         NA     180.0
#> 24         NA     180.0
#> 34         NA     180.0
#> 35         NA     180.0
#> 37        140     190.0
#> 44         NA     180.0
#> 45         NA     180.0
#> 46         NA     183.0
#> 47        120     180.0
#> 49         NA     190.5
#> 52         NA     184.0
#> 53        121     184.0
#> 63        400     780.0
#> 65         NA     320.0
#> 67         NA     200.0
```
