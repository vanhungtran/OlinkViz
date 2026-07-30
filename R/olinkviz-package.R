# OlinkViz package documentation ----------------------------------------------

#' OlinkViz: Visualization Toolkit for Olink Proteomics Data
#'
#' Provides ready-made, publication-quality visualization functions tailored to
#' Olink NPX proteomics data. Includes volcano plots, heatmaps, PCA and UMAP
#' projections, boxplots, dot plots, correlation matrices, and longitudinal
#' trajectory plots.
#'
#' @section Data format:
#' Most functions expect data in **long format** (one row per assay per sample)
#' with columns for assay name, NPX value, and sample identifier. Use
#' \code{\link{to_wide}()} and \code{\link{to_long}()} to convert between
#' formats. Use \code{\link{validate_npx}()} to check your data structure.
#'
#' @section Plotting functions:
#' \itemize{
#'   \item \code{\link{plot_volcano}()} — Volcano plots for differential expression
#'   \item \code{\link{plot_heatmap}()} — Clustered expression heatmaps
#'   \item \code{\link{plot_pca}()} — PCA biplots with group coloring
#'   \item \code{\link{plot_umap}()} — UMAP projections with group coloring
#'   \item \code{\link{plot_boxplot}()} — Single-protein boxplots with stats
#'   \item \code{\link{plot_dotplot}()} — Multi-protein dot plots with effect sizes
#'   \item \code{\link{plot_corr}()} — Protein correlation matrices
#'   \item \code{\link{plot_trajectory}()} — Longitudinal spaghetti plots
#' }
#'
#' @section Bundled datasets:
#' Eleven curated Olink datasets are bundled with the package, spanning Long
#' COVID, primary CNS lymphoma, myasthenia gravis, tuberculosis, and Down
#' syndrome studies. See \code{data(package = "OlinkViz")} for the full list.
#'
#' @section Shiny app:
#' \code{\link{run_shiny}()} launches an interactive dashboard for exploring
#' built-in datasets or uploading your own.
#'
#' @docType package
#' @name OlinkViz
NULL
