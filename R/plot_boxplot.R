# Boxplot --------------------------------------------------------------------

#' Boxplot of a single protein by group
#'
#' Creates a boxplot with overlaid jittered points for a single assay, grouped
#' by a categorical variable. Optionally adds statistical comparison annotations.
#'
#' @param data A data.frame in long format.
#' @param assay Name of the protein/assay to plot (must match a value in `assay_col`).
#' @param group Column name for the grouping variable.
#' @param assay_col Name of the assay column (default "Assay").
#' @param value_col Name of the NPX value column (default "NPX").
#' @param comparisons A list of length-2 vectors specifying pairwise comparisons
#'   for statistical brackets (passed to `ggplot2::stat_compare_means()` if
#'   `ggpubr` is available).
#' @param test Statistical test: "wilcox.test", "t.test", or "none" (default "wilcox.test").
#' @param jitter_width Width of the jitter (default 0.2).
#' @param palette Optional color palette; uses `olinkviz_palette()` if NULL.
#' @param title Plot title. If NULL, uses the assay name.
#' @param ... Additional arguments passed to `ggplot2::geom_boxplot()`.
#' @return A ggplot object.
#' @export
#' @examples
#' \dontrun{
#' plot_boxplot(beatmg_npx, assay = "CD27", group = "Timepoint")
#' }
plot_boxplot <- function(data, assay, group,
                         assay_col = "Assay", value_col = "NPX",
                         comparisons = NULL, test = "wilcox.test",
                         jitter_width = 0.2, palette = NULL,
                         title = NULL, ...) {

  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required for plot_boxplot().")
  }

  df <- as.data.frame(data)
  validate_npx(df, assay_col = assay_col, value_col = value_col,
               fail_on_missing = TRUE)

  # Filter to the requested assay
  df_sub <- df[df[[assay_col]] == assay, , drop = FALSE]
  if (nrow(df_sub) == 0) {
    stop("Assay '", assay, "' not found in column '", assay_col, "'.")
  }

  # Ensure group is a factor
  if (!is.factor(df_sub[[group]])) {
    df_sub[[group]] <- as.factor(df_sub[[group]])
  }

  n_groups <- length(unique(df_sub[[group]]))

  # Palette
  if (is.null(palette)) {
    palette <- olinkviz_palette(n_groups)
  }

  if (is.null(title)) {
    title <- assay
  }

  p <- ggplot2::ggplot(df_sub, ggplot2::aes(
    x = .data[[group]],
    y = .data[[value_col]],
    fill = .data[[group]]
  )) +
    ggplot2::geom_boxplot(outlier.shape = NA, alpha = 0.6, ...) +
    ggplot2::geom_jitter(
      width = jitter_width, size = 1.5, alpha = 0.5, color = "grey30"
    ) +
    ggplot2::scale_fill_manual(values = palette, guide = "none") +
    ggplot2::labs(
      x     = group,
      y     = "NPX",
      title = title
    ) +
    theme_olinkviz()

  # Statistical comparisons
  has_ggpubr <- requireNamespace("ggpubr", quietly = TRUE)
  if (test != "none") {
    if (!has_ggpubr) {
      warning("Package 'ggpubr' is not installed. Statistical annotations ",
              "will be omitted. Install with: install.packages('ggpubr')")
    } else if (!is.null(comparisons)) {
      p <- p + ggpubr::stat_compare_means(
        comparisons = comparisons,
        method = test,
        label = "p.format",
        size = 3
      )
    } else if (n_groups == 2) {
      p <- p + ggpubr::stat_compare_means(
        method = test,
        label = "p.format",
        size = 3
      )
    }
  }

  return(p)
}
