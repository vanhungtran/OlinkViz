# Dotplot --------------------------------------------------------------------

#' Dot plot for multiple proteins grouped by condition
#'
#' Creates a Cleveland-style dot plot showing effect sizes or mean differences
#' for multiple assays across groups. Dot size encodes significance and color
#' encodes direction or magnitude.
#'
#' @param data A data.frame in long format.
#' @param assays Character vector of assay names to include. If NULL, uses
#'   all unique assays (use with caution on large panels).
#' @param group Column name for the grouping variable.
#' @param assay_col Name of the assay column (default "Assay").
#' @param value_col Name of the NPX value column (default "NPX").
#' @param ref_group Reference group for computing fold changes. If NULL,
#'   uses the first level of the group factor.
#' @param top_n Limit to the top N assays by inter-group difference (default 20).
#' @param palette Color palette for the dot fill.
#' @param title Plot title.
#' @param ... Additional arguments passed to `ggplot2::geom_point()`.
#' @return A ggplot object.
#' @export
#' @examples
#' \dontrun{
#' plot_dotplot(beatmg_npx, group = "Timepoint", top_n = 15)
#' }
plot_dotplot <- function(data, assays = NULL, group,
                         assay_col = "Assay", value_col = "NPX",
                         ref_group = NULL, top_n = 20,
                         palette = NULL, title = NULL, ...) {

  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required for plot_dotplot().")
  }
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("Package 'dplyr' is required for plot_dotplot().")
  }

  df <- as.data.frame(data)
  validate_npx(df, assay_col = assay_col, value_col = value_col,
               fail_on_missing = TRUE)

  if (!is.factor(df[[group]])) {
    df[[group]] <- as.factor(df[[group]])
  }

  group_levels <- levels(df[[group]])
  if (length(group_levels) < 2) {
    stop("Group column must have at least 2 levels.")
  }

  if (is.null(ref_group)) {
    ref_group <- group_levels[1]
  }
  comp_levels <- setdiff(group_levels, ref_group)

  # Filter assays
  if (!is.null(assays)) {
    missing_assays <- setdiff(assays, df[[assay_col]])
    if (length(missing_assays) > 0) {
      warning("Assay(s) not found in data: ",
              paste(missing_assays, collapse = ", "))
    }
    df <- df[df[[assay_col]] %in% assays, , drop = FALSE]
    if (nrow(df) == 0) {
      stop("No data remaining after filtering to specified assays.")
    }
  }

  # Compute per-assay statistics: mean per group, log2FC vs reference, p-value
  assay_list <- unique(df[[assay_col]])

  stats_list <- lapply(assay_list, function(a) {
    sub <- df[df[[assay_col]] == a, , drop = FALSE]
    ref_vals <- sub[[value_col]][sub[[group]] == ref_group]
    ref_mean <- mean(ref_vals, na.rm = TRUE)

    results <- lapply(comp_levels, function(cl) {
      comp_vals <- sub[[value_col]][sub[[group]] == cl]
      comp_mean <- mean(comp_vals, na.rm = TRUE)
      fc <- comp_mean - ref_mean  # NPX difference (log2 scale)
      # Welch t-test p-value
      pval <- tryCatch(
        stats::t.test(ref_vals, comp_vals)$p.value,
        error = function(e) NA_real_
      )
      data.frame(
        Assay       = a,
        Comparison  = paste0(cl, " vs ", ref_group),
        log2FC      = fc,
        pval        = pval,
        ref_mean    = ref_mean,
        comp_mean   = comp_mean,
        stringsAsFactors = FALSE
      )
    })
    do.call(rbind, results)
  })

  stats_df <- do.call(rbind, stats_list)
  if (is.null(stats_df) || nrow(stats_df) == 0) {
    stop("No valid statistics could be computed for any assay-group combination")
  }

  n_failed <- sum(is.na(stats_df$pval))
  stats_df <- stats_df[!is.na(stats_df$pval), , drop = FALSE]
  if (nrow(stats_df) == 0) {
    stop("All statistical tests failed; check group sizes and data quality")
  }
  if (n_failed > 0) {
    warning(n_failed, " comparison(s) failed to compute (likely small group ",
            "sizes or missing values); omitted from plot")
  }

  stats_df$neg_log10_pval <- -log10(stats_df$pval)
  stats_df$direction <- ifelse(stats_df$log2FC > 0, "Up", "Down")
  stats_df$significant <- stats_df$pval < 0.05

  # Select top N
  if (nrow(stats_df) > top_n) {
    stats_df <- stats_df[order(stats_df$neg_log10_pval, decreasing = TRUE)[seq_len(top_n)], ]
  }

  if (is.null(title)) {
    title <- paste0("Protein Differences: ", paste(comp_levels, collapse = ", "),
                    " vs ", ref_group)
  }

  if (is.null(palette)) {
    palette <- c("Up" = "#E41A1C", "Down" = "#377EB8")
  }

  p <- ggplot2::ggplot(
    stats_df,
    ggplot2::aes(x = .data$log2FC, y = .data$Assay,
                 size = .data$neg_log10_pval, color = .data$direction)
  ) +
    ggplot2::geom_point(alpha = 0.8, ...) +
    ggplot2::geom_vline(xintercept = 0, linetype = "dashed",
                        color = "grey50", linewidth = 0.4) +
    ggplot2::scale_color_manual(values = palette) +
    ggplot2::scale_size_continuous(name = bquote(-log[10] ~ p)) +
    ggplot2::labs(
      x     = paste0("NPX Difference (vs ", ref_group, ")"),
      y     = NULL,
      color = "Direction",
      title = title
    ) +
    ggplot2::facet_wrap(~ Comparison, scales = "free_y", ncol = 1) +
    theme_olinkviz()

  return(p)
}
