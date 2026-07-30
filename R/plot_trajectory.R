# Longitudinal trajectory plot -----------------------------------------------

#' Longitudinal trajectory (spaghetti) plot
#'
#' Plots individual trajectories of protein expression over time, with optional
#' group-level smoothing lines. Designed for paired/longitudinal Olink data.
#'
#' @param data A data.frame in long format containing a time column and
#'   a subject identifier column.
#' @param subject_id Name of the column identifying individual subjects.
#' @param time Name of the column containing time points.
#' @param assay Name of the protein/assay to plot (single assay). If NULL,
#'   the first assay in `assay_col` is used.
#' @param group Optional column to color by and add group-level LOESS smooth.
#' @param assay_col Name of the assay column (default "Assay").
#' @param value_col Name of the NPX value column (default "NPX").
#' @param alpha_line Alpha for individual lines (default 0.3).
#' @param alpha_point Alpha for individual points (default 0.5).
#' @param smooth_method Smoothing method: "loess", "lm", "glm", or "gam" (default "loess").
#' @param smooth_se Show confidence bands for group smooth (default TRUE).
#' @param palette Optional color palette for groups.
#' @param title Plot title.
#' @param ... Additional arguments passed to `ggplot2::stat_smooth()`.
#' @return A ggplot object.
#' @export
#' @examples
#' \dontrun{
#' plot_trajectory(bansal_longitudinal, subject_id = "Patient", time = "Time",
#'                 assay = "HAGH", group = "Long_COVID")
#' }
plot_trajectory <- function(data, subject_id, time, assay = NULL,
                            group = NULL, assay_col = "Assay",
                            value_col = "NPX", alpha_line = 0.3,
                            alpha_point = 0.5, smooth_method = "loess",
                            smooth_se = TRUE, palette = NULL,
                            title = NULL, ...) {

  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required for plot_trajectory().")
  }

  df <- as.data.frame(data)

  # Validate columns
  required <- c(subject_id, time, value_col)
  missing  <- setdiff(required, names(df))
  if (length(missing) > 0) {
    stop("Missing columns: ", paste(missing, collapse = ", "))
  }

  # Filter to a single assay
  if (!is.null(assay)) {
    if (!assay_col %in% names(df)) {
      stop("Assay column '", assay_col, "' not found. If data is already subset, set assay = NULL.")
    }
    df <- df[df[[assay_col]] == assay, , drop = FALSE]
    if (nrow(df) == 0) stop("Assay '", assay, "' not found.")
  }

  # Ensure subject_id is factor/character
  df$.subject <- as.character(df[[subject_id]])

  # Time should be numeric for proper x-axis
  if (!is.numeric(df[[time]])) {
    time_levels <- unique(df[[time]])
    df$.time <- as.numeric(as.factor(df[[time]]))
    time_label <- paste0(time, " (encoded: ",
                         paste(time_levels, collapse = ", "), ")")
  } else {
    df$.time <- df[[time]]
    time_label <- time
  }

  # Group
  has_group <- !is.null(group) && group %in% names(df)
  if (has_group) {
    if (!is.factor(df[[group]])) {
      df$.group <- as.factor(df[[group]])
    } else {
      df$.group <- df[[group]]
    }
    # Warn about and exclude NA groups
    na_group <- is.na(df$.group)
    if (any(na_group)) {
      warning(sum(na_group), " row(s) with NA in group column '",
              group, "' will be excluded from coloring")
    }
    n_groups <- length(unique(df$.group[!na_group]))
    if (n_groups == 0) {
      has_group <- FALSE
      n_groups <- 1
    }
  } else {
    df$.group <- factor(1)
    n_groups <- 1
  }

  if (is.null(palette)) {
    palette <- olinkviz_palette(max(1, n_groups))
  }

  if (is.null(title)) {
    if (!is.null(assay)) {
      title <- paste0("Trajectory of ", assay, " Over Time")
    } else {
      title <- "Protein Trajectory Over Time"
    }
  }

  # Sort by subject and time for correct line connections
  df <- df[order(df$.subject, df$.time), , drop = FALSE]

  p <- ggplot2::ggplot(
    df,
    ggplot2::aes(x = .data$.time, y = .data[[value_col]])
  ) +
    ggplot2::geom_line(
      ggplot2::aes(group = .data$.subject),
      alpha = alpha_line, linewidth = 0.3, color = "grey50"
    ) +
    ggplot2::geom_point(
      ggplot2::aes(color = if (has_group) .data$.group else NULL),
      alpha = alpha_point, size = 1.5
    ) +
    ggplot2::labs(
      x     = time_label,
      y     = "NPX",
      color = if (has_group) group else NULL,
      title = title
    ) +
    theme_olinkviz()

  # Group smoothing
  if (has_group) {
    p <- p + ggplot2::stat_smooth(
      ggplot2::aes(color = .data$.group, fill = .data$.group),
      method  = smooth_method,
      se      = smooth_se,
      linewidth = 1.2,
      alpha   = 0.15,
      ...
    ) +
      ggplot2::scale_color_manual(values = palette) +
      ggplot2::scale_fill_manual(values = palette, guide = "none")
  }

  # Remove legend if only one group
  if (!has_group) {
    p <- p + ggplot2::theme(legend.position = "none")
  }

  return(p)
}
