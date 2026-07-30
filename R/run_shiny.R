# Shiny app launcher ---------------------------------------------------------

#' Launch the OlinkViz interactive Shiny application
#'
#' Opens an interactive Shiny dashboard for exploring Olink proteomics
#' datasets. The app allows users to select from built-in curated datasets
#' or upload their own NPX data files, then generate publication-quality
#' plots interactively.
#'
#' @param ... Additional arguments passed to `shiny::runApp()`.
#' @return Called for its side effect of launching a Shiny app.
#' @export
#' @examples
#' \dontrun{
#' run_shiny()
#' }
run_shiny <- function(...) {
  if (!requireNamespace("shiny", quietly = TRUE)) {
    stop(
      "Package 'shiny' is required for the OlinkViz Shiny app.\n",
      "Install with: install.packages('shiny')"
    )
  }
  if (!requireNamespace("bslib", quietly = TRUE)) {
    stop(
      "Package 'bslib' is required for the OlinkViz Shiny app.\n",
      "Install with: install.packages('bslib')"
    )
  }

  app_dir <- system.file("shiny", package = "OlinkViz")
  if (app_dir == "") {
    stop(
      "Shiny app not found. This may happen when running from source.\n",
      "Try: shiny::runApp('inst/shiny')"
    )
  }
  shiny::runApp(app_dir, ...)
}
