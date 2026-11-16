# Package index

## Package Overview

Package overview and workflow

- [`OlinkViz-package`](https://vanhungtran.github.io/OlinkViz/reference/OlinkViz.md)
  [`OlinkViz`](https://vanhungtran.github.io/OlinkViz/reference/OlinkViz.md)
  : OlinkViz: Visualization Toolkit for Olink Proteomics Data

## Differential Expression & Concordance

Volcano plots, MA plots, multi-protein dot plots, forest plots, and
cross-cohort comparisons

- [`plot_volcano()`](https://vanhungtran.github.io/OlinkViz/reference/plot_volcano.md)
  : Volcano plot for differential expression results
- [`plot_ma()`](https://vanhungtran.github.io/OlinkViz/reference/plot_ma.md)
  : MA plot: NPX difference (log2 fold change) against mean NPX
  abundance
- [`plot_dotplot()`](https://vanhungtran.github.io/OlinkViz/reference/plot_dotplot.md)
  : Dot plot for multiple proteins grouped by condition
- [`plot_forest()`](https://vanhungtran.github.io/OlinkViz/reference/plot_forest.md)
  : Forest plot of protein effect sizes and confidence intervals
- [`plot_concordance()`](https://vanhungtran.github.io/OlinkViz/reference/plot_concordance.md)
  : Cross-cohort or cross-contrast effect-size concordance scatter plot
- [`plot_upset()`](https://vanhungtran.github.io/OlinkViz/reference/plot_upset.md)
  : UpSet plot of overlapping protein sets

## Dimensionality Reduction

PCA, UMAP, t-SNE, and heatmap projections

- [`plot_dim_reduc()`](https://vanhungtran.github.io/OlinkViz/reference/plot_dim_reduc.md)
  : Plot one or more dimensionality reductions of an OlinkExperiment
- [`plot_pca()`](https://vanhungtran.github.io/OlinkViz/reference/plot_pca.md)
  : PCA scatter plot of protein expression data
- [`plot_umap()`](https://vanhungtran.github.io/OlinkViz/reference/plot_umap.md)
  : UMAP projection of protein expression data
- [`plot_heatmap()`](https://vanhungtran.github.io/OlinkViz/reference/plot_heatmap.md)
  : Heatmap of protein expression
- [`plot_scree()`](https://vanhungtran.github.io/OlinkViz/reference/plot_scree.md)
  : PCA scree plot (variance explained)
- [`plot_loadings()`](https://vanhungtran.github.io/OlinkViz/reference/plot_loadings.md)
  : PCA loadings plot

## Single-Protein & Longitudinal

Boxplots, trajectories, mean profiles, and mixed-model plots

- [`plot_boxplot()`](https://vanhungtran.github.io/OlinkViz/reference/plot_boxplot.md)
  : Boxplot of one or more proteins by group
- [`plot_trajectory()`](https://vanhungtran.github.io/OlinkViz/reference/plot_trajectory.md)
  : Longitudinal trajectory (spaghetti) plot
- [`plot_spaghetti()`](https://vanhungtran.github.io/OlinkViz/reference/plot_spaghetti.md)
  : Spaghetti plot of individual NPX trajectories
- [`plot_mean_profile()`](https://vanhungtran.github.io/OlinkViz/reference/plot_mean_profile.md)
  : Mean profile plot (mean +/- CI over time by group)
- [`plot_violin()`](https://vanhungtran.github.io/OlinkViz/reference/plot_violin.md)
  : Violin + boxplot of one or more proteins
- [`plot_lmer()`](https://vanhungtran.github.io/OlinkViz/reference/plot_lmer.md)
  : LMER point-range plot
- [`plot_regression()`](https://vanhungtran.github.io/OlinkViz/reference/plot_regression.md)
  : Regression scatter plot with linear smooth

## Quality Control

Sample QC, assay detectability (LOD), plate distributions, and bridge
diagnostics

- [`plot_qc()`](https://vanhungtran.github.io/OlinkViz/reference/plot_qc.md)
  : Sample QC plot: median NPX versus interquartile range
- [`plot_lod()`](https://vanhungtran.github.io/OlinkViz/reference/plot_lod.md)
  : Assay detectability: percent of samples above the limit of detection
- [`plot_bridge()`](https://vanhungtran.github.io/OlinkViz/reference/plot_bridge.md)
  : Bridge sample comparison plot (Bland-Altman or scatter)
- [`plot_plate_qc()`](https://vanhungtran.github.io/OlinkViz/reference/plot_plate_qc.md)
  : Plate / batch NPX distribution plot

## Biomarker Performance

ROC curves of individual proteins with AUC and confidence interval

- [`plot_roc()`](https://vanhungtran.github.io/OlinkViz/reference/plot_roc.md)
  : ROC curves for one or more proteins

## Multi-Protein Survey

Correlation matrices

- [`plot_corr()`](https://vanhungtran.github.io/OlinkViz/reference/plot_corr.md)
  : Correlation matrix of protein expression
- [`plot_corr_triangle()`](https://vanhungtran.github.io/OlinkViz/reference/plot_corr_triangle.md)
  : Triangular correlation matrix with coefficient labels

## Networks & Pathways

STRING protein-protein interaction and pathway networks

- [`enrich_pathways()`](https://vanhungtran.github.io/OlinkViz/reference/enrich_pathways.md)
  : Enriched pathways for a set of proteins
- [`plot_network()`](https://vanhungtran.github.io/OlinkViz/reference/plot_network.md)
  : STRING protein-protein interaction network
- [`plot_pathway_network()`](https://vanhungtran.github.io/OlinkViz/reference/plot_pathway_network.md)
  : Top up-regulated proteins and their pathway network

## Data Utilities

Validate, pivot, and explore NPX data

- [`validate_npx()`](https://vanhungtran.github.io/OlinkViz/reference/validate_npx.md)
  : Validate NPX data structure
- [`to_wide()`](https://vanhungtran.github.io/OlinkViz/reference/to_wide.md)
  : Pivot long-format NPX data to wide format
- [`to_long()`](https://vanhungtran.github.io/OlinkViz/reference/to_long.md)
  : Pivot wide-format data to long format

## Journal Specifications

Registry of column widths, height limits, text/line floors, and fonts
per journal

- [`journal_spec()`](https://vanhungtran.github.io/OlinkViz/reference/journal_spec.md)
  : Look up a journal specification
- [`journal_specs()`](https://vanhungtran.github.io/OlinkViz/reference/journal_specs.md)
  : List the registered journal specifications
- [`journal_spec_add()`](https://vanhungtran.github.io/OlinkViz/reference/journal_spec_add.md)
  : Register a journal specification for this session
- [`journal_width()`](https://vanhungtran.github.io/OlinkViz/reference/journal_width.md)
  : Journal figure widths and heights
- [`journal_height()`](https://vanhungtran.github.io/OlinkViz/reference/journal_height.md)
  : Maximum figure height for a journal
- [`journal_font()`](https://vanhungtran.github.io/OlinkViz/reference/journal_font.md)
  : First installed font family a journal asks for

## Pre-Flight QA Checks

Audit built plots against journal limits before saving

- [`olinkviz_preflight()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_preflight.md)
  : Run every pre-flight check on a figure and print one report
- [`olinkviz_check_text()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_text.md)
  : Check text sizes against a journal's limits
- [`olinkviz_check_lines()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_lines.md)
  : Check stroke weights against a journal's minimum line weight
- [`olinkviz_check_size()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_size.md)
  : Check figure dimensions (and raster resolution) against a journal
- [`olinkviz_check_fit()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_fit.md)
  : Check whether the title/subtitle/caption will overflow the save
  width
- [`olinkviz_check_colour()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_check_colour.md)
  : Check that discrete colours stay distinguishable (colour-vision
  deficiency)

## Journal-Size Figures & Composites

Configure sizing, combine tagged panels, and export publication-ready
figures

- [`olinkviz_options()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_options.md)
  : Set OlinkViz sizing and journal options
- [`save_olinkviz()`](https://vanhungtran.github.io/OlinkViz/reference/save_olinkviz.md)
  : Save a plot at its final journal size and run pre-flight checks
- [`olinkviz_combine()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_combine.md)
  : Combine ggplots into one tagged, journal-styled composite
- [`labs_panel()`](https://vanhungtran.github.io/OlinkViz/reference/labs_panel.md)
  : Add a bold panel letter (a, b, c...) matching journal house style

## OlinkExperiment Container

An S4 container for NPX, LOD and annotation (modelled on
SingleCellExperiment)

- [`OlinkExperiment()`](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md)
  : The OlinkExperiment class
- [`oe_from_long()`](https://vanhungtran.github.io/OlinkViz/reference/oe_from_long.md)
  : Build an OlinkExperiment from long-format Olink data
- [`OE-assays`](https://vanhungtran.github.io/OlinkViz/reference/npx.md)
  [`npx`](https://vanhungtran.github.io/OlinkViz/reference/npx.md)
  [`npx<-`](https://vanhungtran.github.io/OlinkViz/reference/npx.md)
  [`npx,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/npx.md)
  [`npx<-,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/npx.md)
  [`lod`](https://vanhungtran.github.io/OlinkViz/reference/npx.md)
  [`lod<-`](https://vanhungtran.github.io/OlinkViz/reference/npx.md)
  [`lod,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/npx.md)
  [`lod<-,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/npx.md)
  [`pcount`](https://vanhungtran.github.io/OlinkViz/reference/npx.md)
  [`pcount<-`](https://vanhungtran.github.io/OlinkViz/reference/npx.md)
  [`pcount,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/npx.md)
  [`pcount<-,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/npx.md)
  : Named assay getters and setters for Olink data
- [`reducedDims`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
  [`reducedDim`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
  [`reducedDimNames`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
  [`reducedDim,OlinkExperiment,missing-method`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
  [`reducedDim,OlinkExperiment,numeric-method`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
  [`reducedDim,OlinkExperiment,character-method`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
  [`reducedDims,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
  [`reducedDimNames,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
  [`reducedDim<-`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
  [`reducedDims<-`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
  [`reducedDimNames<-`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
  [`reducedDim<-,OlinkExperiment,missing-method`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
  [`reducedDim<-,OlinkExperiment,numeric-method`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
  [`reducedDim<-,OlinkExperiment,character-method`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
  [`reducedDims<-,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
  [`reducedDimNames<-,OlinkExperiment,character-method`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
  : Reduced dimensions methods
- [`OE-combine`](https://vanhungtran.github.io/OlinkViz/reference/combine.md)
  [`cbind,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/combine.md)
  [`rbind,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/combine.md)
  [`[,OlinkExperiment,ANY-method`](https://vanhungtran.github.io/OlinkViz/reference/combine.md)
  [`[,OlinkExperiment,ANY,ANY-method`](https://vanhungtran.github.io/OlinkViz/reference/combine.md)
  [`[,OlinkExperiment,ANY,ANY,ANY-method`](https://vanhungtran.github.io/OlinkViz/reference/combine.md)
  [`[<-,OlinkExperiment,ANY,ANY,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/combine.md)
  : Combining or subsetting OlinkExperiment objects
- [`OE-internals`](https://vanhungtran.github.io/OlinkViz/reference/internals.md)
  [`int_colData`](https://vanhungtran.github.io/OlinkViz/reference/internals.md)
  [`int_elementMetadata`](https://vanhungtran.github.io/OlinkViz/reference/internals.md)
  [`int_metadata`](https://vanhungtran.github.io/OlinkViz/reference/internals.md)
  [`int_colData,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/internals.md)
  [`int_elementMetadata,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/internals.md)
  [`int_metadata,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/internals.md)
  [`int_colData<-`](https://vanhungtran.github.io/OlinkViz/reference/internals.md)
  [`int_elementMetadata<-`](https://vanhungtran.github.io/OlinkViz/reference/internals.md)
  [`int_metadata<-`](https://vanhungtran.github.io/OlinkViz/reference/internals.md)
  [`int_colData<-,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/internals.md)
  [`int_elementMetadata<-,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/internals.md)
  [`int_metadata<-,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/internals.md)
  [`colData,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/internals.md)
  [`rowData,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/internals.md)
  [`parallel_slot_names,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/internals.md)
  : Internal OlinkExperiment functions
- [`OE-miscellaneous`](https://vanhungtran.github.io/OlinkViz/reference/miscellaneous.md)
  [`show,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/miscellaneous.md)
  [`objectVersion`](https://vanhungtran.github.io/OlinkViz/reference/miscellaneous.md)
  [`objectVersion,OlinkExperiment-method`](https://vanhungtran.github.io/OlinkViz/reference/miscellaneous.md)
  : Miscellaneous OlinkExperiment methods
- [`as.data.frame(`*`<OlinkExperiment>`*`)`](https://vanhungtran.github.io/OlinkViz/reference/as.data.frame-OlinkExperiment-method.md)
  : Coerce an OlinkExperiment to a long-format data.frame

## Themes, Palettes & Scales

Styling for publication-ready plots and journal-inspired palettes

- [`theme_olinkviz()`](https://vanhungtran.github.io/OlinkViz/reference/theme_olinkviz.md)
  : OlinkViz ggplot2 theme
- [`theme_journal()`](https://vanhungtran.github.io/OlinkViz/reference/theme_journal.md)
  : Journal theme driven by the journal specification registry
- [`theme_journal_text()`](https://vanhungtran.github.io/OlinkViz/reference/theme_journal_text.md)
  : Journal text sizes, added to a plot without touching anything else
- [`theme_editorial()`](https://vanhungtran.github.io/OlinkViz/reference/theme_editorial.md)
  : Editorial ggplot2 theme for reports, preprints, and presentations
- [`olinkviz_palette()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_palette.md)
  : OlinkViz color palette
- [`olinkviz_palettes()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_palettes.md)
  : OlinkViz themed and journal palettes (named list)
- [`scale_colour_olinkviz()`](https://vanhungtran.github.io/OlinkViz/reference/scale_colour_olinkviz.md)
  [`scale_color_olinkviz()`](https://vanhungtran.github.io/OlinkViz/reference/scale_colour_olinkviz.md)
  [`scale_fill_olinkviz()`](https://vanhungtran.github.io/OlinkViz/reference/scale_colour_olinkviz.md)
  : Discrete colour and fill scales using OlinkViz and journal palettes
- [`pal_okabe_ito`](https://vanhungtran.github.io/OlinkViz/reference/pal_okabe_ito.md)
  : The Okabe-Ito colorblind-safe palette
- [`pal_sunbird`](https://vanhungtran.github.io/OlinkViz/reference/pal_sunbird.md)
  : The Sunbird palette
- [`pal_redcap`](https://vanhungtran.github.io/OlinkViz/reference/pal_redcap.md)
  : The Red-Capped Bird palette
- [`pal_jewel`](https://vanhungtran.github.io/OlinkViz/reference/pal_jewel.md)
  : The Iridescent Jewel palette
- [`pal_scarlet`](https://vanhungtran.github.io/OlinkViz/reference/pal_scarlet.md)
  : The Scarlet Bird palette

## Shiny App

Interactive exploration dashboard

- [`run_shiny()`](https://vanhungtran.github.io/OlinkViz/reference/run_shiny.md)
  : Launch the OlinkViz interactive Shiny application

## Datasets

Curated Olink proteomics data from published studies

- [`iris_longcovid`](https://vanhungtran.github.io/OlinkViz/reference/iris_longcovid.md)
  : IRIS Long COVID Olink Data
- [`pcnsl_olink`](https://vanhungtran.github.io/OlinkViz/reference/pcnsl_olink.md)
  : PCNSL Plasma Olink Data
- [`beatmg_npx`](https://vanhungtran.github.io/OlinkViz/reference/beatmg_npx.md)
  : BeatMG Olink NPX Data
- [`beatmg_demo`](https://vanhungtran.github.io/OlinkViz/reference/beatmg_demo.md)
  : BeatMG Demographics
- [`beatmg_npx_merged`](https://vanhungtran.github.io/OlinkViz/reference/beatmg_npx_merged.md)
  : BeatMG NPX Merged with Demographics
- [`bansal_baseline57`](https://vanhungtran.github.io/OlinkViz/reference/bansal_baseline57.md)
  : Bansal Long COVID Baseline Data
- [`bansal_univariate`](https://vanhungtran.github.io/OlinkViz/reference/bansal_univariate.md)
  : Bansal Long COVID Univariate Results
- [`bansal_longitudinal`](https://vanhungtran.github.io/OlinkViz/reference/bansal_longitudinal.md)
  : Bansal Long COVID Longitudinal Data
- [`qinfeng_npx`](https://vanhungtran.github.io/OlinkViz/reference/qinfeng_npx.md)
  : Qinfeng Tuberculosis Olink Data
- [`tofa_data`](https://vanhungtran.github.io/OlinkViz/reference/tofa_data.md)
  : TOFA Down Syndrome Olink Data
- [`tofa_dictionary`](https://vanhungtran.github.io/OlinkViz/reference/tofa_dictionary.md)
  : TOFA Data Dictionary
- [`probc`](https://vanhungtran.github.io/OlinkViz/reference/probc.md) :
  Simulated Two-Group Longitudinal Olink Data
