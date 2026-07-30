# OlinkViz shared utilities ------------------------------------------------

#' OlinkViz ggplot2 theme
#'
#' A clean, publication-ready ggplot2 theme for OlinkViz plots.
#' Builds on `theme_bw()` with minimal gridlines and consistent typography.
#'
#' @param base_size Base font size in points (default 11).
#' @param base_family Base font family (default "sans").
#' @return A ggplot2 theme object.
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mtcars, aes(wt, mpg)) + geom_point() + theme_olinkviz()
theme_olinkviz <- function(base_size = 11, base_family = "sans") {
  ggplot2::theme_bw(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      panel.grid.major   = ggplot2::element_blank(),
      panel.grid.minor   = ggplot2::element_blank(),
      strip.background   = ggplot2::element_rect(fill = "grey95", colour = NA),
      strip.placement    = "outside",
      strip.text         = ggplot2::element_text(size = base_size, face = "bold"),
      legend.position    = "bottom",
      legend.title       = ggplot2::element_text(size = base_size),
      legend.text        = ggplot2::element_text(size = base_size - 1),
      legend.key.size    = ggplot2::unit(0.5, "cm"),
      axis.title         = ggplot2::element_text(size = base_size),
      axis.text          = ggplot2::element_text(size = base_size - 1, colour = "black"),
      plot.title         = ggplot2::element_text(size = base_size + 2, face = "bold"),
      plot.subtitle      = ggplot2::element_text(size = base_size),
      plot.caption       = ggplot2::element_text(size = base_size - 2, colour = "grey50"),
      plot.title.position = "plot"
    )
}

#' OlinkViz color palette
#'
#' Returns a vector of colors suitable for categorical grouping in OlinkViz plots.
#' Uses the Set2 palette from RColorBrewer (colorblind-friendly) by default,
#' extended to handle larger group counts via interpolation.
#'
#' @param n Number of colors to return.
#' @param palette Name of the RColorBrewer qualitative palette (default "Dark2").
#' @return A character vector of hex color codes of length `n`.
#' @export
#' @examples
#' olinkviz_palette(4)
#' olinkviz_palette(12)  # interpolated beyond palette max
olinkviz_palette <- function(n = 8, palette = "Dark2") {
  max_n <- RColorBrewer::brewer.pal.info[palette, "maxcolors"]
  if (n <= max_n) {
    RColorBrewer::brewer.pal(n, palette)
  } else {
    # Extend via colorRampPalette
    base <- RColorBrewer::brewer.pal(max_n, palette)
    grDevices::colorRampPalette(base)(n)
  }
}

#' Validate NPX data structure
#'
#' Checks that a data frame has the minimum required columns for long-format
#' NPX data. Warnings are issued for common issues; errors for missing columns.
#'
#' @param data A data.frame or data.table.
#' @param assay_col Name of the assay/protein column (default "Assay").
#' @param value_col Name of the NPX value column (default "NPX").
#' @param sample_col Name of the sample identifier column (default "SampleID").
#' @param fail_on_missing If TRUE, stops on missing columns; otherwise warns.
#' @return Invisibly returns TRUE if all checks pass.
#' @export
validate_npx <- function(data, assay_col = "Assay", value_col = "NPX",
                         sample_col = "SampleID", fail_on_missing = TRUE) {
  required <- c(assay_col, value_col)
  missing  <- setdiff(required, names(data))

  if (length(missing) > 0) {
    msg <- paste("Missing required columns:", paste(missing, collapse = ", "))
    if (fail_on_missing) stop(msg) else warning(msg)
    return(invisible(FALSE))
  }

  # Check NPX is numeric
  if (!is.numeric(data[[value_col]])) {
    warning("Column '", value_col, "' is not numeric -- coercing with as.numeric()")
  }

  # Warn if SampleID is missing but don't fail (not all plots need it)
  if (!sample_col %in% names(data)) {
    message("Note: column '", sample_col, "' not found -- some plots may need it")
  }

  invisible(TRUE)
}

