# Changelog

## OlinkViz 0.1.2

### Data

clone of it. The new version keeps the same 22 columns, 35,328 rows and
study layout, so existing examples run unchanged. It has built-in group,
time and group x time effects (always present for IL6, TNF and IL8, the
assay that newer Olink panels call CXCL8).

### New features

- New `OlinkExperiment` S4 class for representing Olink proteomics data,
  designed to mirror the `SingleCellExperiment` package
  (github.com/drisso/SingleCellExperiment). Rows are proteins, columns
  are samples; NPX/LOD/protein-count quantifications live in `assays`,
  sample and protein annotation in `colData`/`rowData`, and
  dimensionality reductions in `reducedDims`. Includes named assay
  accessors
  [`npx()`](https://vanhungtran.github.io/OlinkViz/reference/npx.md),
  [`lod()`](https://vanhungtran.github.io/OlinkViz/reference/npx.md),
  [`pcount()`](https://vanhungtran.github.io/OlinkViz/reference/npx.md),
  the full
  [`reducedDims()`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)/[`reducedDim()`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
  API, internal-slot accessors (`int_colData`, `int_elementMetadata`,
  `int_metadata`), subsetting (`x[i, j]`), combining (`cbind`/`rbind`),
  coercion to/from `SummarizedExperiment`, and a `show` method.
- A convenience constructor for building an `OlinkExperiment` from raw
  long-format Olink data:
  [`oe_from_long()`](https://vanhungtran.github.io/OlinkViz/reference/oe_from_long.md).
  Assay/value/sample columns are auto-detected, an optional `LOD` column
  becomes a parallel `LOD` assay, and remaining columns are split into
  `rowData` (protein-level, e.g. `OlinkID`, `UniProt`, `Panel`) vs
  `colData` (sample-level, e.g. `Sex`, `Group`). Building from a wide
  NPX matrix uses the base constructor directly:
  `OlinkExperiment(assays = list(NPX = npx, LOD = lod), colData = cd, rowData = rd)`.
- All `plot_*()` functions now accept an `OlinkExperiment` directly. A
  new [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html)
  method converts it to the long-format data.frame used by the plots
  (columns `Assay`, `SampleID`, the object’s assays such as `NPX`/
  `LOD`, plus all `colData`/`rowData` columns), so calls like
  `plot_dim_reduc(oe, type = "pca", color = "Group")` or
  `plot_boxplot(oe, assay = "IL6", group = "Group")` work out of the
  box.
- New unified
  [`plot_dim_reduc()`](https://vanhungtran.github.io/OlinkViz/reference/plot_dim_reduc.md)
  for plotting one or more dimensionality reductions of an
  `OlinkExperiment`, colored by a sample covariate:
  `plot_dim_reduc(oe, type = "pca", color = "Group")`. Supported `type`s
  are `"pca"`, `"umap"`, and `"tsne"` (computed on the fly), or any
  reduction already stored in `reducedDims(oe)` (matched
  case-insensitively). Multiple types are plotted jointly as a single
  multi-panel figure, e.g.
  `plot_dim_reduc(oe, type = c("pca", "umap"), color = "Group")`.
- `plot_pca()` has been removed; use `plot_dim_reduc(..., type = "pca")`
  instead (it also accepts a long-format data.frame, as `plot_pca()`
  did).
- [`plot_heatmap()`](https://vanhungtran.github.io/OlinkViz/reference/plot_heatmap.md)
  now shows the sample covariates of an `OlinkExperiment` automatically:
  when `annotation_cols = NULL` (the default), the `colData` columns are
  drawn as annotation tracks above the samples (sample-id and
  constant/technical columns are excluded). Pass `annotation_cols` to
  select specific covariates.
- [`plot_heatmap()`](https://vanhungtran.github.io/OlinkViz/reference/plot_heatmap.md)
  gained `annotation_rows` to group biomarkers into sets: the
  protein-level `rowData` columns of an `OlinkExperiment` (e.g. the
  Olink `Panel`) are drawn as row annotation tracks automatically, or
  you can pass specific columns via `annotation_rows`.
- [`plot_heatmap()`](https://vanhungtran.github.io/OlinkViz/reference/plot_heatmap.md)
  gained `pathway_annotation` to group the biomarkers by their
  **enriched pathways**: set it to `TRUE` to run pathway enrichment with
  `gprofiler2` (needs internet), or pass a precomputed protein → pathway
  data.frame. Each biomarker is annotated with its top enriched pathway.
- New
  [`enrich_pathways()`](https://vanhungtran.github.io/OlinkViz/reference/enrich_pathways.md)
  runs
  [`gprofiler2::gost()`](https://rdrr.io/pkg/gprofiler2/man/gost.html)
  on a set of proteins and returns a protein → pathway mapping (returns
  `NULL` gracefully if `gprofiler2` is missing, there is no internet, or
  nothing is significant).
- [`plot_corr()`](https://vanhungtran.github.io/OlinkViz/reference/plot_corr.md)
  no longer draws a main title, so it can never cover the color legend.
- [`plot_dotplot()`](https://vanhungtran.github.io/OlinkViz/reference/plot_dotplot.md)
  comparison labels now include the grouping column name,
  e.g. `Timepoint 2 vs 1` instead of `2 vs 1` (the title and x-axis
  label are updated the same way).
- [`plot_violin()`](https://vanhungtran.github.io/OlinkViz/reference/plot_violin.md)
  now aligns the overlaid boxplot with the violins: both geoms share the
  same dodge position, so the box is drawn centered inside its violin
  even when groups are present (previously the boxplot could be offset
  to one side).
- The single-assay comparison plots
  ([`plot_boxplot()`](https://vanhungtran.github.io/OlinkViz/reference/plot_boxplot.md),
  [`plot_violin()`](https://vanhungtran.github.io/OlinkViz/reference/plot_violin.md),
  [`plot_mean_profile()`](https://vanhungtran.github.io/OlinkViz/reference/plot_mean_profile.md))
  gained `show_p_value` and `show_significant` options to annotate
  p-values for **each pairwise comparison** between the x-axis levels
  (e.g. each timepoint). By default all pairs of levels are compared;
  pass `comparisons` to restrict to specific brackets. `show_p_value`
  prints numeric p-values (e.g. `p = 0.03`), `show_significant` prints
  significance stars, and both together print `p = 0.03 *` (requires the
  `ggpubr` package).
- With `show_significant = TRUE` only **significant** comparisons are
  drawn: brackets with p \< `p_cutoff` (default 0.05) are kept, so the
  plot is not cluttered with non-significant bars. Set `p_cutoff = NULL`
  to draw every comparison.
- Comparison brackets are placed at explicit y-positions stacked above
  the data (~10% of the y range above the top, adjustable via
  `bracket_nudge_y`, with `step_increase` controlling the gap between
  stacked bars), so the bars no longer overlap the points/violins and
  are never clipped.
- New themed color palettes inspired by bird plumage, exported as
  ready-to-use color vectors: `pal_sunbird`, `pal_redcap`, `pal_jewel`,
  and `pal_scarlet`. Each provides 5 hex colors designed to work
  together (high-contrast warm and cool tones).
- New
  [`olinkviz_palettes()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_palettes.md)
  returns all themed palettes as a named list, or a single palette by
  name, e.g. `olinkviz_palettes("jewel")`.
- [`plot_corr_triangle()`](https://vanhungtran.github.io/OlinkViz/reference/plot_corr_triangle.md)
  gained a `palette` argument: correlations are mapped onto 5 diverging
  bins using any of the themed palettes (contrast-aware coefficient
  labels, darkened borders).
- New
  [`plot_pathway_network()`](https://vanhungtran.github.io/OlinkViz/reference/plot_pathway_network.md):
  a “Top Up-regulated Pathways” figure combining a horizontal
  pathway-count bar chart with a bipartite gene–pathway network
  (`ggraph`), coloured by fold change with any themed palette.
- **Journal-size figures.** Every `plot_*()` function now sizes its text
  and marks from one base size, so a figure can be drawn at its final
  size instead of being shrunk afterwards (which leaves text too small
  or labels colliding). `olinkviz_options(base_size = 7, axes = "l")`
  sets it for the session (the options are `olinkviz.base_size`, default
  11, and `olinkviz.axes`, `"box"` or `"l"`);
  [`theme_olinkviz()`](https://vanhungtran.github.io/OlinkViz/reference/theme_olinkviz.md)
  gained an `axes` argument and takes its `base_size` from the option.
  With a base size below the 11 pt default (“journal-size mode”) the
  canvas-dependent behaviour also adapts: long titles wrap, facet strips
  wrap, `-log10` labels are plain text (a plotmath subscript is drawn at
  70 percent size, which at 7 pt falls below the 5 to 6 pt minimum most
  journals ask for),
  [`plot_corr_triangle()`](https://vanhungtran.github.io/OlinkViz/reference/plot_corr_triangle.md)
  fits its circles to the grid of a single 89 mm column, and
  [`plot_heatmap()`](https://vanhungtran.github.io/OlinkViz/reference/plot_heatmap.md)
  leaves out sample names when there are more than 30 (at 7 pt). At the
  default size none of this applies, so existing figures are unchanged
  (11 of the 14 plot types render pixel-identically to 0.1.1). The
  smallest text in a plot is `base_size - 1` (tick labels), so use 7 for
  most journals and 9 where the minimum is 8 pt. Checked at 89 mm with a
  rendered text-size and collision audit at 7 pt: 16 plot types pass
  (boxplot, violin, mean profile, spaghetti, trajectory, regression,
  LMER, PCA, UMAP, scree, loadings, dot plot, volcano, heatmap,
  correlation matrix and triangle) as do the three new ones below.
  [`plot_pathway_network()`](https://vanhungtran.github.io/OlinkViz/reference/plot_pathway_network.md)
  also follows the base size, but its pathway names are drawn over node
  circles and edges, so check it by eye;
  [`plot_network()`](https://vanhungtran.github.io/OlinkViz/reference/plot_network.md)
  returns an image from the STRING service and cannot be resized.
- New
  [`save_olinkviz()`](https://vanhungtran.github.io/OlinkViz/reference/save_olinkviz.md)
  writes a ggplot at an exact physical size (mm, cm or in) as PDF
  (Cairo, fonts embedded), PNG, SVG and/or TIFF.
- New
  [`plot_qc()`](https://vanhungtran.github.io/OlinkViz/reference/plot_qc.md):
  sample QC as median NPX versus interquartile range per sample and
  panel, with outliers beyond `sd_cutoff` standard deviations flagged
  and labelled, Olink `QC_Warning` samples drawn as triangles, and an
  optional colour by plate or any sample-level column.
- New
  [`plot_lod()`](https://vanhungtran.github.io/OlinkViz/reference/plot_lod.md):
  assay detectability, the percentage of samples above the limit of
  detection for every assay (ranked, per panel), with the least
  detectable assays labelled.
- New
  [`plot_roc()`](https://vanhungtran.github.io/OlinkViz/reference/plot_roc.md):
  ROC curves of individual proteins for a two-group comparison, with AUC
  and DeLong 95 percent confidence interval in the legend (needs
  `pROC`). Replicates are averaged; the direction of each marker is
  chosen so that AUC is at least 0.5 unless `direction` is set.

### Changes

- [`plot_dotplot()`](https://vanhungtran.github.io/OlinkViz/reference/plot_dotplot.md)
  now orders the proteins by effect size (it was alphabetical), the
  usual order for a Cleveland dot plot.
- [`plot_heatmap()`](https://vanhungtran.github.io/OlinkViz/reference/plot_heatmap.md)
  no longer draws the row dendrogram when there are more than 100 rows
  (it is a solid black block at figure size; rows are still ordered by
  the clustering; pass `treeheight_row` to draw it) and, when
  `show_colnames` is not given, hides sample names when there are more
  than 100 columns. Its `fontsize` default is now `NULL` (8 at the
  default base size).
- [`plot_volcano()`](https://vanhungtran.github.io/OlinkViz/reference/plot_volcano.md)
  labels its x axis “Effect size (NPX difference, log2 scale)” when the
  column is an `estimate`/`difference` column instead of printing the
  column name, keeps its labels off the dashed threshold lines, and uses
  a fixed seed so the label layout is the same on every run (it used to
  change). It also says so (with the largest effect in the data) when no
  assay passes the thresholds.
- [`plot_corr()`](https://vanhungtran.github.io/OlinkViz/reference/plot_corr.md)
  text sizes (`tl.cex`, `coef_cex`) now default to `NULL` (0.7 at the
  default base size, as before).
- Packaging: DESCRIPTION now declares `methods` and `utils` (Imports)
  and `Rtsne` (Suggests, used by `plot_dim_reduc(type = "tsne")`),
  NAMESPACE imports
  [`methods::callNextMethod`](https://rdrr.io/r/methods/NextMethod.html),
  and the `.paper` and `.paper-system` folders are left out of the
  build. `R CMD check` used to stop at its dependency check because the
  NAMESPACE has S4 export directives but `methods` was not declared.

### Bug fixes

- [`to_wide()`](https://vanhungtran.github.io/OlinkViz/reference/to_wide.md)
  (and so
  [`plot_dim_reduc()`](https://vanhungtran.github.io/OlinkViz/reference/plot_dim_reduc.md),
  [`plot_scree()`](https://vanhungtran.github.io/OlinkViz/reference/plot_scree.md),
  [`plot_loadings()`](https://vanhungtran.github.io/OlinkViz/reference/plot_loadings.md),
  [`plot_heatmap()`](https://vanhungtran.github.io/OlinkViz/reference/plot_heatmap.md),
  [`plot_corr()`](https://vanhungtran.github.io/OlinkViz/reference/plot_corr.md)
  and
  [`plot_corr_triangle()`](https://vanhungtran.github.io/OlinkViz/reference/plot_corr_triangle.md))
  failed with a parse error on long-format Olink data in which a protein
  is measured on more than one panel and the table has a column whose
  name is not a syntactic R name (`Olink NPX Signature Version`,
  `Plate#`, …), as in the bundled `probc`. The replicate-averaging step
  built a model formula from the column names; it now averages in
  [`pivot_wider()`](https://tidyr.tidyverse.org/reference/pivot_wider.html).
  A protein whose replicates are all `NA` is `NA` (it used to be `NaN`),
  and `data.table` input is converted first so `[` behaves as for a data
  frame.
- `plot_volcano(transform_fc = TRUE)` drew the raw fold changes while
  applying the thresholds and labelling to the log2 values; it now draws
  what it classifies.
- [`plot_pathway_network()`](https://vanhungtran.github.io/OlinkViz/reference/plot_pathway_network.md)
  failed with “factor level is duplicated” when a protein appeared in
  more than one row of the table (for example a protein measured on two
  panels, with the `Panel` column as the pathway source). It now uses
  the strongest row of each protein. It also follows the base size set
  with
  [`olinkviz_options()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_options.md)
  (text, nodes and edges); at the default size it is unchanged.
- [`enrich_pathways()`](https://vanhungtran.github.io/OlinkViz/reference/enrich_pathways.md)
  called
  [`gprofiler2::gost()`](https://rdrr.io/pkg/gprofiler2/man/gost.html)
  without `evcodes = TRUE`, so the response never had an `intersection`
  column. Because of R’s partial matching on `$`,
  `res$result$intersection` silently resolved to `intersection_size`
  instead (a small integer), so the returned `Protein` column held
  term-hit counts rather than protein identifiers — every downstream use
  (including `plot_heatmap(..., pathway_annotation = TRUE)`) was mapping
  proteins to pathways using the wrong values. `evcodes = TRUE` is now
  requested by default (still overridable via `...`).

## OlinkViz 0.1.1

### Simpler to use

- All `plot_*()` functions now auto-detect column roles from common
  names (`Assay`, `NPX`, `SampleID`, `Timepoint`, `p.value`, `log2FC`,
  …), so calls like `plot_volcano(results)` or
  `plot_boxplot(npx, assay = "IL6")` need no column arguments.
  Non-standard columns can still be passed explicitly, and the functions
  report which columns they guessed.
- [`plot_heatmap()`](https://vanhungtran.github.io/OlinkViz/reference/plot_heatmap.md)
  and
  [`plot_corr()`](https://vanhungtran.github.io/OlinkViz/reference/plot_corr.md)
  auto-detect long vs. wide input format.
- [`to_wide()`](https://vanhungtran.github.io/OlinkViz/reference/to_wide.md)
  now keeps only sample-level metadata when pivoting (drops assay-level
  columns such as `OlinkID`, `UniProt`, `LOD`, and QC flags) and
  auto-detects `assay_col`/`value_col`/`sample_col`.
- `plot_pca()`/`plot_umap()` recover grouping metadata (e.g. numeric
  time columns) that was previously lost during pivoting.
- [`olinkviz_palette()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_palette.md)
  no longer warns for 2-group palettes.
- [`plot_heatmap()`](https://vanhungtran.github.io/OlinkViz/reference/plot_heatmap.md)
  no longer fails when `main = NULL` (no title).

## OlinkViz 0.1.0

### New features

- [`plot_volcano()`](https://vanhungtran.github.io/OlinkViz/reference/plot_volcano.md):
  Publication-ready volcano plots with p-value validation, fold-change
  transformation, significance thresholds, and ggrepel labels for top
  hits.
- [`plot_heatmap()`](https://vanhungtran.github.io/OlinkViz/reference/plot_heatmap.md):
  Clustered expression heatmaps accepting both long and wide format,
  with annotation tracks, row/column scaling, and NA imputation with
  warnings.
- `plot_pca()`: PCA biplots with group coloring, optional confidence
  ellipses, and zero-variance column filtering.
- `plot_umap()`: UMAP projections with group coloring, configurable
  n_neighbors/min_dist/metric, and reproducible seed support.
- [`plot_boxplot()`](https://vanhungtran.github.io/OlinkViz/reference/plot_boxplot.md):
  Single-protein boxplots with overlaid jittered points and optional
  statistical annotations via ggpubr.
- [`plot_dotplot()`](https://vanhungtran.github.io/OlinkViz/reference/plot_dotplot.md):
  Multi-protein Cleveland dot plots showing effect sizes with
  significance-encoded dot sizes and direction-colored points.
- [`plot_corr()`](https://vanhungtran.github.io/OlinkViz/reference/plot_corr.md):
  Pairwise correlation matrices via corrplot, with configurable display
  methods (color, circle, ellipse, number, shade, pie).
- [`plot_trajectory()`](https://vanhungtran.github.io/OlinkViz/reference/plot_trajectory.md):
  Longitudinal spaghetti plots with individual subject trajectories and
  group-level LOESS/LM/GAM smoothing.
- [`theme_olinkviz()`](https://vanhungtran.github.io/OlinkViz/reference/theme_olinkviz.md):
  Clean, publication-ready ggplot2 theme based on theme_bw().
- [`olinkviz_palette()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_palette.md):
  Colorblind-friendly categorical color palette using RColorBrewer Dark2
  with interpolation for larger groups.
- [`validate_npx()`](https://vanhungtran.github.io/OlinkViz/reference/validate_npx.md):
  NPX data structure validation with configurable error/warning.
- [`to_wide()`](https://vanhungtran.github.io/OlinkViz/reference/to_wide.md):
  Long-to-wide format pivot with replicate averaging and duplicate
  sample warnings.
- [`to_long()`](https://vanhungtran.github.io/OlinkViz/reference/to_long.md):
  Wide-to-long format pivot with auto-detection of assay columns and
  configurable exclusion list.
- [`run_shiny()`](https://vanhungtran.github.io/OlinkViz/reference/run_shiny.md):
  Interactive Shiny dashboard launcher for exploring datasets and
  generating plots.

### Bundled datasets

- 11 curated Olink datasets from Long COVID, PCNSL, Myasthenia Gravis,
  Tuberculosis, and Down Syndrome studies.
- Dataset documentation with format, column, and source descriptions.

### Package structure

- 11 exported functions across 9 R source files.
- 11 bundled datasets with xz compression.
- Clean, consistent function signatures with
  `assay_col`/`value_col`/`sample_col` conventions matching Olink NPX
  long-format standards.
- Comprehensive input validation with informative warnings and errors.
