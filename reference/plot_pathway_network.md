# Top up-regulated proteins and their pathway network

Reproduces the classic "Top Up-regulated Pathways" figure: a horizontal
bar chart (left) counting the number of pathways per up-regulated
protein, with the fold-change printed to the left of each bar, combined
side-by-side with a bipartite gene-pathway network (right) drawn with
\`ggraph\`. Genes are coloured by fold change; pathway nodes are grey
and labelled.

## Usage

``` r
plot_pathway_network(
  de_table,
  pathway_map = NULL,
  assay_col = NULL,
  value_col = NULL,
  top_n = 12,
  palette = NULL,
  title = NULL,
  seed = 123
)
```

## Arguments

- de_table:

  A data.frame of differential-expression results with an assay/protein
  column and a numeric fold-change column (long format).

- pathway_map:

  Optional assay-\>pathway mapping. Either a data.frame with assay and
  pathway columns, or a named list where each name is a pathway and the
  value is a character vector of assays belonging to it. If NULL, the
  first \`Pathway\`/\`Panel\` column of \`de_table\` is used as the
  mapping.

- assay_col:

  Name of the assay/protein column. If NULL, auto-detected.

- value_col:

  Name of the numeric fold-change column (e.g. "log2FC" or "estimate").
  If NULL, auto-detected from common names.

- top_n:

  Number of top up-regulated proteins to include (default 12).

- palette:

  Optional themed palette for the fold-change gradient: a palette name
  from \`olinkviz_palettes()\` or a character vector of hex colors. If
  NULL (default), the classic reference colours are used.

- title:

  Plot title (annotation over both panels).

- seed:

  Random seed for the reproducible network layout (default 123).

## Value

A \`patchwork\` object combining the bar chart and the network.

## Details

The network is a bipartite graph connecting each up-regulated protein to
the pathways it belongs to (supplied via \`pathway_map\`). Use the
\`palette\` argument to colour both panels with one of the OlinkViz
themed palettes (\`olinkviz_palettes()\`); by default the classic
reference colours are used (red bars, blue-\>green-\>yellow-\>red
fold-change gradient, grey pathways).

## Examples

``` r
if (FALSE) { # \dontrun{
plot_pathway_network(bansal_univariate, value_col = "estimate",
                     palette = "jewel", top_n = 12)
} # }
```
