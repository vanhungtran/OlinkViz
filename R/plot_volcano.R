# Volcano plot ---------------------------------------------------------------

#' Volcano plot for differential expression results
#'
#' Creates a publication-ready volcano plot showing fold change versus
#' statistical significance for each protein/assay. Points are colored by
#' significance threshold.
#'
#' @param data A data.frame containing differential expression results.
#'   Must include columns for p-values and fold changes.
#' @param pval_col Name of the column containing p-values.
#' @param fc_col Name of the column containing fold changes (on log2 scale
#'   if already transformed; set `transform_fc = TRUE` for raw ratios).
#' @param label_col Optional column with labels to display (e.g., protein names
#'   for significant hits). If NULL, `assay_col` is used for significant points.
#' @param assay_col Name of the assay/protein identifier column.
#' @param pval_threshold P-value threshold for significance (default 0.05).
#' @param fc_threshold Absolute log2 fold change threshold (default 1, i.e. 2-fold).
#' @param transform_fc If TRUE, log2-transform the fold change column (default FALSE).
#' @param max_labels Maximum number of top significant points to label (default 15).
#' @param title Plot title.
#' @param ... Additional arguments passed to `ggplot2::geom_point()`.
#' @return A ggplot object.
#' @export
#' @examples
#' \dontrun{
#' # Using a test-results data frame with p-value and fold change columns
#' plot_volcano(de_results, pval_col = "pval", fc_col = "log2FC", assay_col = "Protein")
#' }
plot_volcano <- function(data, pval_col, fc_col, label_col = NULL,
                         assay_col = "Assay", pval_threshold = 0.05,
                         fc_threshold = 1, transform_fc = FALSE,
                         max_labels = 15, title = NULL, ...) {

  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required for plot_volcano().")
  }

  df <- as.data.frame(data)

  # Validate required columns
  for (col in c(pval_col, fc_col)) {
    if (!col %in% names(df)) stop("Column '", col, "' not found in data.")
  }

  # Validate p-values are in [0, 1]
  pvals <- df[[pval_col]]
  if (any(!is.na(pvals) & (pvals < 0 | pvals > 1))) {
    warning("Column '", pval_col, "' contains values outside [0, 1]; ",
            "are you sure this is a p-value column?")
  }
  if (any(!is.na(pvals) & pvals == 0)) {
    warning("Column '", pval_col, "' contains p-values of exactly 0; ",
            "capping to .Machine$double.xmin for -log10 transform")
    pvals[pvals == 0] <- .Machine$double.xmin
    df[[pval_col]] <- pvals
  }

  # Transform fold change if requested
  fc_values <- df[[fc_col]]
  if (isTRUE(transform_fc)) {
    fc_values <- log2(fc_values)
  }
  fc_label <- if (isTRUE(transform_fc)) "log2(Fold Change)" else fc_col

  # Build annotation columns
  df$`.neg_log10_pval` <- -log10(df[[pval_col]])
  df$`.significant` <- df[[pval_col]] < pval_threshold & abs(fc_values) > fc_threshold
  df$`.direction` <- ifelse(
    df$`.significant`,
    ifelse(fc_values > 0, "Up", "Down"),
    "NS"
  )

  # Determine labels
  if (is.null(label_col)) {
    df$`.label` <- ifelse(df$`.significant`, as.character(df[[assay_col]]), "")
  } else {
    df$`.label` <- ifelse(df$`.significant`, as.character(df[[label_col]]), "")
  }

  # Keep only top N labels by significance
  sig_idx <- which(df$`.significant`)
  if (length(sig_idx) > max_labels) {
    top_idx <- sig_idx[order(df$`.neg_log10_pval`[sig_idx], decreasing = TRUE)[seq_len(max_labels)]]
    df$`.label`[-top_idx] <- ""
  }

  # Build plot
  direction_colors <- c("Up" = "#E41A1C", "Down" = "#377EB8", "NS" = "grey70")
  direction_sizes  <- c("Up" = 2, "Down" = 2, "NS" = 1)

  p <- ggplot2::ggplot(df, ggplot2::aes(
    x = .data[[fc_col]],
    y = .data[[".neg_log10_pval"]],
    color = .data[[".direction"]],
    size = .data[[".direction"]]
  )) +
    ggplot2::geom_point(alpha = 0.7, ...) +
    ggplot2::scale_color_manual(values = direction_colors, name = NULL) +
    ggplot2::scale_size_manual(values = direction_sizes, guide = "none") +
    ggplot2::geom_hline(
      yintercept = -log10(pval_threshold),
      linetype = "dashed", color = "grey50", linewidth = 0.4
    ) +
    ggplot2::geom_vline(
      xintercept = c(-fc_threshold, fc_threshold),
      linetype = "dashed", color = "grey50", linewidth = 0.4
    ) +
    ggplot2::labs(
      x        = fc_label,
      y        = bquote(-log[10] ~ "(" * .(pval_col) * ")"),
      title   = title
    ) +
    theme_olinkviz()

  # Add labels if ggrepel is available
  if (requireNamespace("ggrepel", quietly = TRUE)) {
    p <- p + ggrepel::geom_text_repel(
      ggplot2::aes(label = .data[[".label"]]),
      size = 3, max.overlaps = max_labels, show.legend = FALSE
    )
  } else {
    p <- p + ggplot2::geom_text(
      ggplot2::aes(label = .data[[".label"]]),
      size = 3, vjust = -1, show.legend = FALSE
    )
  }

  return(p)
}
