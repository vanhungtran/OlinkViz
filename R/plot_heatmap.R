# Heatmap --------------------------------------------------------------------

#' Heatmap of protein expression
#'
#' Creates a clustered heatmap of protein expression values. Accepts data in
#' long format (pivots to wide internally) or already in wide format.
#'
#' @param data A data.frame. Long format must have `assay_col`, `value_col`,
#'   and `sample_col`. Wide format should have samples as rows and proteins
#'   as columns.
#' @param assay_col Name of the assay column (long format; default "Assay").
#' @param value_col Name of the NPX value column (long format; default "NPX").
#' @param sample_col Name of the sample ID column (long format; default "SampleID").
#' @param wide If TRUE, data is assumed to be in wide format (default FALSE).
#' @param annotation_cols Columns to use for column (sample) annotation tracks.
#' @param scale Scaling direction: "row", "column", or "none" (default "row").
#' @param cluster_rows Logical; perform hierarchical clustering on rows (default TRUE).
#' @param cluster_cols Logical; perform hierarchical clustering on columns (default TRUE).
#' @param show_rownames Logical; show row (protein) names (default FALSE, usually too many).
#' @param show_colnames Logical; show column (sample) names (default TRUE).
#' @param color Palette of colors for the heatmap gradient.
#' @param fontsize Base font size (default 8).
#' @param main Title for the heatmap.
#' @param ... Additional arguments passed to `pheatmap::pheatmap()`.
#' @return A pheatmap object (invisibly).
#' @export
#' @examples
#' \dontrun{
#' plot_heatmap(beatmg_npx, annotation_cols = "Timepoint")
#' }
plot_heatmap <- function(data, assay_col = "Assay", value_col = "NPX",
                         sample_col = "SampleID", wide = FALSE,
                         annotation_cols = NULL, scale = "row",
                         cluster_rows = TRUE, cluster_cols = TRUE,
                         show_rownames = FALSE, show_colnames = TRUE,
                         color = NULL, fontsize = 8, main = NULL, ...) {

  if (!requireNamespace("pheatmap", quietly = TRUE)) {
    stop("Package 'pheatmap' is required for plot_heatmap().")
  }

  df <- as.data.frame(data)

  # Build wide matrix
  if (!wide) {
    # Long format - validate
    validate_npx(df, assay_col = assay_col, value_col = value_col,
                 sample_col = sample_col, fail_on_missing = TRUE)

    # Extract annotation columns before pivot
    annot_df <- NULL
    if (!is.null(annotation_cols)) {
      avail_annot <- intersect(annotation_cols, names(df))
      if (length(avail_annot) > 0) {
        annot_sub <- unique(df[, c(sample_col, avail_annot), drop = FALSE])
        rownames(annot_sub) <- annot_sub[[sample_col]]
        annot_df <- annot_sub[, avail_annot, drop = FALSE]
      }
    }

    wide_df <- to_wide(df, assay_col = assay_col, value_col = value_col,
                       sample_col = sample_col)
  } else {
    wide_df <- df
    annot_df <- NULL
    if (!is.null(annotation_cols)) {
      avail_annot <- intersect(annotation_cols, names(df))
      if (length(avail_annot) > 0) {
        annot_df <- df[, avail_annot, drop = FALSE]
      }
    }
  }

  # Build numeric matrix
  sample_names <- wide_df[[sample_col]]

  # Handle duplicate sample names
  if (anyDuplicated(sample_names)) {
    dup_count <- sum(duplicated(sample_names))
    warning(dup_count, " duplicate sample name(s) found; appending suffix to make unique")
    sample_names <- make.unique(as.character(sample_names))
  }

  # Find numeric columns
  num_cols <- names(wide_df)[vapply(wide_df, is.numeric, logical(1))]
  mat <- as.matrix(wide_df[, num_cols, drop = FALSE])
  rownames(mat) <- sample_names
  # Proteins as rows, samples as columns
  mat <- t(mat)

  # Set up column (sample) annotation
  if (!is.null(annot_df) && nrow(annot_df) > 0) {
    rownames(annot_df) <- make.unique(as.character(sample_names))
    annotation_col <- annot_df
  } else {
    annotation_col <- NA
  }

  # Default color palette (blue-white-red diverging)
  if (is.null(color)) {
    color <- grDevices::colorRampPalette(
      c("#2166AC", "#F7F7F7", "#B2182B")
    )(100)
  }

  # Scale if requested
  if (scale == "row") {
    mat <- t(scale(t(mat)))
  } else if (scale == "column") {
    mat <- scale(mat)
  }

  # Handle NAs: warn and impute with column means for clustering
  na_count <- sum(is.na(mat))
  mat_clean <- mat
  if (na_count > 0) {
    warning(na_count, " NA value(s) detected; imputing with column means. ",
            "Consider preprocessing data before plotting.")
    for (j in seq_len(ncol(mat_clean))) {
      col_na <- is.na(mat_clean[, j])
      if (any(col_na)) {
        mat_clean[col_na, j] <- mean(mat_clean[, j], na.rm = TRUE)
      }
    }
  }

  ph <- pheatmap::pheatmap(
    mat_clean,
    scale             = "none",   # We scale beforehand
    color             = color,
    cluster_rows      = cluster_rows,
    cluster_cols      = cluster_cols,
    show_rownames     = show_rownames,
    show_colnames     = show_colnames,
    annotation_col    = annotation_col,
    fontsize          = fontsize,
    main              = main,
    ...
  )

  invisible(ph)
}
