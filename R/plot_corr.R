# Correlation matrix ---------------------------------------------------------

#' Correlation matrix of protein expression
#'
#' Computes pairwise correlations between proteins (or samples) and renders a
#' correlation matrix plot. Uses `corrplot::corrplot()` for visualization.
#'
#' @param data A data.frame in long format (or wide if `wide = TRUE`).
#' @param method Correlation method: "pearson", "spearman" (default), or "kendall".
#' @param assay_col Name of the assay column (long format; default "Assay").
#' @param value_col Name of the NPX value column (long format; default "NPX").
#' @param sample_col Name of the sample ID column (long format; default "SampleID").
#' @param wide If TRUE, data is in wide format with samples as rows (default FALSE).
#' @param top_n Limit to the top N assays by variance (default 30).
#' @param corr_type Type of corrplot: "full", "upper", or "lower" (default "upper").
#' @param display_method Visual method for corrplot: "color" (default), "circle",
#'   "ellipse", "number", "shade", or "pie".
#' @param order Ordering method: "hclust" (default), "AOE", "FPC", "alphabet", or "original".
#' @param tl.cex Text label size (default 0.7).
#' @param title Plot title.
#' @param ... Additional arguments passed to `corrplot::corrplot()`.
#' @return Invisibly returns the correlation matrix.
#' @export
#' @examples
#' \dontrun{
#' plot_corr(beatmg_npx, method = "spearman", top_n = 20)
#' }
plot_corr <- function(data, method = "spearman",
                      assay_col = "Assay", value_col = "NPX",
                      sample_col = "SampleID", wide = FALSE,
                      top_n = 30, corr_type = "upper",
                      display_method = "color",
                      order = "hclust", tl.cex = 0.7,
                      title = NULL, ...) {

  if (!requireNamespace("corrplot", quietly = TRUE)) {
    stop("Package 'corrplot' is required for plot_corr(). Install with: install.packages('corrplot')")
  }

  df <- as.data.frame(data)

  # Build wide matrix
  if (!wide) {
    validate_npx(df, assay_col = assay_col, value_col = value_col,
                 sample_col = sample_col, fail_on_missing = TRUE)
    wide_df <- to_wide(df, assay_col = assay_col, value_col = value_col,
                       sample_col = sample_col)
  } else {
    wide_df <- df
  }

  # Extract numeric protein columns
  num_cols <- names(wide_df)[vapply(wide_df, is.numeric, logical(1))]
  mat <- as.matrix(wide_df[, num_cols, drop = FALSE])

  # Impute NAs with column means
  na_count <- sum(is.na(mat))
  for (j in seq_len(ncol(mat))) {
    mat[is.na(mat[, j]), j] <- mean(mat[, j], na.rm = TRUE)
  }
  if (na_count > 0) {
    warning(na_count, " NA value(s) imputed with column means ",
            "before computing correlations")
  }

  # Select top N by variance
  if (ncol(mat) > top_n) {
    col_var <- apply(mat, 2, stats::var, na.rm = TRUE)
    top_idx <- order(col_var, decreasing = TRUE)[seq_len(top_n)]
    mat <- mat[, top_idx, drop = FALSE]
  }

  # Compute correlation
  cor_mat <- stats::cor(mat, method = method, use = "pairwise.complete.obs")

  # Plot (do NOT pass title to corrplot; we add it with mtext for consistency)
  corrplot::corrplot(
    cor_mat,
    method = display_method,
    type   = corr_type,
    order  = order,
    tl.cex = tl.cex,
    tl.col = "black",
    mar    = c(0, 0, if (!is.null(title)) 2 else 0, 0),
    ...
  )

  if (!is.null(title)) {
    graphics::mtext(title, side = 3, line = 0, cex = 1.2, font = 2)
  }

  invisible(cor_mat)
}
