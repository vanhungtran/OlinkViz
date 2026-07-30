# PCA biplot -----------------------------------------------------------------

#' PCA biplot of protein expression data
#'
#' Performs principal component analysis on protein expression data and plots
#' the first two principal components. Samples are colored by an optional
#' grouping variable with confidence ellipses.
#'
#' @param data A data.frame in long format.
#' @param color_by Optional column name to color points by groups.
#' @param label_by Optional column name for sample point labels.
#' @param assay_col Name of the assay column (default "Assay").
#' @param value_col Name of the NPX value column (default "NPX").
#' @param sample_col Name of the sample ID column (default "SampleID").
#' @param scale Logical; scale variables to unit variance before PCA (default TRUE).
#' @param center Logical; center variables before PCA (default TRUE).
#' @param ellipse Logical; draw confidence ellipses around groups (default TRUE).
#' @param ellipse_level Confidence level for ellipses (default 0.95).
#' @param title Plot title.
#' @param ... Additional arguments passed to `ggplot2::geom_point()`.
#' @return A ggplot object.
#' @export
#' @examples
#' \dontrun{
#' plot_pca(beatmg_npx, color_by = "Timepoint")
#' }
plot_pca <- function(data, color_by = NULL, label_by = NULL,
                     assay_col = "Assay", value_col = "NPX",
                     sample_col = "SampleID", scale = TRUE,
                     center = TRUE, ellipse = TRUE, ellipse_level = 0.95,
                     title = "PCA of Protein Expression", ...) {

  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required for plot_pca().")
  }

  df <- as.data.frame(data)

  # Build wide matrix
  wide_df <- to_wide(df, assay_col = assay_col, value_col = value_col,
                     sample_col = sample_col)

  # Separate numeric data from metadata
  num_cols <- names(wide_df)[vapply(wide_df, is.numeric, logical(1))]
  meta_cols <- setdiff(names(wide_df), num_cols)

  X <- as.matrix(wide_df[, num_cols, drop = FALSE])

  # Remove columns with zero variance
  col_var <- apply(X, 2, stats::var, na.rm = TRUE)
  zero_var <- col_var <= 0 | is.na(col_var)
  if (any(zero_var)) {
    n_zero <- sum(zero_var)
    message("Removing ", n_zero, " zero-variance column(s) before PCA")
    X <- X[, !zero_var, drop = FALSE]
  }

  if (ncol(X) < 2) {
    stop("Fewer than 2 variable columns remain after filtering; cannot compute PCA")
  }

  # Impute any remaining NAs with column means
  na_count <- sum(is.na(X))
  for (j in seq_len(ncol(X))) {
    X[is.na(X[, j]), j] <- mean(X[, j], na.rm = TRUE)
  }
  if (na_count > 0) {
    warning(na_count, " NA value(s) imputed with column means before PCA")
  }

  # PCA
  pca_res <- stats::prcomp(X, center = center, scale. = scale)

  # Variance explained
  var_exp <- round(100 * pca_res$sdev^2 / sum(pca_res$sdev^2), 1)

  # Build plot data
  plot_df <- as.data.frame(pca_res$x[, 1:2])
  names(plot_df) <- c("PC1", "PC2")
  plot_df[[sample_col]] <- wide_df[[sample_col]]

  # Attach metadata columns
  for (col in meta_cols) {
    if (col %in% names(wide_df)) {
      plot_df[[col]] <- wide_df[[col]]
    }
  }

  # Color aesthetic
  if (!is.null(color_by) && color_by %in% names(plot_df)) {
    plot_df$.color <- as.factor(plot_df[[color_by]])
  } else {
    if (!is.null(color_by) && !color_by %in% names(plot_df)) {
      warning("Column '", color_by, "' not found in data; ignoring color_by")
    }
    plot_df$.color <- factor(1)
  }

  # Build plot
  p <- ggplot2::ggplot(
    plot_df,
    ggplot2::aes(x = .data$PC1, y = .data$PC2, color = .data$.color)
  ) +
    ggplot2::geom_point(size = 3, alpha = 0.8, ...) +
    ggplot2::labs(
      x      = paste0("PC1 (", var_exp[1], "%)"),
      y      = paste0("PC2 (", var_exp[2], "%)"),
      color  = if (!is.null(color_by)) color_by else NULL,
      title = title
    ) +
    theme_olinkviz()

  # Add ellipses if there are groups
  if (ellipse && !is.null(color_by) && color_by %in% names(plot_df) &&
      length(unique(plot_df$.color)) > 1) {
    p <- p + ggplot2::stat_ellipse(
      ggplot2::aes(fill = .data$.color),
      level = ellipse_level, alpha = 0.1, geom = "polygon", show.legend = FALSE
    )
  }

  # Add labels if requested
  if (!is.null(label_by) && label_by %in% names(plot_df)) {
    if (requireNamespace("ggrepel", quietly = TRUE)) {
      p <- p + ggrepel::geom_text_repel(
        ggplot2::aes(label = .data[[label_by]]),
        size = 3, show.legend = FALSE
      )
    } else {
      p <- p + ggplot2::geom_text(
        ggplot2::aes(label = .data[[label_by]]),
        size = 3, vjust = -1, show.legend = FALSE
      )
    }
  }

  # Single color - hide legend
  if (is.null(color_by) || !color_by %in% names(plot_df)) {
    p <- p + ggplot2::theme(legend.position = "none")
  }

  return(p)
}
