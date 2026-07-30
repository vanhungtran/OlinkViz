# OlinkViz Shiny App — Global Environment
#
# Loads all built-in datasets and provides helper functions for the Shiny app.
# This file is sourced first by app.R.

library(shiny)
library(bslib)
library(ggplot2)
library(data.table)

# ---- Load datasets ----
.builtin_datasets <- list(
  "IRIS Long COVID"          = OlinkViz::iris_longcovid,
  "PCNSL (CNS Lymphoma)"     = OlinkViz::pcnsl_olink,
  "BeatMG NPX"               = OlinkViz::beatmg_npx,
  "BeatMG Demographics"      = OlinkViz::beatmg_demo,
  "BeatMG Merged"            = OlinkViz::beatmg_npx_merged,
  "Bansal Baseline 57"       = OlinkViz::bansal_baseline57,
  "Bansal Univariate"        = OlinkViz::bansal_univariate,
  "Bansal Longitudinal"      = OlinkViz::bansal_longitudinal,
  "Qinfeng TB"               = OlinkViz::qinfeng_npx,
  "TOFA Down Syndrome"       = OlinkViz::tofa_data,
  "TOFA Dictionary"          = OlinkViz::tofa_dictionary
)

# ---- Data format detection helpers ----
detect_format <- function(dt) {
  """Guesses whether a dataset is long-format or wide-format."""
  # Long format has an Assay/assay column and an NPX/npx column
  long_indicators <- c("Assay", "assay", "Protein", "protein")
  value_indicators <- c("NPX", "npx")

  has_assay <- any(long_indicators %in% names(dt))
  has_npx   <- any(value_indicators %in% names(dt))

  if (has_assay && has_npx) return("long")

  # Wide format: many numeric columns (proteins)
  num_cols <- names(dt)[vapply(dt, is.numeric, logical(1))]
  if (length(num_cols) > 10) return("wide")

  return("unknown")
}

get_assay_col <- function(dt) {
  candidates <- c("Assay", "assay", "Protein", "protein", "OlinkID")
  match <- intersect(candidates, names(dt))
  if (length(match) > 0) match[1] else NULL
}

get_value_col <- function(dt) {
  candidates <- c("NPX", "npx", "value", "Value")
  match <- intersect(candidates, names(dt))
  if (length(match) > 0) match[1] else NULL
}

get_sample_col <- function(dt) {
  candidates <- c("SampleID", "sampleid", "sample_id", "SubjectID", "Patient")
  match <- intersect(candidates, names(dt))
  if (length(match) > 0) match[1] else NULL
}

get_group_cols <- function(dt) {
  """Return factor/character columns suitable for grouping."""
  names(dt)[vapply(dt, function(x) is.factor(x) || is.character(x), logical(1))]
}

get_assay_list <- function(dt, assay_col) {
  if (!is.null(assay_col) && assay_col %in% names(dt)) {
    sort(unique(as.character(dt[[assay_col]])))
  } else {
    character(0)
  }
}
