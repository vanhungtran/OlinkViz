# OlinkViz Shiny App — User Interface

ui <- page_sidebar(
  title = "OlinkViz — Olink Proteomics Explorer",

  # ---- Sidebar ----
  sidebar = sidebar(
    width = 350,

    # Dataset section
    accordion(
      accordion_panel(
        "Data Source",
        icon = bsicons::bs_icon("database"),

        radioButtons(
          "data_source", "Choose data source:",
          choices = c("Built-in dataset" = "builtin",
                      "Upload CSV/Excel" = "upload"),
          selected = "builtin"
        ),

        conditionalPanel(
          condition = "input.data_source == 'builtin'",
          selectInput(
            "builtin_dataset", "Select dataset:",
            choices = names(OlinkViz:::.builtin_datasets),
            selected = "IRIS Long COVID"
          )
        ),

        conditionalPanel(
          condition = "input.data_source == 'upload'",
          fileInput(
            "upload_file", "Upload NPX data file:",
            accept = c(".csv", ".txt", ".tsv", ".xlsx")
          ),
          textInput("upload_sep", "Separator (for CSV/TXT):", value = ","),
          uiOutput("upload_format_ui")
        ),

        hr(),
        h6("Data Summary"),
        verbatimTextOutput("data_summary")
      ),

      # Plot selector
      accordion_panel(
        "Plot Type",
        icon = bsicons::bs_icon("bar-chart"),

        selectInput(
          "plot_type", "Choose visualization:",
          choices = c(
            "Volcano Plot"    = "volcano",
            "Heatmap"         = "heatmap",
            "PCA"             = "pca",
            "UMAP"            = "umap",
            "Boxplot"         = "boxplot",
            "Dot Plot"        = "dotplot",
            "Correlation"     = "corr",
            "Trajectory"      = "trajectory"
          ),
          selected = "boxplot"
        )
      ),

      # Plot-specific controls
      accordion_panel(
        "Plot Options",
        icon = bsicons::bs_icon("sliders"),

        # --- Shared controls ---
        uiOutput("group_col_ui"),

        # --- Boxplot controls ---
        conditionalPanel(
          condition = "input.plot_type == 'boxplot'",
          uiOutput("boxplot_assay_ui")
        ),

        # --- Dotplot controls ---
        conditionalPanel(
          condition = "input.plot_type == 'dotplot'",
          uiOutput("dotplot_assays_ui"),
          numericInput("dotplot_top_n", "Top N proteins:", value = 20, min = 5, max = 50)
        ),

        # --- Volcano controls ---
        conditionalPanel(
          condition = "input.plot_type == 'volcano'",
          numericInput("volcano_pval", "P-value threshold:", value = 0.05,
                       min = 0.001, max = 1, step = 0.01),
          numericInput("volcano_fc", "|log2 FC| threshold:", value = 1,
                       min = 0, max = 5, step = 0.1)
        ),

        # --- Heatmap controls ---
        conditionalPanel(
          condition = "input.plot_type == 'heatmap'",
          selectInput("heatmap_scale", "Scale:",
                      choices = c("row", "column", "none"), selected = "row"),
          numericInput("heatmap_top_n", "Top N proteins:", value = 50, min = 10, max = 200)
        ),

        # --- Correlation controls ---
        conditionalPanel(
          condition = "input.plot_type == 'corr'",
          selectInput("corr_method", "Method:",
                      choices = c("spearman", "pearson", "kendall"), selected = "spearman"),
          numericInput("corr_top_n", "Top N proteins:", value = 30, min = 5, max = 100)
        ),

        # --- Trajectory controls ---
        conditionalPanel(
          condition = "input.plot_type == 'trajectory'",
          uiOutput("traj_assay_ui"),
          uiOutput("traj_subject_ui"),
          uiOutput("traj_time_ui")
        ),

        # --- PCA/UMAP controls ---
        conditionalPanel(
          condition = "input.plot_type == 'pca' || input.plot_type == 'umap'",
          checkboxInput("dimred_ellipse", "Show group ellipses", value = TRUE),
          conditionalPanel(
            condition = "input.plot_type == 'umap'",
            numericInput("umap_neighbors", "n_neighbors:", value = 15, min = 2, max = 50)
          )
        ),

        hr(),

        # Download
        downloadButton("download_png", "Download PNG"),
        downloadButton("download_pdf", "Download PDF")
      ),

      open = c("Data Source", "Plot Type", "Plot Options")
    )
  ),

  # ---- Main panel ----
  card(
    full_screen = TRUE,
    card_body(
      plotOutput("main_plot", height = "600px")
    )
  )
)
