# OlinkViz: Visualization Toolkit for Olink Proteomics Data

Provides ready-made, publication-quality visualization functions
tailored to Olink NPX proteomics data. Includes volcano plots, heatmaps,
PCA and UMAP projections, boxplots, dot plots, correlation matrices, and
longitudinal trajectory plots.

## Data format

Most functions expect data in \*\*long format\*\* (one row per assay per
sample) with columns for assay name, NPX value, and sample identifier.
Use
[`to_wide()`](https://vanhungtran.github.io/OlinkViz/reference/to_wide.md)
and
[`to_long()`](https://vanhungtran.github.io/OlinkViz/reference/to_long.md)
to convert between formats. Use
[`validate_npx()`](https://vanhungtran.github.io/OlinkViz/reference/validate_npx.md)
to check your data structure.

## Plotting functions

- [`plot_volcano()`](https://vanhungtran.github.io/OlinkViz/reference/plot_volcano.md)
  — Volcano plots for differential expression

- [`plot_heatmap()`](https://vanhungtran.github.io/OlinkViz/reference/plot_heatmap.md)
  — Clustered expression heatmaps

- [`plot_dim_reduc()`](https://vanhungtran.github.io/OlinkViz/reference/plot_dim_reduc.md)
  — PCA/UMAP/t-SNE projections with group coloring

- [`plot_umap()`](https://vanhungtran.github.io/OlinkViz/reference/plot_umap.md)
  — UMAP projections with group coloring

- [`plot_boxplot()`](https://vanhungtran.github.io/OlinkViz/reference/plot_boxplot.md)
  — Single- or multi-protein boxplots with stats

- [`plot_dotplot()`](https://vanhungtran.github.io/OlinkViz/reference/plot_dotplot.md)
  — Multi-protein dot plots with effect sizes

- [`plot_corr()`](https://vanhungtran.github.io/OlinkViz/reference/plot_corr.md)
  — Protein correlation matrices

- [`plot_trajectory()`](https://vanhungtran.github.io/OlinkViz/reference/plot_trajectory.md)
  — Longitudinal spaghetti plots

- [`plot_bridge()`](https://vanhungtran.github.io/OlinkViz/reference/plot_bridge.md)
  — Bridge sample Bland-Altman / scatter comparison

- [`plot_plate_qc()`](https://vanhungtran.github.io/OlinkViz/reference/plot_plate_qc.md)
  — Plate/batch sample median NPX distribution

## Bundled datasets

Eleven curated Olink datasets are bundled with the package, spanning
Long COVID, primary CNS lymphoma, myasthenia gravis, tuberculosis, and
Down syndrome studies. See `data(package = "OlinkViz")` for the full
list.

## Shiny app

[`run_shiny()`](https://vanhungtran.github.io/OlinkViz/reference/run_shiny.md)
launches an interactive dashboard for exploring built-in datasets or
uploading your own.

## See also

Useful links:

- <https://github.com/vanhungtran/OlinkViz>

- <https://vanhungtran.github.io/OlinkViz>

- Report bugs at <https://github.com/vanhungtran/OlinkViz/issues>

## Author

**Maintainer**: Lucas VHH Tran <tranhungydhcm@gmail.com>

Authors:

- Lucas VHH Tran <tranhungydhcm@gmail.com>
