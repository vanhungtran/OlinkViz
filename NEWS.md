# OlinkViz 0.1.0

## New features

- `plot_volcano()`: Publication-ready volcano plots with p-value validation,
  fold-change transformation, significance thresholds, and ggrepel labels for
  top hits.
- `plot_heatmap()`: Clustered expression heatmaps accepting both long and wide
  format, with annotation tracks, row/column scaling, and NA imputation
  with warnings.
- `plot_pca()`: PCA biplots with group coloring, optional confidence ellipses,
  and zero-variance column filtering.
- `plot_umap()`: UMAP projections with group coloring, configurable
  n_neighbors/min_dist/metric, and reproducible seed support.
- `plot_boxplot()`: Single-protein boxplots with overlaid jittered points and
  optional statistical annotations via ggpubr.
- `plot_dotplot()`: Multi-protein Cleveland dot plots showing effect sizes with
  significance-encoded dot sizes and direction-colored points.
- `plot_corr()`: Pairwise correlation matrices via corrplot, with configurable
  display methods (color, circle, ellipse, number, shade, pie).
- `plot_trajectory()`: Longitudinal spaghetti plots with individual subject
  trajectories and group-level LOESS/LM/GAM smoothing.
- `theme_olinkviz()`: Clean, publication-ready ggplot2 theme based on theme_bw().
- `olinkviz_palette()`: Colorblind-friendly categorical color palette using
  RColorBrewer Dark2 with interpolation for larger groups.
- `validate_npx()`: NPX data structure validation with configurable error/warning.
- `to_wide()`: Long-to-wide format pivot with replicate averaging and duplicate
  sample warnings.
- `to_long()`: Wide-to-long format pivot with auto-detection of assay columns
  and configurable exclusion list.
- `run_shiny()`: Interactive Shiny dashboard launcher for exploring datasets
  and generating plots.

## Bundled datasets

- 11 curated Olink datasets from Long COVID, PCNSL, Myasthenia Gravis,
  Tuberculosis, and Down Syndrome studies.
- Dataset documentation with format, column, and source descriptions.

## Package structure

- 11 exported functions across 9 R source files.
- 11 bundled datasets with xz compression.
- Clean, consistent function signatures with `assay_col`/`value_col`/`sample_col`
  conventions matching Olink NPX long-format standards.
- Comprehensive input validation with informative warnings and errors.
