# OlinkViz Shiny App — Server Logic

server <- function(input, output, session) {

  # ---- Reactive data loading ----
  current_data <- reactive({
    if (input$data_source == "builtin") {
      req(input$builtin_dataset)
      OlinkViz:::.builtin_datasets[[input$builtin_dataset]]
    } else {
      req(input$upload_file)
      ext <- tools::file_ext(input$upload_file$name)
      if (ext %in% c("xlsx", "xls")) {
        if (!requireNamespace("readxl", quietly = TRUE)) {
          showNotification("Install 'readxl' to read Excel files", type = "error")
          return(NULL)
        }
        readxl::read_excel(input$upload_file$datapath, guess_max = 10000)
      } else {
        sep <- input$upload_sep
        if (sep == "\\t" || sep == "t") sep <- "\t"
        data.table::fread(input$upload_file$datapath, sep = sep)
      }
    }
  })

  # ---- Data format detection ----
  data_format <- reactive({
    dt <- current_data()
    req(dt)
    OlinkViz:::detect_format(dt)
  })

  assay_col <- reactive({
    dt <- current_data()
    req(dt)
    OlinkViz:::get_assay_col(dt)
  })

  value_col <- reactive({
    dt <- current_data()
    req(dt)
    OlinkViz:::get_value_col(dt)
  })

  sample_col <- reactive({
    dt <- current_data()
    req(dt)
    OlinkViz:::get_sample_col(dt)
  })

  group_cols <- reactive({
    dt <- current_data()
    req(dt)
    OlinkViz:::get_group_cols(dt)
  })

  assay_list <- reactive({
    dt <- current_data()
    req(dt)
    OlinkViz:::get_assay_list(dt, assay_col())
  })

  # ---- Data summary ----
  output$data_summary <- renderPrint({
    dt <- current_data()
    req(dt)
    cat("Rows:", nrow(dt), "\n")
    cat("Columns:", ncol(dt), "\n")
    cat("Format:", data_format(), "\n")
    if (data_format() == "long") {
      cat("Assay col:", assay_col() %||% "not detected", "\n")
      cat("NPX col:", value_col() %||% "not detected", "\n")
      cat("Unique assays:", length(assay_list()), "\n")
    }
  })

  # ---- Dynamic UI outputs ----
  output$group_col_ui <- renderUI({
    cols <- group_cols()
    if (length(cols) > 0) {
      selectInput("group_col", "Color/Group by:",
                  choices = c("None" = "", cols), selected = "")
    } else {
      p("No grouping columns detected.", style = "color: grey; font-size: 0.85em;")
    }
  })

  output$boxplot_assay_ui <- renderUI({
    assays <- assay_list()
    if (length(assays) > 0) {
      selectInput("boxplot_assay", "Select protein:",
                  choices = assays, selected = assays[1])
    } else {
      p("No assay column detected. Try a dataset with Assay/Protein column.",
        style = "color: red;")
    }
  })

  output$dotplot_assays_ui <- renderUI({
    assays <- assay_list()
    if (length(assays) > 0) {
      selectInput("dotplot_assays", "Select proteins (or leave empty for top N):",
                  choices = assays, multiple = TRUE, selected = NULL)
    }
  })

  output$traj_assay_ui <- renderUI({
    assays <- assay_list()
    if (length(assays) > 0) {
      selectInput("traj_assay", "Select protein:", choices = assays)
    }
  })

  output$traj_subject_ui <- renderUI({
    dt <- current_data()
    req(dt)
    candidates <- c("SubjectID", "Patient", "subjectid", "SampleID", "sample_id")
    avail <- intersect(candidates, names(dt))
    if (length(avail) > 0) {
      selectInput("traj_subject", "Subject ID column:", choices = avail, selected = avail[1])
    } else {
      textInput("traj_subject", "Subject ID column:", value = "SubjectID")
    }
  })

  output$traj_time_ui <- renderUI({
    dt <- current_data()
    req(dt)
    candidates <- c("Time", "time", "Timepoint", "timing_month", "Visit", "visit")
    avail <- intersect(candidates, names(dt))
    if (length(avail) > 0) {
      selectInput("traj_time", "Time column:", choices = avail, selected = avail[1])
    } else {
      textInput("traj_time", "Time column:", value = "Time")
    }
  })

  # ---- Main plot rendering ----
  main_plot <- reactive({
    dt <- current_data()
    req(dt, input$plot_type)

    group <- if (!is.null(input$group_col) && input$group_col != "") {
      input$group_col
    } else {
      NULL
    }

    ac <- assay_col()
    vc <- value_col()
    sc <- sample_col()

    tryCatch({

      switch(input$plot_type,

        "volcano" = {
          # Build a simple differential expression table from group comparison
          req(group, ac, vc)
          validate(need(!is.null(group), "Select a group column for volcano plot."))
          assays <- assay_list()
          if (length(assays) > 50) assays <- assays[seq_len(50)]
          de_list <- lapply(assays, function(a) {
            sub <- dt[dt[[ac]] == a, ]
            grp_vals <- split(sub[[vc]], sub[[group]])
            if (length(grp_vals) < 2) return(NULL)
            tryCatch({
              tt <- t.test(grp_vals[[1]], grp_vals[[2]])
              data.frame(Assay = a, pval = tt$p.value,
                         log2FC = mean(grp_vals[[2]], na.rm = TRUE) -
                                  mean(grp_vals[[1]], na.rm = TRUE),
                         stringsAsFactors = FALSE)
            }, error = function(e) NULL)
          })
          de_df <- do.call(rbind, de_list[!vapply(de_list, is.null, logical(1))])
          validate(need(nrow(de_df) > 0, "Could not compute differential expression."))
          OlinkViz::plot_volcano(de_df, pval_col = "pval", fc_col = "log2FC",
                                 pval_threshold = input$volcano_pval,
                                 fc_threshold = input$volcano_fc)
        },

        "heatmap" = {
          req(ac, vc, sc)
          OlinkViz::plot_heatmap(dt, assay_col = ac, value_col = vc,
                                 sample_col = sc, scale = input$heatmap_scale,
                                 show_rownames = FALSE)
        },

        "pca" = {
          req(ac, vc, sc)
          OlinkViz::plot_pca(dt, color_by = group, assay_col = ac,
                             value_col = vc, sample_col = sc,
                             ellipse = input$dimred_ellipse)
        },

        "umap" = {
          req(ac, vc, sc)
          OlinkViz::plot_umap(dt, color_by = group, assay_col = ac,
                              value_col = vc, sample_col = sc,
                              n_neighbors = input$umap_neighbors,
                              ellipse = input$dimred_ellipse)
        },

        "boxplot" = {
          req(input$boxplot_assay, group, ac, vc)
          validate(need(!is.null(group), "Select a group column for boxplot."))
          OlinkViz::plot_boxplot(dt, assay = input$boxplot_assay, group = group,
                                 assay_col = ac, value_col = vc)
        },

        "dotplot" = {
          req(group, ac, vc)
          validate(need(!is.null(group), "Select a group column for dot plot."))
          OlinkViz::plot_dotplot(dt, assays = input$dotplot_assays, group = group,
                                 assay_col = ac, value_col = vc,
                                 top_n = input$dotplot_top_n)
        },

        "corr" = {
          req(ac, vc, sc)
          OlinkViz::plot_corr(dt, method = input$corr_method,
                              assay_col = ac, value_col = vc, sample_col = sc,
                              top_n = input$corr_top_n)
        },

        "trajectory" = {
          req(input$traj_assay, input$traj_subject, input$traj_time, ac, vc)
          OlinkViz::plot_trajectory(dt, subject_id = input$traj_subject,
                                    time = input$traj_time,
                                    assay = input$traj_assay,
                                    group = group,
                                    assay_col = ac, value_col = vc)
        },

        stop("Unknown plot type: ", input$plot_type)
      )

    }, error = function(e) {
      ggplot2::ggplot() +
        ggplot2::annotate("text", x = 1, y = 1,
                          label = paste("Error:", e$message),
                          size = 5, color = "red") +
        ggplot2::theme_void()
    })
  })

  output$main_plot <- renderPlot({
    main_plot()
  })

  # ---- Downloads ----
  output$download_png <- downloadHandler(
    filename = function() {
      paste0("olinkviz_", input$plot_type, "_",
             format(Sys.time(), "%Y%m%d_%H%M%S"), ".png")
    },
    content = function(file) {
      ggplot2::ggsave(file, plot = main_plot(), width = 10, height = 7,
                      dpi = 300, bg = "white")
    }
  )

  output$download_pdf <- downloadHandler(
    filename = function() {
      paste0("olinkviz_", input$plot_type, "_",
             format(Sys.time(), "%Y%m%d_%H%M%S"), ".pdf")
    },
    content = function(file) {
      ggplot2::ggsave(file, plot = main_plot(), width = 10, height = 7,
                      device = "pdf")
    }
  )
}
