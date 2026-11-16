# Heatmap of protein expression

Creates a clustered heatmap of protein expression values. Accepts data
in long format (pivots to wide internally), already in wide format, or
an
[OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md)
object.

## Usage

``` r
plot_heatmap(
  data,
  assay_col = NULL,
  value_col = NULL,
  sample_col = NULL,
  wide = NULL,
  annotation_cols = NULL,
  annotation_rows = NULL,
  pathway_annotation = FALSE,
  scale = "row",
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  show_rownames = FALSE,
  show_colnames = NULL,
  color = NULL,
  fontsize = NULL,
  main = NULL,
  title = NULL,
  as_ggplot = FALSE,
  ...
)
```

## Arguments

- data:

  A data.frame or
  [OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md).
  Long format must have \`assay_col\`, \`value_col\`, and
  \`sample_col\`. Wide format should have samples as rows and proteins
  as columns.

- assay_col:

  Name of the assay column (long format). If NULL, auto-detected (e.g.
  "Assay").

- value_col:

  Name of the NPX value column (long format). If NULL, auto-detected
  (e.g. "NPX").

- sample_col:

  Name of the sample ID column. If NULL, auto-detected (e.g. "SampleID"
  or "SubjectID").

- wide:

  If TRUE, data is assumed to be in wide format. If NULL (default),
  format is detected automatically: wide when no assay/value columns are
  found.

- annotation_cols:

  Columns to use for column (sample) annotation tracks. If `NULL` and
  `data` is an
  [OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md),
  the sample covariates in `colData()` are shown automatically
  (sample-id and constant/technical columns are excluded). Pass a
  character vector to select or override specific covariates.

- annotation_rows:

  Columns to use for row (biomarker) annotation tracks that group the
  proteins into sets (e.g. the Olink `Panel` a protein belongs to). If
  `NULL` and `data` is an
  [OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md),
  the protein-level columns in `rowData()` are shown automatically
  (assay/id and constant columns are excluded). Pass a character vector
  to select specific columns.

- pathway_annotation:

  Logical or data.frame: when `TRUE`, the biomarkers are grouped into a
  `Pathway` row annotation by running pathway enrichment with
  [`enrich_pathways()`](https://vanhungtran.github.io/OlinkViz/reference/enrich_pathways.md)
  (requires gprofiler2 and an internet connection). Alternatively, pass
  a precomputed protein -\> pathway data.frame with `Protein` and
  `Pathway` columns (each protein is annotated with its top pathway).
  Default `FALSE` (no pathway annotation).

- scale:

  Scaling direction: "row", "column", or "none" (default "row").

- cluster_rows:

  Logical; perform hierarchical clustering on rows (default TRUE). With
  more than 100 rows the row dendrogram is not drawn (rows are still
  ordered by the clustering) unless you pass \`treeheight_row\`.

- cluster_cols:

  Logical; perform hierarchical clustering on columns (default TRUE).

- show_rownames:

  Logical; show row (protein) names (default FALSE, usually too many).

- show_colnames:

  Logical; show column (sample) names. If NULL (default), names are
  shown when there are at most 100 columns; in journal-size mode
  (\`options(olinkviz.base_size)\` below 11) at most \`30 \* 7 /
  base_size\`, i.e. 30 at 7 pt; more labels than that cannot be read and
  collide.

- color:

  Palette of colors for the heatmap gradient.

- fontsize:

  Base font size in points. If NULL (default), 8; in journal-size mode
  (\`options(olinkviz.base_size)\` below 11) the tick-label size,
  \`base_size - 1\`.

- main, title:

  Title for the heatmap.

- as_ggplot:

  Logical; if \`TRUE\`, wraps the \`pheatmap\` gtable into a
  \`patchwork\`/\`ggplot\` element (requires \`patchwork\`) so it can be
  combined into multi-panel figures with \`+\` or \`/\` (default
  \`FALSE\`).

- ...:

  Additional arguments passed to \`pheatmap::pheatmap()\`.

## Value

A \`pheatmap\` object (invisibly), or a \`patchwork\`/\`ggplot\` object
when \`as_ggplot = TRUE\`.

## Examples

``` r
if (FALSE) { # \dontrun{
# Long format: column names are detected automatically
plot_heatmap(beatmg_npx, annotation_cols = "Timepoint")

# Wide format: detected automatically, no pivoting arguments needed
plot_heatmap(pcnsl_olink)
} # }
```