#' Pivot long-format NPX data to wide format
#'
#' Converts long-format Olink data (one row per assay per sample) to a wide
#' matrix where rows are samples and columns are assays (proteins).
#'
#' @param data A data.frame in long format.
#' @param assay_col Name of the assay column (default "Assay").
#' @param value_col Name of the NPX value column (default "NPX").
#' @param sample_col Name of the sample ID column (default "SampleID").
#' @param id_cols Additional columns to keep as sample-level identifiers.
#'   If NULL (default), non-numeric columns (except assay/value columns) are
#'   automatically preserved as identifiers.
#' @return A data.frame in wide format.
#' @export
to_wide <- function(data, assay_col = "Assay", value_col = "NPX",
                    sample_col = "SampleID", id_cols = NULL) {
  if (!requireNamespace("tidyr", quietly = TRUE)) {
    stop("Package 'tidyr' is required for to_wide().")
  }

  # Auto-detect non-numeric metadata columns to preserve
  if (is.null(id_cols)) {
    non_num <- names(data)[!vapply(data, is.numeric, logical(1))]
    known_special <- c(assay_col, value_col)
    id_cols <- setdiff(non_num, known_special)
  }

  id_cols_full <- unique(c(sample_col, id_cols))
  id_cols_full <- intersect(id_cols_full, names(data))

  # Average replicates if multiple rows per assay per sample
  key_cols <- c(id_cols_full, assay_col)
  key_cols <- intersect(key_cols, names(data))

  data_agg <- data
  if (anyDuplicated(data[, key_cols, drop = FALSE])) {
    n_dup <- sum(duplicated(data[, key_cols, drop = FALSE]))
    message("Averaging ", n_dup, " replicate(s) across assay-sample combinations")
    # Use base R aggregate to avoid data.table scoping issues
    agg_formula <- stats::as.formula(
      paste(value_col, "~", paste(key_cols, collapse = " + "))
    )
    data_agg <- stats::aggregate(agg_formula, data = data, FUN = mean, na.rm = TRUE)
    # Restore original column order (aggregate moves value column to end)
    data_agg <- data_agg[, names(data[, unique(c(key_cols, value_col))]), drop = FALSE]
  }

  wide <- tidyr::pivot_wider(
    data_agg,
    id_cols     = dplyr::all_of(id_cols_full),
    names_from  = dplyr::all_of(assay_col),
    values_from = dplyr::all_of(value_col),
    values_fn   = mean
  )
  wide <- as.data.frame(wide)

  # Check for duplicate sample IDs after pivot (bad if TRUE)
  if (anyDuplicated(wide[[sample_col]])) {
    n_dup_samples <- sum(duplicated(wide[[sample_col]]))
    warning(n_dup_samples, " duplicate sample ID(s) found in column '",
            sample_col, "'; wide-format rows may not be uniquely identified")
  }

  return(wide)
}

#' Pivot wide-format data to long format
#'
#' Converts wide-format data (samples as rows, proteins as columns) to long
#' format compatible with OlinkViz plot functions.
#'
#' @param data A data.frame in wide format.
#' @param assay_cols Character vector of column names to pivot (the protein/assay columns).
#'   If NULL, all columns not in `id_cols` are treated as assay columns.
#' @param id_cols Columns to keep as identifiers (not pivoted).
#' @param assay_col Name for the new assay column (default "Assay").
#' @param value_col Name for the new NPX value column (default "NPX").
#' @param exclude_cols Character vector of column names to exclude from
#'   auto-detected assay columns when `assay_cols = NULL`. Ignored when
#'   `assay_cols` is provided explicitly. Defaults to common non-protein
#'   identifier columns.
#' @return A data.frame in long format.
#' @export
to_long <- function(data, assay_cols = NULL, id_cols = NULL,
                    assay_col = "Assay", value_col = "NPX",
                    exclude_cols = NULL) {
  if (!requireNamespace("tidyr", quietly = TRUE)) {
    stop("Package 'tidyr' is required for to_long().")
  }

  # Detect numeric assay columns if not specified
  if (is.null(assay_cols)) {
    if (!is.null(id_cols)) {
      assay_cols <- setdiff(names(data), id_cols)
    } else {
      assay_cols <- names(data)[vapply(data, is.numeric, logical(1))]
    }
    # Exclude obviously non-NPX columns
    if (is.null(exclude_cols)) {
      exclude_cols <- c("SampleID", "SubjectID", "Patient",
                         "sample_id", "batch", "replicate_of")
    }
    before_n <- length(assay_cols)
    assay_cols <- setdiff(assay_cols, exclude_cols)
    if (before_n > length(assay_cols)) {
      removed <- intersect(names(data), setdiff(exclude_cols, assay_cols))
      if (length(removed) > 0) {
        message("Excluded ", length(removed), " non-assay column(s) from pivot: ",
                paste(removed, collapse = ", "))
      }
    }
  }

  long <- tidyr::pivot_longer(
    data,
    cols      = dplyr::all_of(assay_cols),
    names_to  = assay_col,
    values_to = value_col
  )
  as.data.frame(long)
}
