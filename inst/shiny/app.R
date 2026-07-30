# OlinkViz Shiny App — Entry Point
#
# Launch with: OlinkViz::run_shiny()
#   or directly: shiny::runApp('inst/shiny')

cat("Starting OlinkViz Shiny App...\n")
cat("Loading datasets...\n")

# The app sources global.R, ui.R, and server.R
shiny::shinyApp(ui = source("ui.R", local = TRUE)$value,
                server = source("server.R", local = TRUE)$value)
