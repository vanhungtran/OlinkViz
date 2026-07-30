# UMAP projection ------------------------------------------------------------

#' UMAP projection of protein expression data
#'
#' Performs Uniform Manifold Approximation and Projection (UMAP) on protein
#' expression data and plots the first two embedding dimensions. Requires the
#' `umap` package.
#'
#' @param data A data.frame in long format.
#' @param color_by Optional column name to color points by groups.
#' @param assay_col Name of the assay column (default "Assay").
#' @param value_col Name of the NPX value column (default "NPX").
#' @param sample_col Name of the sample ID column (default "SampleID").
#' @param n_neighbors Number of neighbors for UMAP (default 15).
#' @param min_dist Minimum distance between embedded points (default 0.1).
#' @param metric Distance metric (default "euclidean").
#' @param seed Random seed for reproducibility.
#' @param ellipse Logical; draw confidence ellipses around groups (default TRUE).
#' @param title Plot title.
#' @param ... Additional arguments passed to `umap::umap()`.
#' @return A ggplot object.
#' @export
#' @examples
#' \dontrun{
#' plot_umap(beatmg_npx, color_by = "Timepoint", n_neighbors = 10)
#' }
plot_umap <- function(data, color_by = NULL,
                      assay_col = "Assay", value_col = "NPX",
                      sample_col = "SampleID", n_neighbors = 15,
                      min_dist = 0.1, metric = "euclidean", seed = 42,
                      ellipse = TRUE, title = "UMAP of Protein Expression",
                      ...) {

  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required for plot_umap().")
  }
  if (!requireNamespace("umap", quietly = TRUE)) {
    stop("Package 'umap' is required for plot_umap(). Install with: install.packages('umap')")
  }

  df <- as.data.frame(data)

  # Build wide matrix
  wide_df <- to_wide(df, assay_col = assay_col, value_col = value_col,
                     sample_col = sample_col)

  num_cols <- names(wide_df)[vapply(wide_df, is.numeric, logical(1))]
  meta_cols <- setdiff(names(wide_df), num_cols)

  X <- as.matrix(wide_df[, num_cols, drop = FALSE])

  # Remove zero-variance columns and impute
  col_var <- apply(X, 2, stats::var, na.rm = TRUE)
  zero_var <- col_var <= 0 | is.na(col_var)
  if (any(zero_var)) {
    n_zero <- sum(zero_var)
    message("Removing ", n_zero, " zero-variance column(s) before UMAP")
    X <- X[, !zero_var, drop = FALSE]
  }

  if (ncol(X) < 2) {
    stop("Fewer than 2 variable columns remain after filtering; cannot compute UMAP")
  }

  na_count <- sum(is.na(X))
  for (j in seq_len(ncol(X))) {
    X[is.na(X[, j]), j] <- mean(X[, j], na.rm = TRUE)
  }
  if (na_count > 0) {
    warning(na_count, " NA value(s) imputed with column means before UMAP")
  }

  # UMAP
  if (!is.null(seed)) set.seed(seed)
  umap_config <- umap::umap.defaults
  umap_config$n_neighbors <- n_neighbors
  umap_config$min_dist    <- min_dist
  umap_config$metric      <- metric

  # Merge user-supplied config overrides from ... without duplicating named args
  umap_res <- umap::umap(X, config = umap_config, ...)

  # Build plot data
  plot_df <- as.data.frame(umap_res$layout)
  names(plot_df) <- c("UMAP1", "UMAP2")
  plot_df[[sample_col]] <- wide_df[[sample_col]]

  for (col in meta_cols) {
    if (col %in% names(wide_df)) {
      plot_df[[col]] <- wide_df[[col]]
    }
  }

  if (!is.null(color_by) && color_by %in% names(plot_df)) {
    plot_df$.color <- as.factor(plot_df[[color_by]])
  } else {
    if (!is.null(color_by) && !color_by %in% names(plot_df)) {
      warning("Column '", color_by, "' not found in data; ignoring color_by")
    }
    plot_df$.color <- factor(1)
  }

  p <- ggplot2::ggplot(
    plot_df,
    ggplot2::aes(x = .data$UMAP1, y = .data$UMAP2, color = .data$.color)
  ) +
    ggplot2::geom_point(size = 3, alpha = 0.8) +
    ggplot2::labs(
      x     = "UMAP 1",
      y     = "UMAP 2",
      color = if (!is.null(color_by)) color_by else NULL,
      title = title
    ) +
    theme_olinkviz()

  if (ellipse && !is.null(color_by) && color_by %in% names(plot_df) &&
      length(unique(plot_df$.color)) > 1) {
    p <- p + ggplot2::stat_ellipse(
      ggplot2::aes(fill = .data$.color),
      level = 0.95, alpha = 0.1, geom = "polygon", show.legend = FALSE
    )
  }

  if (is.null(color_by) || !color_by %in% names(plot_df)) {
    p <- p + ggplot2::theme(legend.position = "none")
  }

  return(p)
}
