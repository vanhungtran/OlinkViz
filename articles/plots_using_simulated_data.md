# Plots Generated from the Simulated Dataset (PROBC)

## About this document

This file was generated automatically by `collect_plot_code.R` on
2026-08-05.

It collects every R code chunk from the NUMAB analysis reports that
generates a **plot from the simulated dataset** (`PROBC`), i.e. chunks
that reference `PROBC` directly or an object that traces back to it
(e.g. `dat`, `test1`, `lmer_results`, …).

**Source files scanned:**

| Source report             | Plot chunks collected |
|:--------------------------|----------------------:|
| DAPlan.Rmd                |                     4 |
| Draft_report.Rmd          |                    13 |
| NUMAB_Appendice_model.Rmd |                     1 |
| NUMAB_Appendice.Rmd       |                     9 |
| NUMABRep01.Rmd            |                     6 |
| NUMABRep02.Rmd            |                    12 |
| NUMABRep03.Rmd            |                    15 |
| NUMABRep04.Rmd            |                    19 |
| SAP_NUMAB_01.Rmd          |                    10 |
| **Total**                 |                **89** |

## Setup (packages + simulation of the dataset)

Run this first so the plot code below can be executed. The simulation
code below is the **active** version that creates the second group
(`PRO_Bc`) and builds `PROBC` (from `NUMAB/NUMAB/import_data.R`).

``` r
source("import_packages.R")
```

``` r
# ---- Read real Group 1 data (project B) ----
ProjB      <- suppressWarnings(suppressMessages(OlinkAnalyze::read_NPX("E:/NUMAB/Inflammation_Immune Response_CK-Care_project B_NPX.xlsx")))
ProjB_meta <- readxl::read_excel("E:/NUMAB/ProjB_meta.xlsx")
ProjB_meta$SampleID <- ProjB_meta$`B10-ID`
PRO_B <- merge(ProjB, ProjB_meta)
PRO_B$Project <- "B"
PRO_B <- PRO_B %>% filter(!grepl('CONTROL', SampleID))
PRO_B$Time     <- as.numeric(as.integer(PRO_B$Timepoint))
PRO_B$PPID     <- factor(PRO_B$PPID)
PRO_B$Project  <- "Group1"

# ---- SIMULATED second group ----
PRO_Bc <- PRO_B
PRO_Bc$SampleID <- paste0(PRO_Bc$SampleID, "_1")
PRO_Bc$Index    <- PRO_Bc$Index + max(PRO_Bc$Index)
PRO_Bc$NPX      <- PRO_Bc$NPX * (1 + runif(n = length(PRO_Bc$NPX), min = -0.1, max = 0.15)) +
                    rbinom(length(PRO_Bc$NPX), 1, 0.2)
PRO_Bc$Project  <- "Group2"
PRO_Bc$PPID     <- paste0(PRO_Bc$PPID, "_1")

# ---- Simulated analysis dataset ----
PROBC <- rbind(PRO_B, PRO_Bc)
```

## DAPlan.Rmd

Plot chunk `(unnamed chunk)` — simulated object(s):
`PROBC, dat, lmm_model, emm, contrasts_phases, lmm_model_1`

``` r
# ---- Source: DAPlan.Rmd | chunk: (unnamed chunk) ----
PROBC$Group <- factor(PROBC$Project)
PROBC$Timepoint <- factor(PROBC$Time)
dat <- PROBC %>% dplyr::filter((Assay %in% "IL6") & (Panel %in%  "Olink Inflammation"))




group_by(dat, Timepoint) %>% 
  get_summary_stats(NPX)


group_by(dat, Group, Timepoint) %>% 
  summarise(mean = list(mean_ci(NPX)), .groups = "drop") %>% 
  unnest_wider(mean) %>% 
  mutate(agex = as.numeric(Timepoint) - 1 + .05*(Group == "Group1")) %>% 
  ggplot(aes(agex, y, col = Group, shape = Group)) +
  geom_point() +
  geom_errorbar(aes(ymin = ymin, ymax = ymax), width = 0.2) +
  geom_line() +
  labs(x = "Timepoint, days", y = "NPX", shape = "Group", col = "Group")



# Fit a linear mixed model
lmm_model <- lmer(NPX ~ Group*Timepoint + (1|PPID), data = dat)
summary(lmm_model)
emmip(lmm_model,  Group ~ Timepoint , data = dat, CIs = TRUE, xlab="Timepoint")

# Display contrasts for PHASE within each level of Sailors
emm <- emmeans(lmm_model, ~ Group * Timepoint)
contrasts_phases <- pairs(emm, simple="each", adjust="Bonferroni")
print(contrasts_phases)



lmm_model_1 <- lmer(NPX ~ Group + Timepoint + (1|PPID), data = dat)
summary(lmm_model_1)
anova(lmm_model_1, lmm_model)


#kableExtra::kable(x = broom::tidy(lmm_model_1), format = "pipe")
```

Plot chunk `(unnamed chunk)` — simulated object(s): `dat`

``` r
# ---- Source: DAPlan.Rmd | chunk: (unnamed chunk) ----
ggplot(dat, aes(Timepoint, NPX, col = factor(PPID))) +
  geom_point() +
  geom_line() +
  facet_wrap(~ PPID) +
  labs(x = "Timepoint, days", y = "NPX", col = "PPID") +
  guides(col = guide_legend(ncol = 6)) + theme(legend.position="bottom")
```

Plot chunk `(unnamed chunk)` — simulated object(s): `dat`

``` r
# ---- Source: DAPlan.Rmd | chunk: (unnamed chunk) ----
ggplot(dat, aes(PPID, NPX)) +
  geom_point(aes(col = Timepoint, shape = Timepoint)) +
  geom_point(data = group_by(dat, PPID) %>%
               summarise(NPX = mean(NPX), .groups = "drop"),
             aes(col = "Mean", shape = "Mean"), size = 2.5) +
  geom_hline(yintercept = mean(dat$NPX)) +
 # scale_shape_manual(values = c(4, 19, 19, 19, 19)) +
  labs(x = "PPID", y = "NPX", col = "Timepoint", shape = "Timepoint") +
  coord_flip()
```

Plot chunk `(unnamed chunk)` — simulated object(s):
`dat, dat1, p01, yintercept, y, x, title`

``` r
# ---- Source: DAPlan.Rmd | chunk: (unnamed chunk) ----
dat1 <- dat %>% dplyr::arrange(Assay, PPID, Timepoint)
dat1$Timepoint <- factor(dat1$Timepoint)
  
  

    
    p01 <-  ggplot(dat1, aes(Timepoint, NPX, col = factor(PPID))) +
      geom_point() +
      geom_line(aes(group = 1)) +
      geom_hline(
        yintercept = max(dat1$MaxLOD),
        linetype = "dashed",
        color = "red"
      ) +
      annotate(
        "text",
        x = 8,
        y = max(dat1$MaxLOD) * 1.15,
        label = "MaxLOD",
        color = "red"
      ) +
      facet_wrap(~ PPID) +
      labs(
        x = "Timepoint (day)",
        y = "NPX",
        col = "PPID",
        title = paste0(unique(dat1$Panel), "- Patient NPX trajectory over timepoints"),
        subtitle = "IL6"
      ) +
      guides(col = guide_legend(nrow = 7)) +
      theme_bw()
    
    print( p01 )
    cat("\n")
```

## Draft_report.Rmd

Plot chunk `, fig.height=10, fig.width=15, fig.align = "center"` —
simulated object(s): `PROBC, df`

``` r
# ---- Source: Draft_report.Rmd | chunk: , fig.height=10, fig.width=15, fig.align = "center" ----
olink_pca_plot(
    df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
    color_g = "Timepoint",
    byPanel = TRUE
  )
```

Plot chunk `(unnamed chunk)` — simulated object(s):
`PROBC, df, df1, PRO_B_c, p, components, title, subtitle, caption, df_pca_d, p_d`

``` r
# ---- Source: Draft_report.Rmd | chunk: (unnamed chunk) ----
cat("\n\n##### 2 Panels - Loadings of the first 5 PCs  - All Timepoints", "\n")

df <- PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation") %>% dplyr::select(PPID, Assay, NPX, Timepoint) %>%
    pivot_wider(names_from = Assay, values_from = NPX) 

 df1 <- PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response") %>% dplyr::select(PPID, Assay, NPX, Timepoint) %>% pivot_wider(names_from = Assay, values_from = NPX) 
 PRO_B_c <- full_join(df, df1, by = join_by(PPID, Timepoint))
PRO_B_c[,3:186] <- PRO_B_c[,3:186] %>%
   mutate_at(-1, as.numeric) %>% #-1 is to ignore Country column
   mutate_at(-1, ~ replace(., is.na(.), median(., na.rm = TRUE)))

   p <- pca(t(PRO_B_c[,c(-1, -2)]), removeVar = 0.1)
  print(screeplot(p, axisLabSize = 18, 
            titleLabSize = 22, 
            components = getComponents(p, 1:20), 
            title = "SCREE plot",  
            subtitle = paste0("2 Panels ",  "- All timepoints"),
            caption = "Plot shows the cumulative proportion explained by the PCs"
  ))
 
  cat("\n")
  
  print(plotloadings(p, 
                 labSize = 5, 
                 title = "Loadings plot",  
                 subtitle =  paste0("2 Panels- All Timepoints"),
                 caption = "Plot shows the loadings of the first 5 PCs"))
  
 
 cat("\n")
  
  for (k in c(1,8,15,22,29,36,43,57,85)) {
  cat("\n\n##### 2 Panels - Loadings of the first 5 PCs  - Timepoint - : ", k , "(day)", "\n")
  df_pca_d <- PRO_B_c %>% dplyr::select(-PPID) %>% dplyr::filter(Timepoint %in% k)
  p_d <- pca(t(df_pca_d[,-1]), removeVar = 0.1)
  print(screeplot(p_d, axisLabSize = 18, 
            titleLabSize = 22, 
            components = getComponents(p, 1:15), 
            title = "SCREE plot",  
            subtitle = paste0("2 Panels - Timepoint -", k),
            caption = "Plot shows the cumulative proportion explained by the PCs"
  ))
  
  
  
  print(plotloadings(p_d, 
                 labSize = 5, 
                 title = "Loadings plot",  
                 subtitle =  paste0("2 Panels- Timepoint -", k),
                 caption = "Plot shows the loadings of the first 5 PCs"))
    
  
  
  cat("\n")   
  }
```

Plot chunk
`, fig.cap= "PCA by groups of treatment", fig.topcaption=FALSE, fig.width=10, fig.height=6, fig.align = "center"`
— simulated object(s): `PROBC, df, p, color_g`

``` r
# ---- Source: Draft_report.Rmd | chunk: , fig.cap= "PCA by groups of treatment", fig.topcaption=FALSE, fig.width=10, fig.height=6, fig.align = "center" ----
olink_pca_plot(
   df = PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response"),
   color_g = "TreatGroup",
    byPanel = TRUE)




# olink_umap_plot(
#    df = PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response" & Timepoint == 1 ),
#    color_g = "Group",
#     byPanel = TRUE)
```

Plot chunk `, fig.width=10, fig.height=6, fig.align = "center"` —
simulated object(s): `PROBC, df, p, color_g`

``` r
# ---- Source: Draft_report.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center" ----
olink_pca_plot(
   df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
   color_g = "TreatGroup",
    byPanel = TRUE)


# olink_umap_plot(
#    df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
#    color_g = "Group",
#     byPanel = TRUE)
```

Plot chunk `, fig.width=10, fig.height=6, fig.align = "center"` —
simulated object(s): `PROBC, df, p, title, color_g, plt_lst`

``` r
# ---- Source: Draft_report.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center" ----
for(i in (unique(PROBC$Timepoint))){

  cat("\n\n##### Two Panels  - Timepoint - : ", i , "(day)", "\n")  
  
plt_lst <- olink_pca_plot(
   df = PROBC %>% dplyr::filter(Timepoint == i),
   color_g = "TreatGroup",
    byPanel = FALSE)
plt_lst[[1]] <- plt_lst[[1]] + labs(title = paste0("Timepoint (days): ", unique(PROBC$Timepoint)[i]))
plt_lst[[1]]

}

# for(j in seq_along(plt_lst)) {
#   plt_lst[[j]] <- plt_lst[[j]] + labs(title = paste0("Timepoint (days): ", unique(PROBC$Timepoint)[j]))
#   print(plt_lst[[j]])
# }
```

Plot chunk `, fig.width=8, fig.height=10, fig.align = "center"` —
simulated object(s): `df, p, df_var, df_var1, fun_plot, p2`

``` r
# ---- Source: Draft_report.Rmd | chunk: , fig.width=8, fig.height=10, fig.align = "center" ----
p2 <- fun_plot(df_var1)
```

Plot chunk `, fig.width=14, fig.height=8, fig.align = "center"` —
simulated object(s): `PROBC, df, p, title, subtitle`

``` r
# ---- Source: Draft_report.Rmd | chunk: , fig.width=14, fig.height=8, fig.align = "center" ----
for(i in  unique(PROBC$Timepoint))
{
  
cat("\n\n##### Timepoint: ", i, "\n")  
  
  try({ #This statement might fail if dependencies are not installed

  df <- PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response" & Timepoint == i) %>% dplyr::arrange(TreatGroup)
print(  olink_heatmap_plot(df, variable_row_list =  c('TreatGroup'), cluster_rows = FALSE) + labs(title = "Immune Response", subtitle = paste0("Timepoint - ", i)))
  })
  
}
```

Plot chunk `, fig.width=14, fig.height=8, fig.align = "center"` —
simulated object(s): `PROBC, df, p, title, subtitle`

``` r
# ---- Source: Draft_report.Rmd | chunk: , fig.width=14, fig.height=8, fig.align = "center" ----
for(i in  unique(PROBC$Timepoint))
{
  cat("\n\n##### Timepoint: ", i, "\n")  
  
  try({ #This statement might fail if dependencies are not installed

  df <- PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation" & Timepoint == i) %>% dplyr::arrange(TreatGroup)
  print(olink_heatmap_plot(df, variable_row_list =  c('TreatGroup'), cluster_rows = FALSE) + labs(title = "Olink Inflammation", subtitle = paste0("Timepoint - ", i)))
  })
  
}
```

Plot chunk `(unnamed chunk)` — simulated object(s):
`PROBC, p, P, y, proc1, pd`

``` r
# ---- Source: Draft_report.Rmd | chunk: (unnamed chunk) ----

# proc1 <- PROBC %>% dplyr::filter(Assay %in% sort(c("IL4", "CASP-8", "CXCL12", "CXCL11", "IL-17C", "MCP-3", "ARTN", "IL33", "MCP-3", "LAP TGF-beta-1", "FGF2", "FXYD5", "LAG3", "CLEC4A", "PADI2", "uPA")))


load("DF_model.RData", verbose = FALSE)


proc1 <- PROBC %>% dplyr::filter(Assay %in% sort(unique(DF_model$Assay)))


for(i in unique(proc1$Assay1)){
  
cat("\n\n### ", i,  "\n")  
pd <- position_dodge(.2)
 p <-   ggplot(proc1 %>% dplyr::filter(Assay1 %in% i), aes(Timepoint, NPX, color=TreatGroup)) + 
  stat_summary(fun.data=mean_se, geom="pointrange", position=pd) + 
  labs(y="NPX", x="Timepoint (day)") + 
  olink_color_discrete() + 
  OlinkAnalyze::set_plot_theme(font = "") + facet_wrap(~Assay1)

print(p)
  
}
```

Plot chunk `(unnamed chunk)` — simulated object(s):
`PROBC, df, p, title, subtitle, form, p1, P, y, lmer_results_twoway, variable, random, lmer_results_twoway_significant, lmer_posthoc_twoway_results, olinkid_list, effect, x_axis_variable, col_variable`

``` r
# ---- Source: Draft_report.Rmd | chunk: (unnamed chunk) ----
 # Linear mixed model with two variables.
  lmer_results_twoway <- olink_lmer(df = PROBC, 
                                    variable = c('Timepoint', 'TreatGroup'),
                                    random = 'PPID')
  
  # extracting the significant proteins
  lmer_results_twoway_significant <- lmer_results_twoway %>%
    # dplyr::filter(Threshold== 'Significant') %>%
    dplyr::filter(p.value < 0.05) %>%
    dplyr::arrange(p.value) %>%
    dplyr::pull(OlinkID)
  # performing post-hoc analysis
  lmer_posthoc_twoway_results <- olink_lmer_posthoc(df = PROBC,
                                                    olinkid_list = unique(lmer_results_twoway_significant),
                                                    variable = c('Timepoint', 'TreatGroup'),
                                                    random = 'PPID',
                                                    effect = 'TreatGroup') 


lmer_posthoc_twoway_results %>% 
 round_df(digits=3) %>%  
  dplyr::filter(Threshold== 'Significant') %>%
  df_display() 


# if (requireNamespace("lme4", quietly = TRUE) & requireNamespace("lmerTest", quietly = TRUE)){
#   plot <- olink_lmer_plot(df = PROBC, 
#                           olinkid_list = unique(lmer_results_twoway_significant), 
#                            variable = c('Timepoint', 'TreatGroup', 'AGE', 'SEX'),
#                           x_axis_variable =  'Timepoint',
#                           col_variable = 'TreatGroup',
#                           number_of_proteins_per_plot = 1, 
#                           random = 'PPID') 
#  
#  walk(plot, print)
#  
# }


if (requireNamespace("lme4", quietly = TRUE) & requireNamespace("lmerTest", quietly = TRUE)){
unique(lmer_results_twoway_significant) %>%
walk(function(x) {
cat("\n\n####", PROBC %>% dplyr::filter(OlinkID %in% x) %>% dplyr::pull(Assay1) %>% unique(), "\n")
        p <- olink_lmer_plot(df = PROBC, 
                          olinkid_list = x , 
                           variable = c('Timepoint', 'TreatGroup', 'SEX'),
                          x_axis_variable =  'Timepoint',
                          col_variable = 'TreatGroup',
                          number_of_proteins_per_plot = 1, 
                          random = 'PPID') 
        walk(p, print)
    })

}



for(i in unique(lmer_posthoc_twoway_results$contrast)){
  lmer_posthoc_twoway_results$p.value <- lmer_posthoc_twoway_results$Adjusted_pval
p <- olink_volcano_plot(p.val_tbl = lmer_posthoc_twoway_results %>% dplyr::filter(contrast %in% i), x_lab = 'estimate')
p1 <- p + labs(title ="Modified Volcano plot shows the Adjusted-p-values vs Estimate of Treatment effects from the covariate-adjusted
               linear mixed model posthoc per protein" , subtitle = paste0("Contrast : ", i))

print(p1)
}
```

Plot chunk `(unnamed chunk)` — simulated object(s):
`PROBC, df, p, title, subtitle, form, p1, P, y, lmer_results_twoway, variable, random, lmer_results_twoway_significant, lmer_posthoc_twoway_results, olinkid_list, effect, x_axis_variable, col_variable, lmer_results_twoway_1, lmer_results_twoway_significant_1, lmer_posthoc_twoway_results_1`

``` r
# ---- Source: Draft_report.Rmd | chunk: (unnamed chunk) ----
 # Linear mixed model with two variables.
  lmer_results_twoway_1 <- olink_lmer(df = PROBC, 
                                    variable = c('Timepoint', 'TreatGroup', 'AGE'),
                                    random = 'PPID')
  
  # extracting the significant proteins
  lmer_results_twoway_significant_1 <- lmer_results_twoway_1 %>%
    # dplyr::filter(Threshold== 'Significant') %>%
    dplyr::filter(p.value < 0.05) %>%
    dplyr::arrange(p.value) %>%
    dplyr::pull(OlinkID)
  # performing post-hoc analysis
  lmer_posthoc_twoway_results_1 <- olink_lmer_posthoc(df = PROBC,
                                                    olinkid_list = unique(lmer_results_twoway_significant_1),
                                                    variable = c('Timepoint', 'TreatGroup', 'AGE'),
                                                    random = 'PPID',
                                                    effect = 'TreatGroup') 


lmer_posthoc_twoway_results_1 %>% 
 round_df(digits=3) %>%  
  dplyr::filter(Threshold== 'Significant') %>%
  df_display() 


# if (requireNamespace("lme4", quietly = TRUE) & requireNamespace("lmerTest", quietly = TRUE)){
#   plot <- olink_lmer_plot(df = PROBC, 
#                           olinkid_list = unique(lmer_results_twoway_significant_1), 
#                            variable = c('Timepoint', 'TreatGroup', 'AGE'),
#                           x_axis_variable =  'Timepoint',
#                           col_variable = 'TreatGroup',
#                           number_of_proteins_per_plot = 1, 
#                           random = 'PPID') 
#  
#  walk(plot, print)
#  
# }



if (requireNamespace("lme4", quietly = TRUE) & requireNamespace("lmerTest", quietly = TRUE)){
unique(lmer_results_twoway_significant_1) %>%
walk(function(x) {
cat("\n\n####", PROBC %>% dplyr::filter(OlinkID %in% x) %>% dplyr::pull(Assay1) %>% unique(), "\n")
        p <- olink_lmer_plot(df = PROBC, 
                          olinkid_list = x , 
                           variable = c('Timepoint', 'TreatGroup', 'SEX'),
                          x_axis_variable =  'Timepoint',
                          col_variable = 'TreatGroup',
                          number_of_proteins_per_plot = 1, 
                          random = 'PPID') 
        walk(p, print)
    })

}






for(i in unique(lmer_posthoc_twoway_results_1$contrast)){
  lmer_posthoc_twoway_results_1$p.value <- lmer_posthoc_twoway_results_1$Adjusted_pval
p <- olink_volcano_plot(p.val_tbl = lmer_posthoc_twoway_results_1 %>% dplyr::filter(contrast %in% i), x_lab = 'estimate')
p1 <- p + labs(title ="Modified Volcano plot shows the Adjusted-p-values vs Estimate of Treatment effects from the covariate-adjusted
               linear mixed model posthoc per protein" , subtitle = paste0("Contrast : ", i))

print(p1)
}
```

Plot chunk `(unnamed chunk)` — simulated object(s):
`PROBC, df, p, title, subtitle, form, p1, P, y, lmer_results_twoway, variable, random, lmer_results_twoway_significant, lmer_posthoc_twoway_results, olinkid_list, effect, x_axis_variable, col_variable, lmer_results_twoway_2, lmer_results_twoway_significant_2, lmer_posthoc_twoway_results_2`

``` r
# ---- Source: Draft_report.Rmd | chunk: (unnamed chunk) ----
 # Linear mixed model with two variables.
  lmer_results_twoway_2 <- olink_lmer(df = PROBC, 
                                    variable = c('Timepoint', 'TreatGroup', 'SEX'),
                                    random = 'PPID')
  
  # extracting the significant proteins
  lmer_results_twoway_significant_2 <- lmer_results_twoway_2 %>%
    # dplyr::filter(Threshold== 'Significant') %>%
    dplyr::filter(p.value < 0.05) %>%
    dplyr::arrange(p.value) %>%
    dplyr::pull(OlinkID)
  # performing post-hoc analysis
  lmer_posthoc_twoway_results_2 <- olink_lmer_posthoc(df = PROBC,
                                                    olinkid_list = unique(lmer_results_twoway_significant_2),
                                                    variable = c('Timepoint', 'TreatGroup', 'SEX'),
                                                    random = 'PPID',
                                                    effect = 'TreatGroup') 


lmer_posthoc_twoway_results_2 %>% 
 round_df(digits=3) %>%  
  dplyr::filter(Threshold== 'Significant') %>%
  df_display() 


# if (requireNamespace("lme4", quietly = TRUE) & requireNamespace("lmerTest", quietly = TRUE)){
#   plot <- olink_lmer_plot(df = PROBC, 
#                           olinkid_list = unique(lmer_results_twoway_significant_2), 
#                            variable = c('Timepoint', 'TreatGroup', 'SEX'),
#                           x_axis_variable =  'Timepoint',
#                           col_variable = 'TreatGroup',
#                           number_of_proteins_per_plot = 1, 
#                           random = 'PPID') 
#  
#  walk(plot, print)
 
#}


if (requireNamespace("lme4", quietly = TRUE) & requireNamespace("lmerTest", quietly = TRUE)){
unique(lmer_results_twoway_significant_2) %>%
walk(function(x) {
cat("\n\n####", PROBC %>% dplyr::filter(OlinkID %in% x) %>% dplyr::pull(Assay1) %>% unique(), "\n")
        p <- olink_lmer_plot(df = PROBC, 
                          olinkid_list = x , 
                           variable = c('Timepoint', 'TreatGroup', 'SEX'),
                          x_axis_variable =  'Timepoint',
                          col_variable = 'TreatGroup',
                          number_of_proteins_per_plot = 1, 
                          random = 'PPID') 
        walk(p, print)
    })

}









for(i in unique(lmer_posthoc_twoway_results_2$contrast)){
  lmer_posthoc_twoway_results_2$p.value <- lmer_posthoc_twoway_results_2$Adjusted_pval
p <- olink_volcano_plot(p.val_tbl = lmer_posthoc_twoway_results_2 %>% dplyr::filter(contrast %in% i), x_lab = 'estimate')
p1 <- p + labs(title ="Modified Volcano plot shows the Adjusted-p-values vs Estimate of Treatment effects from the covariate-adjusted
               linear mixed model posthoc per protein" , subtitle = paste0("Contrast : ", i))

print(p1)
}
```

Plot chunk `, fig.width=10, fig.height=8, fig.align = "center"` —
simulated object(s):
`p, form, y, lmer_results_twoway, lmer_results_twoway_1, lmer_results_twoway_2, list, list1, list2, list_0, list1_0, list2_0, results_list_0, results_list, proteins_mapped, proteins_mapped_0, int_net, graph_1, graph_2, enriched`

``` r
# ---- Source: Draft_report.Rmd | chunk: , fig.width=10, fig.height=8, fig.align = "center" ----
pacman::p_load(rbioapi)

list <-  lmer_results_twoway %>% dplyr::filter(p.value < 0.05) %>% dplyr::pull(Assay)
list1 <-  lmer_results_twoway_1 %>% dplyr::filter(p.value < 0.05) %>% dplyr::pull(Assay)
list2 <-  lmer_results_twoway_2 %>% dplyr::filter(p.value < 0.05) %>% dplyr::pull(Assay)




list_0 <-  lmer_results_twoway %>% dplyr::filter(Threshold %in% "Significant" ) %>% dplyr::pull(Assay)
list1_0 <-  lmer_results_twoway_1 %>% dplyr::filter(Threshold %in% "Significant") %>% dplyr::pull(Assay)
list2_0 <-  lmer_results_twoway_2 %>% dplyr::filter(Threshold %in% "Significant") %>% dplyr::pull(Assay)


results_list_0 <-  unique(c(list_0, list1_0, list2_0))
results_list <-  unique(c(list, list1, list2))

proteins_mapped <- rba_string_map_ids(ids = results_list,
                                      species = 9606)

proteins_mapped_0 <- rba_string_map_ids(ids = results_list_0,
                                      species = 9606)

## 2 Now we map our protein IDs

int_net <- rba_string_interactions_network(ids = results_list,
                                          species = 9606,
                                        
                                          required_score = 500)





graph_1 <- rba_string_network_image(ids = proteins_mapped_0$stringId ,
                                   image_format = "image",
                                   species = 9606,
                                   save_image = TRUE,
                                   required_score = 500,
                                    add_white_nodes = 5,
                                   network_flavor = "confidence")


graph_2 <- rba_string_network_image(ids = proteins_mapped$stringId ,
                                   image_format = "image",
                                   species = 9606,
                                   save_image = TRUE,
                                   required_score = 500,
                                    add_white_nodes = 5,
                                   network_flavor = "confidence")



# graph_2 <- rba_string_network_image(ids = proteins_mapped$stringId,
#                                     image_format = "image",
#                                     species = 9606,
#                                     save_image = TRUE,
#                                     required_score = 500,
#                                     add_color_nodes = 5,
#                                     add_white_nodes = 5,
#                                    network_flavor = "actions")


enriched <- rba_string_enrichment(ids = proteins_mapped$stringId,
                                  species = 9606)






cat("\n\n#### Network of proteins of interest (significants from Linear Mixed models)")  


knitr::include_graphics(here::here("rbioapi",list.files(here::here("rbioapi"))[length(list.files(here::here("rbioapi")))-1]))

cat("\n\n#### Network of proteins of interest with neigbothood extention")  


knitr::include_graphics(here::here("rbioapi",list.files(here::here("rbioapi"))
                                   [length(list.files(here::here("rbioapi")))]))
```

## NUMAB_Appendice_model.Rmd

Plot chunk `(unnamed chunk)` — simulated object(s):
`PROBC, dat, PROBC1, p, yintercept, y, Sum, data, pd, P, color, ymax, width, fm, step_fm, final_fm, df0, term, df_mod, DF_model, mp`

``` r
# ---- Source: NUMAB_Appendice_model.Rmd | chunk: (unnamed chunk) ----

 
`%!in%` <- Negate(`%in%`) 
PROBC1 <- PROBC %>% dplyr::filter(Assay %!in% c("EIF5A","FXYD5","IL-20", "IL2"))

DF_model <- numeric()
for(j in unique(PROBC1$Panel)){
for (i in sort(unique((PROBC1 %>% dplyr::filter(Panel %in% j) %>% dplyr::pull(Assay))))) {
  cat("\n\n### ", "Panel: ", j, " - Assay: ", i, "\n")
    dat <- PROBC1 %>% dplyr::arrange(PPID, Time)  %>% dplyr::filter((Panel %in% j) &
                                                                         (Assay %in% i))
    dat$Timepoint <- as.factor(dat$Timepoint)
    dat$SEX <- as.factor(dat$SEX)
    dat$TreatGroup <- as.factor(dat$ TreatGroup)
    dat$Timepoint <- as.factor(dat$Timepoint)

  
   p <- ggplot(dat, aes(Timepoint, NPX, group = factor(PPID), col = factor(PPID))) +
  geom_point() +
  geom_line(aes(group = 1)) +
      geom_hline(
        yintercept = max(dat$MaxLOD),
        linetype = "dashed",
        color = "red"
      ) +
      annotate(
        "text",
        x = 8,
        y = max(dat$MaxLOD) * 1.15,
        label = "MaxLOD",
        color = "red"
      ) +
  labs(title = j, subtitle = i, x = "Timepoint, days", y = "NPX", col = "PPID") +
  facet_wrap(~ PPID)+
  theme_light() +
  guides(col = guide_legend(ncol = 8)) + theme(legend.position="bottom") 


print(p) 
    
    
      Sum = groupwiseMean(NPX ~ TreatGroup + Timepoint ,
                    data   = dat,
                    conf   = 0.95,
                    digits = 3,
                    traditional = FALSE,
                    percentile  = TRUE)

pd = position_dodge(.2)

P<- ggplot(Sum, aes(x =    Timepoint,
                y =    Mean,
                color = TreatGroup)) +
    geom_errorbar(aes(ymin=Percentile.lower,
                      ymax=Percentile.upper),
                   width=.2, size=0.7, position=pd) +
  
    geom_point(shape=15, size=4, position=pd) +
    theme_bw() +
    theme(axis.title = element_text(face = "bold")) +
    ylab("NPX") + 
    guides(fill=guide_legend(title="Cohort")) +
    olink_color_discrete() + 
    OlinkAnalyze::set_plot_theme(font = "") 


  
print(P)



# p01 <-    ggplot(dat, aes(Timepoint, NPX, col = factor(SUBJID))) +
#       geom_point() +
#       geom_line(aes(group = 1)) +
#       geom_hline(
#         yintercept = max(dat$MaxLOD),
#         linetype = "dashed",
#         color = "red"
#       ) +
#       annotate(
#         "text",
#         x = 8,
#         y = max(dat$MaxLOD) * 1.15,
#         label = "MaxLOD",
#         color = "red"
#       ) +
#       facet_wrap(~ SUBJID) +
#       labs(
#         x = "Timepoint (day)",
#         y = "NPX",
#         col = "PPID",
#         title = paste0(unique(dat$Panel), "- Patient NPX trajectory over timepoints"),
#         subtitle = i
#       ) +
#       guides(col = guide_legend(nrow = 7)) +
#       theme_bw()
#      print( p01 )

    
    
fm <- lmer(NPX ~ AGE*TreatGroup*SEX*Timepoint +
             + (1|SUBJID)  + (1|Timepoint),  data= dat)
step_fm <- step(fm)
step_fm # Display elimination results
final_fm <- get_model(step_fm)

df0 <- coef(summary(final_fm)) %>% data.frame()
term <- rownames(df0)
rownames(df0) <- NULL
if((length(names(df0))) >4){
names(df0) <- c("Estimate", "Std.Error", "sd", "t.value", "p_value")}




Panel = j
Assay = i
df_mod <- cbind(Panel, Assay, term, df0)
DF_model <- rbind(DF_model, df_mod)

print(performance::check_model(final_fm))
#print(final_fm)
# tab_model(final_fm, show.se = TRUE, show.std = TRUE, show.stat = TRUE, file="test.html")
# htmltools::includeHTML("test.html")
# 
#final_fm %>%
# tab_model(final_fm, show.se = TRUE, show.std = TRUE, show.stat = TRUE) %>% 
#     return() %$% 
#     knitr() %>% 
#     asis_output()

# m_table <- tab_model(final_fm, show.se = TRUE, show.std = TRUE, show.stat = TRUE)
# sjtable2df::mtab2df(
#   mtab = m_table,
#   n_models = 1,
#   output = "kable"
# )

library(parameters)
mp <- model_parameters(final_fm)
print(print_html(mp))
#print(print_md(mp))
}
}
```

## NUMAB_Appendice.Rmd

Plot chunk `, fig.height=10, fig.width=15, fig.align = "center"` —
simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMAB_Appendice.Rmd | chunk: , fig.height=10, fig.width=15, fig.align = "center" ----
olink_umap_plot(
    df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
    color_g = "Timepoint",
    byPanel = TRUE
  )
```

Plot chunk
`, fig.cap= "PCA by groups of treatment", fig.topcaption=FALSE, fig.width=10, fig.height=6, fig.align = "center"`
— simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMAB_Appendice.Rmd | chunk: , fig.cap= "PCA by groups of treatment", fig.topcaption=FALSE, fig.width=10, fig.height=6, fig.align = "center" ----
olink_umap_plot(
   df = PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response"),
   color_g = "TreatGroup",
    byPanel = TRUE)




# olink_umap_plot(
#    df = PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response" & Timepoint == 1 ),
#    color_g = "Group",
#     byPanel = TRUE)
```

Plot chunk `, fig.width=10, fig.height=6, fig.align = "center"` —
simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMAB_Appendice.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center" ----
olink_umap_plot(
   df = PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response"  & Timepoint == 1),
   color_g = "TreatGroup",
    byPanel = TRUE)
```

Plot chunk `, fig.width=10, fig.height=6, fig.align = "center"` —
simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMAB_Appendice.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center" ----
olink_umap_plot(
   df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
   color_g = "TreatGroup",
    byPanel = TRUE)


# olink_umap_plot(
#    df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
#    color_g = "Group",
#     byPanel = TRUE)
```

Plot chunk
`, fig.width=10, fig.height=6, fig.cap = "NPX trajectories over timepoints", fig.align = "center"`
— simulated object(s):
`PROBC, list_of_interest, list_of_interest_1, j, i, dat, p`

``` r
# ---- Source: NUMAB_Appendice.Rmd | chunk: , fig.width=10, fig.height=6, fig.cap = "NPX trajectories over timepoints", fig.align = "center" ----


list_of_interest_1 <- list_of_interest %>%  distinct(Panel, Assay) 
for (k in (1:dim(list_of_interest_1)[1])){
  
j = list_of_interest_1$Panel[k]
i = list_of_interest_1$Assay[k]
cat("\n\n### Panel: ", j,  "- Assay: ", i, " - Patient NPX trajectories over timepoints",  "\n")  

  
dat <- PROBC %>% dplyr::filter((Assay %in% i) & (Panel %in% j))
dat$PPID <- factor(dat$PPID)
dat$TreatGroup <- factor(dat$TreatGroup)
dat$Timepoint <- factor(dat$Timepoint)
p <- ggplot(dat, aes(Timepoint, NPX, group = factor(PPID), col = factor(PPID))) +
  geom_point() +
  geom_line() +
  labs(title = j, subtitle = i, x = "Timepoint, days", y = "NPX", col = "PPID") +
  facet_wrap(~ PPID)+
  theme_light() +
  guides(col = guide_legend(ncol = 8)) + theme(legend.position="bottom") 


print(p)
}





# https://bookdown.org/tpinto_home/Unsupervised-learning/k-means-clustering.html

# https://stats.stackexchange.com/questions/13442/how-to-find-groupings-trajectories-among-longitudinal-data
```

Plot chunk `, fig.width=10, fig.height=6, fig.align = "center"` —
simulated object(s):
`PROBC, list_of_interest, list_of_interest_1, j, i, dat, p, p04, x, title, subtitle`

``` r
# ---- Source: NUMAB_Appendice.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center" ----

list_of_interest_1 <- list_of_interest %>%  distinct(Panel, Assay) 
for (k in (1:dim(list_of_interest_1)[1])){
  
j = list_of_interest_1$Panel[k]
i = list_of_interest_1$Assay[k]
cat("\n\n### Panel: ", j,  "- Assay: ", i, " - Group-based NPX trajectories over timepoints",  "\n")  

  
dat <- PROBC %>% dplyr::filter((Assay %in% i) & (Panel %in% j))
dat$PPID <- factor(dat$PPID)
dat$TreatGroup <- factor(dat$TreatGroup)
dat$Timepoint <- factor(dat$Timepoint)

theme_set(theme_bw(base_size = 7, base_family = ""))

p04 <-    ggplot(dat, aes(Timepoint, NPX)) +
      geom_line(aes(group = PPID, color = PPID)) +
      geom_point(aes(color = PPID, shape = PPID)) +
      geom_smooth(method = "loess")  +
      scale_x_discrete(drop = F, breaks = unique(dat$Time)) +
      labs(
        x = "Timepoint (day)",
        y = "NPX",
        title = unique(dat$Panel),
        subtitle = paste0(i, "- Distribution of NPX over timepoints. 
                          \n Blue curve and the grey shade showing the trend line of all trajectoriesand and its Confidence Interval")
      ) + facet_wrap(~ TreatGroup) +
       theme_bw()   + guides(col = guide_legend(nrow = 13)) 


print(p04)

}
```

Plot chunk `, fig.width=10, fig.height=6, fig.align = "center"` —
simulated object(s):
`PROBC, list_of_interest, list_of_interest_1, j, i, dat, p, x, title, Sum, data, pd, P, color, ymax, width`

``` r
# ---- Source: NUMAB_Appendice.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center" ----

list_of_interest_1 <- list_of_interest %>%  distinct(Panel, Assay) 
for (k in (1:dim(list_of_interest_1)[1])){
  
j = list_of_interest_1$Panel[k]
i = list_of_interest_1$Assay[k]
cat("\n\n### Panel: ", j,  "- Assay: ", i, " - Mean ± margin of error of NPX over timepoints for 3 treatment groups",  "\n")  

  
dat <- PROBC %>% dplyr::filter((Assay %in% i) & (Panel %in% j))
dat$PPID <- factor(dat$PPID)
dat$TreatGroup <- factor(dat$TreatGroup)
dat$Timepoint <- factor(dat$Timepoint)
Sum = groupwiseMean(NPX ~ TreatGroup + Timepoint,
                    data   = dat,
                    conf   = 0.95,
                    digits = 3,
                    traditional = FALSE,
                    percentile  = TRUE)

pd = position_dodge(.2)

P<- ggplot(Sum, aes(x =    Timepoint,
                y =    Mean,
                color = TreatGroup)) +
    geom_errorbar(aes(ymin=Percentile.lower,
                      ymax=Percentile.upper),
                   width=.2, size=0.7, position=pd) +
    geom_point(shape=15, size=4, position=pd) +
    theme_bw() +
    theme(axis.title = element_text(face = "bold")) +
    ylab("NPX") + 
  guides(fill=guide_legend(title="Cohort")) +
    scale_color_manual(values = c("#00AFBB", "deeppink2","grey")) 
#+  stat_compare_means(aes(group = TreatGroup), label = "p.signif", size =3, method = "anova")
  
print(P)

}
```

Plot chunk `, eval = FALSE` — simulated object(s):
`PROBC, df, j, i, dat, p, x, title, data, P, m1, na.action, m2, m3, m4, m5, fm, step_fm, final_fm, max_mod, m0.glm, model0, model1, model2, model3, model4, custom.head`

``` r
# ---- Source: NUMAB_Appendice.Rmd | chunk: , eval = FALSE ----

dat <- PROBC %>% dplyr::filter(Assay %in% "IL4")
m1 <-nlme::lme(NPX ~ 1 + Timepoint, random = ~ 1 |SUBJID,
data = dat, method = "ML",
na.action = na.omit)

m2 <-nlme::lme(NPX ~ 1 + Timepoint*TreatGroup, random = ~ 1 |SUBJID,
data = dat, method = "ML",
na.action = na.omit)

m3 <-nlme::lme(NPX ~ 1 + Timepoint*TreatGroup*SEX, random = ~ 1 |SUBJID,
data = dat, method = "ML",
na.action = na.omit)

m4 <-nlme::lme(NPX ~ 1 + AGE + Timepoint*TreatGroup*SEX, random = ~ 1 |SUBJID,
data = dat, method = "ML",
na.action = na.omit)

m5 <-nlme::lme(NPX ~ 1 + SEX + Timepoint*TreatGroup*AGE, random = ~ 1 |SUBJID,
data = dat, method = "ML",
na.action = na.omit)
anova(m3, m4, m5)

library(lmerTest)
fm <- lmer(NPX ~ AGE*TreatGroup*SEX*Timepoint +
             + (1|SUBJID)  + (1|Timepoint),  data= dat)
step_fm <- step(fm)
step_fm # Display elimination results
final_fm <- get_model(step_fm)


tab_model(final_fm, show.se = TRUE, show.std = TRUE, show.stat = TRUE)



library(sjPlot)
plot_model(final_fm, show.values = TRUE)

plot_model(final_fm, type = "pred", terms = c("Timepoint", "TreatGroup"))



library(buildmer)
max_mod <- buildmer(NPX ~ AGE + SEX*TreatGroup*Timepoint + (1 + Timepoint|SUBJID) + (1 + TreatGroup*Timepoint|SUBJID), data=dat, buildmerControl = buildmerControl(include = ~ TreatGroup*Timepoint, calc.anova = TRUE, ddf = "Satterthwaite"))





library(lme4)
library(lmerTest)
library(texreg)
library(stargazer)
library(lattice)
# generate models
m0.glm <- glm(NPX ~ 1, family = gaussian, data = dat)
model0 = lmer(NPX ~ 1 + (1|SUBJID), REML = FALSE, data = dat)
AIC(logLik(m0.glm)) - AIC(logLik(m0.lmer))

model1 = lmer(NPX ~ 1 + Timepoint*TreatGroup + (1|SUBJID), REML = FALSE, data = dat)
model2 = lmer(NPX ~ 1 + AGE + Timepoint*TreatGroup + (1|SUBJID), REML = FALSE, data = dat)
model3 = lmer(NPX ~ 1 + AGE + Timepoint*TreatGroup*SEX + (1|SUBJID), REML = FALSE, data = dat)
model4 = lmer(NPX ~ 1 + AGE*Timepoint*TreatGroup*SEX + (1|SUBJID), REML = FALSE, data = dat)

# https://cja.education.illinois.edu/docs/librariesprovider37/edpsy587/lectures/3-randintercept/r_hsb_rand_intercept.html?sfvrsn=29f0c1c7_3&download=true/R_hsb_rand_intercept.html

screenreg(list(m0.glm, model0,model1,model2,model3, model4),
     single.row=TRUE,
     custom.model.names=c("No-random", "random", "Level 1", "Level 2","Level 3", "Level 4"),
     custom.head=list("Simple"=1:2, "Complex"=3:6)
          )





summary(max_mod)

dat %>% 
  lmer(NPX ~ AGE + SEX*Timepoint*TreatGroup + (1|PPID), 
       data = .) %>% 
  Anova(type = 3, test.statistic = "F") 
# %>% jtools::summ(confint = TRUE)
library(jtools)
summ(reg1, confint = TRUE)


library(interactions)
interact_plot(r, pred = Time, modx = Diet, plot.points = TRUE, main.title = "Chick weight over time, by diet")
```

Plot chunk `, tab.id="violon_each_cohort", fig.width=10, fig.height=7` —
simulated object(s):
`PROBC, df, j, i, p, x, title, subtitle, P, color, width, df_plot, p03, y, df_plot_wide, p3, col, p4, upper, lower`

``` r
# ---- Source: NUMAB_Appendice.Rmd | chunk: , tab.id="violon_each_cohort", fig.width=10, fig.height=7 ----
j = "Olink Inflammation"

for (i in sort(unique((PROBC %>% dplyr::filter(Panel %in% j) %>% dplyr::pull(Assay))))) {
  cat("\n\n### ", "Panel: ", j, " NPX accross timepoints - Assay: ", i, "\n")
    df_plot <- PROBC %>% dplyr::arrange(PPID, Time)  %>% dplyr::filter((Panel %in% j) &
                                                                         (Assay %in% i))
    df_plot$Time <- as.factor(df_plot$Time)
    df_plot$PPID <- as.factor(df_plot$PPID)
    

    p03 <-  ggplot(df_plot, aes(Time, NPX, colour = Time)) +
      geom_violin() +
      geom_boxplot(width = 0.1, outlier.colour = "black") +
      labs(
        x = "Timepoint (day)",
        y = "NPX",
        title = unique(df_plot$Panel),
        subtitle = paste0(i, "- Distribution of NPX over time")
      ) +
      theme_classic() 
    

   
    
    
    df_plot_wide <- df_plot %>% dplyr::select(PPID, Timepoint, NPX) %>%
      pivot_wider(names_from = Timepoint, values_from = NPX) %>% dplyr::select(-PPID)
    
    names(df_plot_wide) <- c("d1", "d8", "d15", "d22", "d29", "d36", "d43", "d57", "d85")
    
    library(GGally)
    p3 <- ggcorr(df_plot_wide, label = TRUE, label_round = 2) + ggplot2::labs(title = paste0("Panel - ", j, " - ", i, " - Correlation of NPX accross timepoint, the correlation strength indicated \n by the colors"))
    
    corrplot(cor(df_plot_wide, use = "pairwise.complete.obs"),
             title = paste0("Panel - ", j, " - ", i, " - Correlation of NPX accross timepoints. 
                            \n The timepoints with similar NPX (highly correlated) were grouped in the same square"),
             mar = c(5, 4, 4, 2),
             tl.col = "black", 
             order = "hclust", 
             hclust.method = "average", 
             addCoef.col = 'black',
             addrect = 4, 
             col=colorRampPalette(c("blue", "white", "red"), interpolate ='spline')(200),
             tl.cex = 0.7)
    p4 <- ggpairs(
      as.matrix(df_plot_wide),
      title = paste0("Panel - ", j, " - ", i, " - Pairwise Correlation of NPX accross timepoints.
                     \n Scatterplots of each pair of numeric variable are drawn on the left part of the figure. 
                     \n Pearson correlation is displayed on the right. Variable distribution is available on the diagonal."),
      upper = list(continuous = my_fn),
      lower = list(continuous = "smooth")
    )
    
    
    
    print(p03)
    print(p3)
    print(p4)
    cat("\n")
  }
```

## NUMABRep01.Rmd

Plot chunk `(unnamed chunk)` — simulated object(s): `PROBC, dat`

``` r
# ---- Source: NUMABRep01.Rmd | chunk: (unnamed chunk) ----
dat <- PROBC %>% dplyr::filter((Assay %in% "IL4") & (Panel %in%  "Olink Inflammation"))
ggplot(dat, aes(Timepoint, NPX, group = factor(PPID), col = factor(PPID))) +
  geom_point() +
  geom_line() +
  labs(title = "Olink Inflammation", subtitle = "IL4", 
    x = "Timepoint, days", y = "NPX", col = "PPID") +
  facet_wrap(~ PPID)+
  theme_light() +
  guides(col = guide_legend(ncol = 8)) + theme(legend.position="bottom") 
```

Plot chunk `, fig.height=10, fig.width=15` — simulated object(s):
`PROBC, df`

``` r
# ---- Source: NUMABRep01.Rmd | chunk: , fig.height=10, fig.width=15 ----
olink_pca_plot(
    df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
    color_g = "Timepoint",
    byPanel = TRUE
  )
```

Plot chunk
`, fig.cap= "PCA by groups of treatment", fig.topcaption=FALSE` —
simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMABRep01.Rmd | chunk: , fig.cap= "PCA by groups of treatment", fig.topcaption=FALSE ----
olink_pca_plot(
   df = PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response"),
   color_g = "Group",
    byPanel = TRUE)




# olink_umap_plot(
#    df = PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response" & Timepoint == 1 ),
#    color_g = "Group",
#     byPanel = TRUE)
```

Plot chunk `(unnamed chunk)` — simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMABRep01.Rmd | chunk: (unnamed chunk) ----
olink_pca_plot(
   df = PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response"  & Timepoint == 1),
   color_g = "Group",
    byPanel = TRUE)
```

Plot chunk `(unnamed chunk)` — simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMABRep01.Rmd | chunk: (unnamed chunk) ----
olink_pca_plot(
   df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
   color_g = "Group",
    byPanel = TRUE)


# olink_umap_plot(
#    df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
#    color_g = "Group",
#     byPanel = TRUE)
```

Plot chunk
`, fig.width=10, fig.height=6, tab.id='singletraj', label='singletraj', fig.cap = "NPX trajectories over time for 2 group B1 and B2"`
— simulated object(s):
`PROBC, dat, list_of_interest, list_of_interest_1, j, i, p`

``` r
# ---- Source: NUMABRep01.Rmd | chunk: , fig.width=10, fig.height=6, tab.id='singletraj', label='singletraj', fig.cap = "NPX trajectories over time for 2 group B1 and B2" ----


list_of_interest_1 <- list_of_interest %>%  distinct(Panel, Assay) 
for (k in (1:dim(list_of_interest_1)[1])){
  
j = list_of_interest_1[k,1]
i = list_of_interest_1[k,2]
 
cat("\n\n### Panel: ", j,  "- Assay: ", i, " - Patient NPX trajectories over timepoints",  "\n")  
  
dat <- PROBC %>% dplyr::filter((Assay %in% i) & (Panel %in% j))

p <- ggplot(dat, aes(Timepoint, NPX, group = factor(PPID), col = factor(PPID))) +
  geom_point() +
  geom_line() +
  labs(title = j, subtitle = i, x = "Timepoint, days", y = "NPX", col = "PPID") +
  facet_wrap(~ PPID)+
  theme_light() +
  guides(col = guide_legend(ncol = 8)) + theme(legend.position="bottom") 


print(p)
}





# https://bookdown.org/tpinto_home/Unsupervised-learning/k-means-clustering.html

# https://stats.stackexchange.com/questions/13442/how-to-find-groupings-trajectories-among-longitudinal-data
```

## NUMABRep02.Rmd

Plot chunk `(unnamed chunk)` — simulated object(s): `PROBC, dat`

``` r
# ---- Source: NUMABRep02.Rmd | chunk: (unnamed chunk) ----
dat <- PROBC %>% dplyr::filter((Assay %in% "IL4") & (Panel %in%  "Olink Inflammation"))
ggplot(dat, aes(Timepoint, NPX, group = factor(PPID), col = factor(PPID))) +
  geom_point() +
  geom_line() +
  labs(title = "Olink Inflammation", subtitle = "IL4", 
    x = "Timepoint, days", y = "NPX", col = "PPID") +
  facet_wrap(~ PPID)+
  theme_light() +
  guides(col = guide_legend(ncol = 8)) + theme(legend.position="bottom") 
```

Plot chunk `, fig.height=10, fig.width=15, fig.align = "center"` —
simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMABRep02.Rmd | chunk: , fig.height=10, fig.width=15, fig.align = "center" ----
olink_pca_plot(
    df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
    color_g = "Timepoint",
    byPanel = TRUE
  )
```

Plot chunk
`, fig.cap= "PCA by groups of treatment", fig.topcaption=FALSE, fig.align = "center"`
— simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMABRep02.Rmd | chunk: , fig.cap= "PCA by groups of treatment", fig.topcaption=FALSE, fig.align = "center" ----
olink_pca_plot(
   df = PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response"),
   color_g = "Group",
    byPanel = TRUE)




# olink_umap_plot(
#    df = PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response" & Timepoint == 1 ),
#    color_g = "Group",
#     byPanel = TRUE)
```

Plot chunk `, fig.align = "center"` — simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMABRep02.Rmd | chunk: , fig.align = "center" ----
olink_pca_plot(
   df = PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response"  & Timepoint == 1),
   color_g = "Group",
    byPanel = TRUE)
```

Plot chunk `, fig.align = "center"` — simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMABRep02.Rmd | chunk: , fig.align = "center" ----
olink_pca_plot(
   df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
   color_g = "Group",
    byPanel = TRUE)


# olink_umap_plot(
#    df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
#    color_g = "Group",
#     byPanel = TRUE)
```

Plot chunk
`, fig.width=10, fig.height=6, fig.cap = "**IL4** - NPX trajectories over time for 2 group B1 and B2", fig.align = "center"`
— simulated object(s): `PROBC, dat`

``` r
# ---- Source: NUMABRep02.Rmd | chunk: , fig.width=10, fig.height=6,  fig.cap = "**IL4** - NPX trajectories over time for 2 group B1 and B2", fig.align = "center" ----
dat <- PROBC %>% dplyr::filter((Assay %in% "IL4") & (Panel %in%  "Olink Inflammation"))

ggplot(dat, aes(Timepoint, NPX, group = factor(PPID), col = factor(PPID))) +
  geom_point() +
  geom_line() +
  labs(x = "Timepoint, days", y = "NPX", col = "PPID") +
  facet_wrap(~ PPID)+
  theme_light() +
  guides(col = guide_legend(ncol = 8)) + theme(legend.position="bottom") 
# https://bookdown.org/tpinto_home/Unsupervised-learning/k-means-clustering.html

# https://stats.stackexchange.com/questions/13442/how-to-find-groupings-trajectories-among-longitudinal-data
```

Plot chunk
`, fig.width=10, fig.height=6, fig.cap = "**IL4** - Spaghetti plot of NPX over time for 2 groups: B1(left) and B2 (right)", fig.align = "center"`
— simulated object(s): `dat, Speg.2`

``` r
# ---- Source: NUMABRep02.Rmd | chunk: , fig.width=10, fig.height=6, fig.cap = "**IL4** - Spaghetti plot of NPX over time for 2 groups: B1(left) and B2 (right)", fig.align = "center" ----
theme_set(theme_bw(base_size = 7, base_family = ""))

Speg.2<-ggplot(data = dat, aes(x=Time,y=NPX, group=PPID, color=PPID))+
  facet_wrap(~Group)+
  geom_point()+
  geom_line()+
  #geom_smooth(method='lm', se=FALSE)+
  xlab("Time")+ylab("NPX")+
  theme_light() + guides(col = guide_legend(nrow = 13)) 
Speg.2 
```

Plot chunk `(unnamed chunk)` — simulated object(s):
`PROBC, df, lmer_results_twoway, lmer_results_twoway_significant, olinkid_list, plot`

``` r
# ---- Source: NUMABRep02.Rmd | chunk: (unnamed chunk) ----
if (requireNamespace("lme4", quietly = TRUE) & requireNamespace("lmerTest", quietly = TRUE)){
  plot <- olink_lmer_plot(df = PROBC, 
                          olinkid_list = unique(lmer_results_twoway_significant), 
                           variable = c('Timepoint', 'Group'),
                          x_axis_variable =  'Timepoint',
                          col_variable = 'Group',
                          random = 'PPID')
  plot[[1]]
}
```

Plot chunk
`, fig.width=10, fig.height=6, fig.cap = "NPX trajectories over time for 2 group B1 and B2", fig.align = "center"`
— simulated object(s):
`PROBC, dat, list_of_interest, plot, list_of_interest_1, j, i, p`

``` r
# ---- Source: NUMABRep02.Rmd | chunk: , fig.width=10, fig.height=6, fig.cap = "NPX trajectories over time for 2 group B1 and B2", fig.align = "center" ----


list_of_interest_1 <- list_of_interest %>%  distinct(Panel, Assay) 
for (k in (1:dim(list_of_interest_1)[1])){
  
j = list_of_interest_1$Panel[k]
i = list_of_interest_1$Assay[k]
cat("\n\n### Panel: ", j,  "- Assay: ", i, " - Patient NPX trajectories over timepoints",  "\n")  

  
dat <- PROBC %>% dplyr::filter((Assay %in% i) & (Panel %in% j))

p <- ggplot(dat, aes(Timepoint, NPX, group = factor(PPID), col = factor(PPID))) +
  geom_point() +
  geom_line() +
  labs(title = j, subtitle = i, x = "Timepoint, days", y = "NPX", col = "PPID") +
  facet_wrap(~ PPID)+
  theme_light() +
  guides(col = guide_legend(ncol = 8)) + theme(legend.position="bottom") 


print(p)
}





# https://bookdown.org/tpinto_home/Unsupervised-learning/k-means-clustering.html

# https://stats.stackexchange.com/questions/13442/how-to-find-groupings-trajectories-among-longitudinal-data
```

Plot chunk `, fig.align = "center"` — simulated object(s):
`PROBC, dat, list_of_interest, plot, list_of_interest_1, j, i, p, p04, x, title, subtitle`

``` r
# ---- Source: NUMABRep02.Rmd | chunk: , fig.align = "center" ----

list_of_interest_1 <- list_of_interest %>%  distinct(Panel, Assay) 
for (k in (1:dim(list_of_interest_1)[1])){
  
j = list_of_interest_1$Panel[k]
i = list_of_interest_1$Assay[k]
cat("\n\n### Panel: ", j,  "- Assay: ", i, " - Group-based NPX trajectories over timepoints",  "\n")  

  
dat <- PROBC %>% dplyr::filter((Assay %in% i) & (Panel %in% j))


theme_set(theme_bw(base_size = 7, base_family = ""))

p04 <-    ggplot(dat, aes(Timepoint, NPX)) +
      geom_line(aes(group = PPID, color = PPID)) +
      geom_point(aes(color = PPID, shape = PPID)) +
      geom_smooth(method = "loess")  +
      scale_x_discrete(drop = F, breaks = unique(dat$Time)) +
      labs(
        x = "Timepoint (day)",
        y = "NPX",
        title = unique(dat$Panel),
        subtitle = paste0(i, "- Distribution of NPX over timepoints. 
                          \n Blue curve and the grey shade showing the trend line of all trajectoriesand and its Confidence Interval")
      ) + facet_wrap(~ Group) +
       theme_bw()   + guides(col = guide_legend(nrow = 13)) 


print(p04)

}
```

Plot chunk `, fig.align = "center"` — simulated object(s):
`PROBC, dat, list_of_interest, plot, list_of_interest_1, j, i, p, x, title, Sum, data, pd, P, color, ymax, width`

``` r
# ---- Source: NUMABRep02.Rmd | chunk: , fig.align = "center" ----

list_of_interest_1 <- list_of_interest %>%  distinct(Panel, Assay) 
for (k in (1:dim(list_of_interest_1)[1])){
  
j = list_of_interest_1$Panel[k]
i = list_of_interest_1$Assay[k]
cat("\n\n### Panel: ", j,  "- Assay: ", i, " - Mean NPX trajectories over timepoints",  "\n")  

  
dat <- PROBC %>% dplyr::filter((Assay %in% i) & (Panel %in% j))

Sum = groupwiseMean(NPX ~ Group + Timepoint,
                    data   = dat,
                    conf   = 0.95,
                    digits = 3,
                    traditional = FALSE,
                    percentile  = TRUE)

pd = position_dodge(.2)

P<- ggplot(Sum, aes(x =    Timepoint,
                y =    Mean,
                color = Group)) +
    geom_errorbar(aes(ymin=Percentile.lower,
                      ymax=Percentile.upper),
                   width=.2, size=0.7, position=pd) +
    geom_point(shape=15, size=4, position=pd) +
    theme_bw() +
    theme(axis.title = element_text(face = "bold")) +
    ylab("NPX") + 
  guides(fill=guide_legend(title="Cohort")) +
    scale_color_manual(values = c("#00AFBB", "deeppink2","grey")) +
  stat_compare_means(aes(group = Group), label = "p.signif", size =3, method = "anova")
  
print(P)

}
```

Plot chunk `(unnamed chunk)` — simulated object(s):
`list_of_interest, i, p, color, ttest_results_list, proteins_mapped, int_net, graph_1, image_format, network_flavor, graph_2, enriched`

``` r
# ---- Source: NUMABRep02.Rmd | chunk: (unnamed chunk) ----
pacman::p_load(rbioapi)


ttest_results_list <-  unique(list_of_interest$Assay)[1:20]

proteins_mapped <- rba_string_map_ids(ids = ttest_results_list,
                                      species = 9606)


## 2 Now we map our protein IDs

int_net <- rba_string_interactions_network(ids = ttest_results_list,
                                          species = 9606,
                                           save_image = FALSE,
                                          required_score = 500)


graph_1 <- rba_string_network_image(ids = proteins_mapped$stringId ,
                                   image_format = "image",
                                   species = 9606,
                                   save_image = FALSE,
                                   required_score = 500,
                                   network_flavor = "confidence")



graph_2 <- rba_string_network_image(ids = proteins_mapped$stringId,
                                    image_format = "image",
                                    species = 9606,
                                    save_image = FALSE,
                                    required_score = 500,
                                    add_color_nodes = 5,
                                    add_white_nodes = 5,
                                   network_flavor = "actions")


enriched <- rba_string_enrichment(ids = proteins_mapped$stringId,
                                  species = 9606)

cat("\n\n#### Network of proteins of interest 1")  


knitr::include_graphics(here::here("rbioapi",list.files(here::here("rbioapi"))
                                   [length(list.files(here::here("rbioapi")))]))

cat("\n\n#### Network of proteins of interest 2")  

knitr::include_graphics(here::here("rbioapi",list.files(here::here("rbioapi"))[length(list.files(here::here("rbioapi")))-1]))
```

## NUMABRep03.Rmd

Plot chunk `, fig.height=10, fig.width=15, fig.align = "center"` —
simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMABRep03.Rmd | chunk: , fig.height=10, fig.width=15, fig.align = "center" ----
olink_pca_plot(
    df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
    color_g = "Timepoint",
    byPanel = TRUE
  )
```

Plot chunk
`, fig.cap= "PCA by groups of treatment", fig.topcaption=FALSE, fig.width=10, fig.height=6, fig.align = "center"`
— simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMABRep03.Rmd | chunk: , fig.cap= "PCA by groups of treatment", fig.topcaption=FALSE, fig.width=10, fig.height=6, fig.align = "center" ----
olink_pca_plot(
   df = PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response"),
   color_g = "TreatGroup",
    byPanel = TRUE)




# olink_umap_plot(
#    df = PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response" & Timepoint == 1 ),
#    color_g = "Group",
#     byPanel = TRUE)
```

Plot chunk `, fig.width=10, fig.height=6, fig.align = "center"` —
simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMABRep03.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center" ----
olink_pca_plot(
   df = PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response"  & Timepoint == 1),
   color_g = "TreatGroup",
    byPanel = TRUE)
```

Plot chunk `, fig.width=10, fig.height=6, fig.align = "center"` —
simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMABRep03.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center" ----
olink_pca_plot(
   df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
   color_g = "TreatGroup",
    byPanel = TRUE)


# olink_umap_plot(
#    df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
#    color_g = "Group",
#     byPanel = TRUE)
```

Plot chunk `, fig.width=8, fig.height=10, fig.align = "center"` —
simulated object(s): `df, fun_plot, p2`

``` r
# ---- Source: NUMABRep03.Rmd | chunk: , fig.width=8, fig.height=10, fig.align = "center" ----
p2 <- fun_plot(df_var1)
```

Plot chunk
`, fig.width=10, fig.height=6, fig.cap = "**IL4** - NPX trajectories over timepoints", fig.align = "center"`
— simulated object(s): `PROBC, dat`

``` r
# ---- Source: NUMABRep03.Rmd | chunk: , fig.width=10, fig.height=6,  fig.cap = "**IL4** - NPX trajectories over timepoints", fig.align = "center" ----
dat <- PROBC %>% dplyr::filter((Assay %in% "IL4") & (Panel %in%  "Olink Inflammation"))
dat$PPID <- factor(dat$PPID)
ggplot(dat, aes(Timepoint, NPX, group = factor(PPID), col = factor(PPID))) +
  geom_point() +
  geom_line() +
  labs(x = "Timepoint, days", y = "NPX", col = "PPID") +
  facet_wrap(~ PPID)+
  theme_light() +
  guides(col = guide_legend(ncol = 8)) + theme(legend.position="bottom") 
# https://bookdown.org/tpinto_home/Unsupervised-learning/k-means-clustering.html

# https://stats.stackexchange.com/questions/13442/how-to-find-groupings-trajectories-among-longitudinal-data
```

Plot chunk
`, fig.width=10, fig.height=6, fig.align = "center", fig.cap = "**IL4** - Spaghetti plot of NPX over timepoints"`
— simulated object(s): `dat, Speg.2`

``` r
# ---- Source: NUMABRep03.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center", fig.cap = "**IL4** - Spaghetti plot of NPX over timepoints" ----
theme_set(theme_bw(base_size = 7, base_family = ""))

Speg.2<-ggplot(data = dat, aes(x=Time,y=NPX, group=PPID, color=PPID))+
  facet_wrap(~TreatGroup)+
  geom_point()+
  geom_line()+
  #geom_smooth(method='lm', se=FALSE)+
  xlab("Time")+ylab("NPX")+
  theme_light() + guides(col = guide_legend(nrow = 13)) 
Speg.2 
```

Plot chunk
`, fig.width=10, fig.height=6, fig.cap = "**CXCL12** - NPX trajectories over timepoints", fig.align = "center"`
— simulated object(s): `PROBC, dat`

``` r
# ---- Source: NUMABRep03.Rmd | chunk: , fig.width=10, fig.height=6,  fig.cap = "**CXCL12** - NPX trajectories over timepoints", fig.align = "center" ----
dat <- PROBC %>% dplyr::filter((Assay %in% "CXCL12") & (Panel %in%  "Olink Immune Response"))
dat$PPID <- factor(dat$PPID)
ggplot(dat, aes(Timepoint, NPX, group = factor(PPID), col = factor(PPID))) +
  geom_point() +
  geom_line() +
  labs(x = "Timepoint, days", y = "NPX", col = "PPID") +
  facet_wrap(~ PPID)+
  theme_light() +
  guides(col = guide_legend(ncol = 8)) + theme(legend.position="bottom") 
# https://bookdown.org/tpinto_home/Unsupervised-learning/k-means-clustering.html

# https://stats.stackexchange.com/questions/13442/how-to-find-groupings-trajectories-among-longitudinal-data
```

Plot chunk
`, fig.width=10, fig.height=6, fig.align = "center", fig.cap = "**CXCL12** - Spaghetti plot of NPX over timepoints"`
— simulated object(s): `dat, Speg.2`

``` r
# ---- Source: NUMABRep03.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center", fig.cap = "**CXCL12** - Spaghetti plot of NPX over timepoints" ----
theme_set(theme_bw(base_size = 7, base_family = ""))

Speg.2<-ggplot(data = dat, aes(x=Time,y=NPX, group=PPID, color=PPID))+
  facet_wrap(~TreatGroup)+
  geom_point()+
  geom_line()+
  #geom_smooth(method='lm', se=FALSE)+
  xlab("Time")+ylab("NPX")+
  theme_light() + guides(col = guide_legend(nrow = 13)) 
Speg.2 
```

Plot chunk
`, fig.width=10, fig.height=6, fig.cap = "**NCR1** - NPX trajectories over timepoints", fig.align = "center"`
— simulated object(s): `PROBC, dat`

``` r
# ---- Source: NUMABRep03.Rmd | chunk: , fig.width=10, fig.height=6,  fig.cap = "**NCR1** - NPX trajectories over timepoints", fig.align = "center" ----
dat <- PROBC %>% dplyr::filter((Assay %in% "NCR1") & (Panel %in%  "Olink Immune Response"))
dat$PPID <- factor(dat$PPID)
ggplot(dat, aes(Timepoint, NPX, group = factor(PPID), col = factor(PPID))) +
  geom_point() +
  geom_line() +
  labs(x = "Timepoint, days", y = "NPX", col = "PPID") +
  facet_wrap(~ PPID)+
  theme_light() +
  guides(col = guide_legend(ncol = 8)) + theme(legend.position="bottom") 
# https://bookdown.org/tpinto_home/Unsupervised-learning/k-means-clustering.html

# https://stats.stackexchange.com/questions/13442/how-to-find-groupings-trajectories-among-longitudinal-data
```

Plot chunk `, fig.width=10, fig.height=6, fig.align = "center"` —
simulated object(s):
`PROBC, df, lmer_results_twoway, lmer_results_twoway_significant, olinkid_list, plot`

``` r
# ---- Source: NUMABRep03.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center" ----
if (requireNamespace("lme4", quietly = TRUE) & requireNamespace("lmerTest", quietly = TRUE)){
  plot <- olink_lmer_plot(df = PROBC, 
                          olinkid_list = unique(lmer_results_twoway_significant), 
                           variable = c('Timepoint', 'TreatGroup'),
                          x_axis_variable =  'Timepoint',
                          col_variable = 'TreatGroup',
                          random = 'PPID')
  plot[[1]]
}
```

Plot chunk
`, fig.width=10, fig.height=6, fig.cap = "NPX trajectories over timepoints", fig.align = "center"`
— simulated object(s):
`PROBC, list_of_interest, lmer_posthoc_twoway_results, dat, plot, list_of_interest_1, j, i, p`

``` r
# ---- Source: NUMABRep03.Rmd | chunk: , fig.width=10, fig.height=6, fig.cap = "NPX trajectories over timepoints", fig.align = "center" ----


list_of_interest_1 <- list_of_interest %>%  distinct(Panel, Assay) %>% dplyr::filter(Assay %in% unique(lmer_posthoc_twoway_results$Assay))
for (k in (1:dim(list_of_interest_1)[1])){
  
j = list_of_interest_1$Panel[k]
i = list_of_interest_1$Assay[k]
cat("\n\n### Panel: ", j,  "- Assay: ", i, " - Patient NPX trajectories over timepoints",  "\n")  

  
dat <- PROBC %>% dplyr::filter((Assay %in% i) & (Panel %in% j))
dat$PPID <- factor(dat$PPID)
dat$TreatGroup <- factor(dat$TreatGroup)
dat$Timepoint <- factor(dat$Timepoint)
p <- ggplot(dat, aes(Timepoint, NPX, group = factor(PPID), col = factor(PPID))) +
  geom_point() +
  geom_line() +
  labs(title = j, subtitle = i, x = "Timepoint, days", y = "NPX", col = "PPID") +
  facet_wrap(~ PPID)+
  theme_light() +
  guides(col = guide_legend(ncol = 8)) + theme(legend.position="bottom") 


print(p)
}





# https://bookdown.org/tpinto_home/Unsupervised-learning/k-means-clustering.html

# https://stats.stackexchange.com/questions/13442/how-to-find-groupings-trajectories-among-longitudinal-data
```

Plot chunk `, fig.width=10, fig.height=6, fig.align = "center"` —
simulated object(s):
`PROBC, list_of_interest, lmer_posthoc_twoway_results, dat, plot, list_of_interest_1, j, i, p, llist_of_interest_1, p04, x, title, subtitle`

``` r
# ---- Source: NUMABRep03.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center" ----

llist_of_interest_1 <- list_of_interest %>%  distinct(Panel, Assay) %>% dplyr::filter(Assay %in% unique(lmer_posthoc_twoway_results$Assay))
for (k in (1:dim(list_of_interest_1)[1])){
  
j = list_of_interest_1$Panel[k]
i = list_of_interest_1$Assay[k]
cat("\n\n### Panel: ", j,  "- Assay: ", i, " - Group-based NPX trajectories over timepoints",  "\n")  

  
dat <- PROBC %>% dplyr::filter((Assay %in% i) & (Panel %in% j))
dat$PPID <- factor(dat$PPID)
dat$TreatGroup <- factor(dat$TreatGroup)
dat$Timepoint <- factor(dat$Timepoint)

theme_set(theme_bw(base_size = 7, base_family = ""))

p04 <-    ggplot(dat, aes(Timepoint, NPX)) +
      geom_line(aes(group = PPID, color = PPID)) +
      geom_point(aes(color = PPID, shape = PPID)) +
      geom_smooth(method = "loess")  +
      scale_x_discrete(drop = F, breaks = unique(dat$Time)) +
      labs(
        x = "Timepoint (day)",
        y = "NPX",
        title = unique(dat$Panel),
        subtitle = paste0(i, "- Distribution of NPX over timepoints")
      ) + facet_wrap(~ TreatGroup) +
       theme_bw()   + guides(col = guide_legend(nrow = 13)) 


print(p04)

}
```

Plot chunk `, fig.width=10, fig.height=6, fig.align = "center"` —
simulated object(s):
`PROBC, list_of_interest, lmer_posthoc_twoway_results, dat, plot, list_of_interest_1, j, i, p, x, title, Sum, data, pd, P, color, ymax, width`

``` r
# ---- Source: NUMABRep03.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center" ----

list_of_interest_1 <- list_of_interest %>%  distinct(Panel, Assay) %>% dplyr::filter(Assay %in% unique(lmer_posthoc_twoway_results$Assay))
for (k in (1:dim(list_of_interest_1)[1])){
  
j = list_of_interest_1$Panel[k]
i = list_of_interest_1$Assay[k]
cat("\n\n### Panel: ", j,  "- Assay: ", i, " - Mean ± margin of error of NPX over timepoints for 3 treatment groups",  "\n")  

  
dat <- PROBC %>% dplyr::filter((Assay %in% i) & (Panel %in% j))
dat$PPID <- factor(dat$PPID)
dat$TreatGroup <- factor(dat$TreatGroup)
dat$Timepoint <- factor(dat$Timepoint)
Sum = groupwiseMean(NPX ~ TreatGroup + Timepoint,
                    data   = dat,
                    conf   = 0.95,
                    digits = 3,
                    traditional = FALSE,
                    percentile  = TRUE)

pd = position_dodge(.2)

P<- ggplot(Sum, aes(x =    Timepoint,
                y =    Mean,
                color = TreatGroup)) +
    geom_errorbar(aes(ymin=Percentile.lower,
                      ymax=Percentile.upper),
                   width=.2, size=0.7, position=pd) +
    geom_point(shape=15, size=4, position=pd) +
    theme_bw() +
    theme(axis.title = element_text(face = "bold")) +
    ylab("NPX") + 
  guides(fill=guide_legend(title="Cohort")) +
    scale_color_manual(values = c("#00AFBB", "deeppink2","grey")) +
  stat_compare_means(aes(group = TreatGroup), label = "p.signif", size =3, method = "anova")
  
print(P)

}
```

Plot chunk `, fig.width=10, fig.height=6, fig.align = "center"` —
simulated object(s):
`list_of_interest, i, p, color, ttest_results_list, proteins_mapped, int_net, graph_1, image_format, network_flavor, graph_2, enriched`

``` r
# ---- Source: NUMABRep03.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center" ----
pacman::p_load(rbioapi)


ttest_results_list <-  unique(list_of_interest$Assay)

proteins_mapped <- rba_string_map_ids(ids = ttest_results_list,
                                      species = 9606)


## 2 Now we map our protein IDs

int_net <- rba_string_interactions_network(ids = ttest_results_list,
                                          species = 9606,
                                           save_image = FALSE,
                                          required_score = 500)


graph_1 <- rba_string_network_image(ids = proteins_mapped$stringId ,
                                   image_format = "image",
                                   species = 9606,
                                   save_image = FALSE,
                                   required_score = 500,
                                   network_flavor = "confidence")



graph_2 <- rba_string_network_image(ids = proteins_mapped$stringId,
                                    image_format = "image",
                                    species = 9606,
                                    save_image = FALSE,
                                    required_score = 500,
                                    add_color_nodes = 5,
                                    add_white_nodes = 5,
                                   network_flavor = "actions")


enriched <- rba_string_enrichment(ids = proteins_mapped$stringId,
                                  species = 9606)

cat("\n\n#### Network of proteins of interest 1")  


knitr::include_graphics(here::here("rbioapi",list.files(here::here("rbioapi"))
                                   [length(list.files(here::here("rbioapi")))]))

cat("\n\n#### Network of proteins of interest 2")  

knitr::include_graphics(here::here("rbioapi",list.files(here::here("rbioapi"))[length(list.files(here::here("rbioapi")))-1]))
```

## NUMABRep04.Rmd

Plot chunk `, fig.height=10, fig.width=15, fig.align = "center"` —
simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: , fig.height=10, fig.width=15, fig.align = "center" ----
olink_pca_plot(
    df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
    color_g = "Timepoint",
    byPanel = TRUE
  )
```

Plot chunk
`, fig.cap= "PCA by groups of treatment", fig.topcaption=FALSE, fig.width=10, fig.height=6, fig.align = "center"`
— simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: , fig.cap= "PCA by groups of treatment", fig.topcaption=FALSE, fig.width=10, fig.height=6, fig.align = "center" ----
olink_pca_plot(
   df = PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response"),
   color_g = "TreatGroup",
    byPanel = TRUE)




# olink_umap_plot(
#    df = PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response" & Timepoint == 1 ),
#    color_g = "Group",
#     byPanel = TRUE)
```

Plot chunk `, fig.width=10, fig.height=6, fig.align = "center"` —
simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center" ----
for(i in (unique(PROBC$Timepoint))){
plt_lst <- olink_pca_plot(
   df = PROBC %>% dplyr::filter(Timepoint == i),
   color_g = "TreatGroup",
    byPanel = FALSE)
plt_lst[[1]] <- plt_lst[[1]] + labs(title = paste0("Timepoint (days): ", unique(PROBC$Timepoint)[i]))
plt_lst[[1]]

}

# for(j in seq_along(plt_lst)) {
#   plt_lst[[j]] <- plt_lst[[j]] + labs(title = paste0("Timepoint (days): ", unique(PROBC$Timepoint)[j]))
#   print(plt_lst[[j]])
# }
```

Plot chunk `, fig.width=10, fig.height=6, fig.align = "center"` —
simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center" ----
olink_pca_plot(
   df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
   color_g = "TreatGroup",
    byPanel = TRUE)


# olink_umap_plot(
#    df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
#    color_g = "Group",
#     byPanel = TRUE)
```

Plot chunk `, fig.width=8, fig.height=10, fig.align = "center"` —
simulated object(s): `df, fun_plot, p2`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: , fig.width=8, fig.height=10, fig.align = "center" ----
p2 <- fun_plot(df_var1)
```

Plot chunk `, fig.width=14, fig.height=8, fig.align = "center"` —
simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: , fig.width=14, fig.height=8, fig.align = "center" ----
for(i in  unique(PROBC$Timepoint))
{
  
cat("\n\n##### Timepoint: ", i, "\n")  
  
  try({ #This statement might fail if dependencies are not installed

  df <- PROBC %>% dplyr::filter(Panel %in% "Olink Immune Response" & Timepoint == i) %>% dplyr::arrange(TreatGroup)
print(  olink_heatmap_plot(df, variable_row_list =  c('TreatGroup'), cluster_rows = FALSE) + labs(title = "Immune Response", subtitle = paste0("Timepoint - ", i)))
  })
  
}
```

Plot chunk `, fig.width=14, fig.height=8, fig.align = "center"` —
simulated object(s): `PROBC, df`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: , fig.width=14, fig.height=8, fig.align = "center" ----
for(i in  unique(PROBC$Timepoint))
{
  cat("\n\n##### Timepoint: ", i, "\n")  
  
  try({ #This statement might fail if dependencies are not installed

  df <- PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation" & Timepoint == i) %>% dplyr::arrange(TreatGroup)
  print(olink_heatmap_plot(df, variable_row_list =  c('TreatGroup'), cluster_rows = FALSE) + labs(title = "Olink Inflammation", subtitle = paste0("Timepoint - ", i)))
  })
  
}
```

Plot chunk `(unnamed chunk)` — simulated object(s): `PROBC`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: (unnamed chunk) ----
ggplot(PROBC %>% dplyr::filter(Assay %in% "IL4"), aes(Timepoint, NPX, color=TreatGroup)) + 
  stat_summary(fun.data=mean_se, geom="pointrange") + 
  labs(y="Fixation Proportion", x="Time since word onset (ms)") + 
  theme_bw() + scale_color_manual(values=c("red", "blue", "green")) 
```

Plot chunk `(unnamed chunk)` — simulated object(s):
`PROBC, df, lmer_results_twoway, lmer_results_twoway_significant, lmer_posthoc_twoway_results, olinkid_list, plot`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: (unnamed chunk) ----
 # Linear mixed model with two variables.
  lmer_results_twoway <- olink_lmer(df = PROBC, 
                                    variable = c('Timepoint', 'TreatGroup'),
                                    random = 'PPID')
  
  # extracting the significant proteins
  lmer_results_twoway_significant <- lmer_results_twoway %>%
    # dplyr::filter(Threshold== 'Significant') %>%
    dplyr::filter(p.value < 0.05) %>%
    dplyr::pull(OlinkID)
  # performing post-hoc analysis
  lmer_posthoc_twoway_results <- olink_lmer_posthoc(df = PROBC,
                                                    olinkid_list = lmer_results_twoway_significant,
                                                    variable = c('Timepoint', 'TreatGroup'),
                                                    random = 'PPID',
                                                    effect = 'TreatGroup') 


lmer_posthoc_twoway_results %>% 
 round_df(digits=3) %>%  
  dplyr::filter(Threshold== 'Significant') %>%
  df_display() 


if (requireNamespace("lme4", quietly = TRUE) & requireNamespace("lmerTest", quietly = TRUE)){
  plot <- olink_lmer_plot(df = PROBC, 
                          olinkid_list = unique(lmer_results_twoway_significant), 
                           variable = c('Timepoint', 'TreatGroup', 'AGE', 'SEX'),
                          x_axis_variable =  'Timepoint',
                          col_variable = 'TreatGroup',
                          number_of_proteins_per_plot = 1, 
                          random = 'PPID') 
 
 walk(plot, print)
 
}
```

Plot chunk `(unnamed chunk)` — simulated object(s):
`PROBC, df, lmer_results_twoway, lmer_results_twoway_significant, lmer_posthoc_twoway_results, olinkid_list, plot, lmer_results_twoway_1, lmer_results_twoway_significant_1, lmer_posthoc_twoway_results_1`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: (unnamed chunk) ----
 # Linear mixed model with two variables.
  lmer_results_twoway_1 <- olink_lmer(df = PROBC, 
                                    variable = c('Timepoint', 'TreatGroup', 'AGE'),
                                    random = 'PPID')
  
  # extracting the significant proteins
  lmer_results_twoway_significant_1 <- lmer_results_twoway_1 %>%
    # dplyr::filter(Threshold== 'Significant') %>%
    dplyr::filter(p.value < 0.05) %>%
    dplyr::pull(OlinkID)
  # performing post-hoc analysis
  lmer_posthoc_twoway_results_1 <- olink_lmer_posthoc(df = PROBC,
                                                    olinkid_list = lmer_results_twoway_significant_1,
                                                    variable = c('Timepoint', 'TreatGroup', 'AGE'),
                                                    random = 'PPID',
                                                    effect = 'TreatGroup') 


lmer_posthoc_twoway_results_1 %>% 
 round_df(digits=3) %>%  
  dplyr::filter(Threshold== 'Significant') %>%
  df_display() 


if (requireNamespace("lme4", quietly = TRUE) & requireNamespace("lmerTest", quietly = TRUE)){
  plot <- olink_lmer_plot(df = PROBC, 
                          olinkid_list = unique(lmer_results_twoway_significant_1), 
                           variable = c('Timepoint', 'TreatGroup', 'AGE'),
                          x_axis_variable =  'Timepoint',
                          col_variable = 'TreatGroup',
                          number_of_proteins_per_plot = 1, 
                          random = 'PPID') 
 
 walk(plot, print)
 
}
```

Plot chunk `(unnamed chunk)` — simulated object(s):
`PROBC, df, lmer_results_twoway, lmer_results_twoway_significant, lmer_posthoc_twoway_results, olinkid_list, plot, lmer_results_twoway_2, lmer_results_twoway_significant_2, lmer_posthoc_twoway_results_2`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: (unnamed chunk) ----
 # Linear mixed model with two variables.
  lmer_results_twoway_2 <- olink_lmer(df = PROBC, 
                                    variable = c('Timepoint', 'TreatGroup', 'AGE', 'SEX'),
                                    random = 'PPID')
  
  # extracting the significant proteins
  lmer_results_twoway_significant_2 <- lmer_results_twoway_2 %>%
    # dplyr::filter(Threshold== 'Significant') %>%
    dplyr::filter(p.value < 0.05) %>%
    dplyr::pull(OlinkID)
  # performing post-hoc analysis
  lmer_posthoc_twoway_results_2 <- olink_lmer_posthoc(df = PROBC,
                                                    olinkid_list = lmer_results_twoway_significant_2,
                                                    variable = c('Timepoint', 'TreatGroup', 'AGE', 'SEX'),
                                                    random = 'PPID',
                                                    effect = 'TreatGroup') 


lmer_posthoc_twoway_results_2 %>% 
 round_df(digits=3) %>%  
  dplyr::filter(Threshold== 'Significant') %>%
  df_display() 


if (requireNamespace("lme4", quietly = TRUE) & requireNamespace("lmerTest", quietly = TRUE)){
  plot <- olink_lmer_plot(df = PROBC, 
                          olinkid_list = unique(lmer_results_twoway_significant_2), 
                           variable = c('Timepoint', 'TreatGroup', 'AGE', 'SEX'),
                          x_axis_variable =  'Timepoint',
                          col_variable = 'TreatGroup',
                          number_of_proteins_per_plot = 1, 
                          random = 'PPID') 
 
 walk(plot, print)
 
}
```

Plot chunk
`, fig.width=10, fig.height=6, fig.cap = "**IL4** - NPX trajectories over timepoints", fig.align = "center"`
— simulated object(s): `PROBC, plot, dat`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: , fig.width=10, fig.height=6,  fig.cap = "**IL4** - NPX trajectories over timepoints", fig.align = "center" ----
dat <- PROBC %>% dplyr::filter((Assay %in% "IL4") & (Panel %in%  "Olink Inflammation"))
dat$PPID <- factor(dat$PPID)
ggplot(dat, aes(Timepoint, NPX, group = factor(PPID), col = factor(PPID))) +
  geom_point() +
  geom_line() +
  labs(x = "Timepoint, days", y = "NPX", col = "PPID") +
  facet_wrap(~ PPID)+
  theme_light() +
  guides(col = guide_legend(ncol = 8)) + theme(legend.position="bottom") 
# https://bookdown.org/tpinto_home/Unsupervised-learning/k-means-clustering.html

# https://stats.stackexchange.com/questions/13442/how-to-find-groupings-trajectories-among-longitudinal-data
```

Plot chunk
`, fig.width=10, fig.height=6, fig.align = "center", fig.cap = "**IL4** - Spaghetti plot of NPX over timepoints"`
— simulated object(s): `plot, dat, Speg.2`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center", fig.cap = "**IL4** - Spaghetti plot of NPX over timepoints" ----
theme_set(theme_bw(base_size = 7, base_family = ""))

Speg.2<-ggplot(data = dat, aes(x=Time,y=NPX, group=PPID, color=PPID))+
  facet_wrap(~TreatGroup)+
  geom_point()+
  geom_line()+
  #geom_smooth(method='lm', se=FALSE)+
  xlab("Time")+ylab("NPX")+
  theme_light() + guides(col = guide_legend(nrow = 13)) 
Speg.2 
```

Plot chunk
`, fig.width=10, fig.height=6, fig.cap = "**CXCL12** - NPX trajectories over timepoints", fig.align = "center"`
— simulated object(s): `PROBC, plot, dat`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: , fig.width=10, fig.height=6,  fig.cap = "**CXCL12** - NPX trajectories over timepoints", fig.align = "center" ----
dat <- PROBC %>% dplyr::filter((Assay %in% "CXCL12") & (Panel %in%  "Olink Immune Response"))
dat$PPID <- factor(dat$PPID)
ggplot(dat, aes(Timepoint, NPX, group = factor(PPID), col = factor(PPID))) +
  geom_point() +
  geom_line() +
  labs(x = "Timepoint, days", y = "NPX", col = "PPID") +
  facet_wrap(~ PPID)+
  theme_light() +
  guides(col = guide_legend(ncol = 8)) + theme(legend.position="bottom") 
# https://bookdown.org/tpinto_home/Unsupervised-learning/k-means-clustering.html

# https://stats.stackexchange.com/questions/13442/how-to-find-groupings-trajectories-among-longitudinal-data
```

Plot chunk
`, fig.width=10, fig.height=6, fig.align = "center", fig.cap = "**CXCL12** - Spaghetti plot of NPX over timepoints"`
— simulated object(s): `plot, dat, Speg.2`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center", fig.cap = "**CXCL12** - Spaghetti plot of NPX over timepoints" ----
theme_set(theme_bw(base_size = 7, base_family = ""))

Speg.2<-ggplot(data = dat, aes(x=Time,y=NPX, group=PPID, color=PPID))+
  facet_wrap(~TreatGroup)+
  geom_point()+
  geom_line()+
  #geom_smooth(method='lm', se=FALSE)+
  xlab("Time")+ylab("NPX")+
  theme_light() + guides(col = guide_legend(nrow = 13)) 
Speg.2 
```

Plot chunk
`, fig.width=10, fig.height=6, fig.cap = "**NCR1** - NPX trajectories over timepoints", fig.align = "center"`
— simulated object(s): `PROBC, plot, dat`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: , fig.width=10, fig.height=6,  fig.cap = "**NCR1** - NPX trajectories over timepoints", fig.align = "center" ----
dat <- PROBC %>% dplyr::filter((Assay %in% "NCR1") & (Panel %in%  "Olink Immune Response"))
dat$PPID <- factor(dat$PPID)


ggplot(dat, aes(x = Timepoint, y = NPX)) + geom_point(color = "blue", alpha = 0.7) + 
  geom_smooth(method = "lm", color = "black") + theme_bw() + facet_wrap(~TreatGroup)


ggplot(dat, aes(Timepoint, NPX, group = factor(PPID), col = factor(PPID))) +
  geom_point() +
  geom_line() +
  labs(x = "Timepoint, days", y = "NPX", col = "PPID") +
  facet_wrap(~ PPID)+
  theme_light() +
  guides(col = guide_legend(ncol = 8)) + theme(legend.position="bottom") 
# https://bookdown.org/tpinto_home/Unsupervised-learning/k-means-clustering.html

# https://stats.stackexchange.com/questions/13442/how-to-find-groupings-trajectories-among-longitudinal-data
```

Plot chunk
`, fig.width=10, fig.height=6, fig.align = "center", fig.cap = "**NCR1** - Spaghetti plot of NPX over timepoints"`
— simulated object(s): `plot, dat, Speg.2, p, x, title, subtitle`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center", fig.cap = "**NCR1** - Spaghetti plot of NPX over timepoints" ----

i = "NCR1"
theme_set(theme_bw(base_size = 7, base_family = ""))

Speg.2<-ggplot(data = dat, aes(x=Timepoint,y=NPX, group=PPID, color=PPID))+
  facet_wrap(~TreatGroup)+
  geom_point()+
  geom_line()+
 # geom_smooth(method='lm', se=FALSE)+
  xlab("Timepoint (days)")+ylab("NPX")+
  theme_light() + guides(col = guide_legend(nrow = 13)) 
Speg.2 



p <- ggplot(dat, aes(Timepoint, NPX)) +
      geom_line(aes(group = PPID, color = PPID)) +
      geom_point(aes(color = PPID)) +
      geom_smooth(method = "loess")  +
      
      labs(
        x = "Timepoint (day)",
        y = "NPX",
        title = unique(dat$Panel),
        subtitle = paste0(i, "- Distribution of NPX over timepoints. Blue curve and the grey shade showing the trend line of all trajectoriesand and its Confidence Interval")
      ) +
      theme_bw()  

p + facet_wrap(~ TreatGroup) + 
  geom_smooth(aes(group=1), se=TRUE, colour="turquoise", size =2)
```

Plot chunk `, fig.width=14, fig.height=7, fig.align = "center"` —
simulated object(s):
`PROBC, df, lmer_results_twoway, lmer_results_twoway_significant, olinkid_list, plot, p, x, variable, x_axis_variable, col_variable`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: , fig.width=14, fig.height=7, fig.align = "center" ----
if (requireNamespace("lme4", quietly = TRUE) & requireNamespace("lmerTest", quietly = TRUE)){
  plot <- olink_lmer_plot(df = PROBC, 
                          olinkid_list = unique(lmer_results_twoway_significant), 
                           variable = c('Timepoint', 'TreatGroup', 'AGE', 'SEX'),
                          x_axis_variable =  'Timepoint',
                          col_variable = 'TreatGroup',
                          number_of_proteins_per_plot = 1, 
                          random = 'PPID')
 
 walk(plot, print)
 
}
```

Plot chunk `, fig.width=10, fig.height=6, fig.align = "center"` —
simulated object(s):
`list_of_interest, p, results_list, proteins_mapped, int_net, graph_1, graph_2, enriched`

``` r
# ---- Source: NUMABRep04.Rmd | chunk: , fig.width=10, fig.height=6, fig.align = "center" ----
pacman::p_load(rbioapi)


results_list <-  unique(list_of_interest$Assay)

proteins_mapped <- rba_string_map_ids(ids = results_list,
                                      species = 9606)


## 2 Now we map our protein IDs

int_net <- rba_string_interactions_network(ids = results_list,
                                          species = 9606,
                                           save_image = FALSE,
                                          required_score = 500)


graph_1 <- rba_string_network_image(ids = proteins_mapped$stringId ,
                                   image_format = "image",
                                   species = 9606,
                                   save_image = FALSE,
                                   required_score = 500,
                                   network_flavor = "confidence")



graph_2 <- rba_string_network_image(ids = proteins_mapped$stringId,
                                    image_format = "image",
                                    species = 9606,
                                    save_image = FALSE,
                                    required_score = 500,
                                    add_color_nodes = 5,
                                    add_white_nodes = 5,
                                   network_flavor = "actions")


enriched <- rba_string_enrichment(ids = proteins_mapped$stringId,
                                  species = 9606)

cat("\n\n#### Network of proteins of interest 1")  


knitr::include_graphics(here::here("rbioapi",list.files(here::here("rbioapi"))
                                   [length(list.files(here::here("rbioapi")))]))

cat("\n\n#### Network of proteins of interest 2")  

knitr::include_graphics(here::here("rbioapi",list.files(here::here("rbioapi"))[length(list.files(here::here("rbioapi")))-1]))
```

## SAP_NUMAB_01.Rmd

Plot chunk
`meanprofile, fig.width=10, fig.height=6, label='meanprofile', fig.cap = "**IL6** - Mean of NPX over time for 2 groups: B1 and B2"`
— simulated object(s): `PROBC, dat, p`

``` r
# ---- Source: SAP_NUMAB_01.Rmd | chunk: meanprofile, fig.width=10, fig.height=6, label='meanprofile', fig.cap = "**IL6** - Mean of NPX over time for 2 groups: B1 and B2" ----
PROBC$Group <- factor(PROBC$Group)

PROBC$Timepoint <- factor(PROBC$Time)
dat <- PROBC %>% dplyr::filter((Assay %in% "IL6") & (Panel %in%  "Olink Inflammation"))


p <- group_by(dat, Group, Timepoint) %>% 
  summarise(mean = list(mean_ci(NPX)), .groups = "drop") %>% 
  unnest_wider(mean) %>% 
  mutate(agex = as.numeric(as.character(Timepoint)) - 3 + .5*(Group == "B1")) %>% 
  ggplot(aes(agex, y, col = Group, shape = Group)) +
  geom_point() +
  geom_errorbar(aes(ymin = ymin, ymax = ymax), width = 0.5) +
  geom_line() +
  labs(x = "Timepoint, days", y = "NPX", shape = "Group", col = "Group") 
  #scale_x_discrete(breaks = c(1, 8, 15, 22, 29, 36, 43, 50, 57. 64. 71, 85 ))

print(p + theme_light())

cat('\\pagebreak')
```

Plot chunk
`, fig.width=10, fig.height=6, tab.id='singletraj', label='singletraj', fig.cap = "**IL6** - NPX trajectories over time for 2 group B1 and B2"`
— simulated object(s): `PROBC, dat, p`

``` r
# ---- Source: SAP_NUMAB_01.Rmd | chunk: , fig.width=10, fig.height=6, tab.id='singletraj', label='singletraj', fig.cap = "**IL6** - NPX trajectories over time for 2 group B1 and B2" ----
dat <- PROBC %>% dplyr::filter((Assay %in% "IL6") & (Panel %in%  "Olink Inflammation"))

ggplot(dat, aes(Timepoint, NPX, group = factor(PPID), col = factor(PPID))) +
  geom_point() +
  geom_line() +
  labs(x = "Timepoint, days", y = "NPX", col = "PPID") +
  facet_wrap(~ PPID)+
  theme_light() +
  guides(col = guide_legend(ncol = 8)) + theme(legend.position="bottom") 
# https://bookdown.org/tpinto_home/Unsupervised-learning/k-means-clustering.html

# https://stats.stackexchange.com/questions/13442/how-to-find-groupings-trajectories-among-longitudinal-data

cat('\\pagebreak')
```

Plot chunk
`, fig.width=10, fig.height=6, fig.cap = "**IL6** - Spaghetti plot of NPX over time for 2 groups: B1(left) and B2 (right)"`
— simulated object(s): `dat, p, Speg.2`

``` r
# ---- Source: SAP_NUMAB_01.Rmd | chunk: , fig.width=10, fig.height=6, fig.cap = "**IL6** - Spaghetti plot of NPX over time for 2 groups: B1(left) and B2 (right)" ----
theme_set(theme_bw(base_size = 7, base_family = ""))

Speg.2<-ggplot(data = dat, aes(x=Time,y=NPX, group=PPID, color=PPID))+
  facet_wrap(~Group)+
  geom_point()+
  geom_line()+
  #geom_smooth(method='lm', se=FALSE)+
  xlab("Time")+ylab("NPX")+
  theme_light() + guides(col = guide_legend(nrow = 13)) 
Speg.2 

cat('\\pagebreak')
```

Plot chunk
`pcagroup, fig.width=8, fig.height=5, fig.cap = "Principal Component Analysis(PCA) - Scatter plot of 2 first Principal Components (PCs), colored by cohorts: B1(blue) and B2 (red)"`
— simulated object(s): `PROBC, p, df, color_g`

``` r
# ---- Source: SAP_NUMAB_01.Rmd | chunk: pcagroup, fig.width=8, fig.height=5, fig.cap = "Principal Component Analysis(PCA) - Scatter plot of 2 first Principal Components (PCs), colored by cohorts: B1(blue) and B2 (red)" ----
olink_pca_plot(
    df = PROBC %>% dplyr::filter(Panel %in% "Olink Inflammation"),
    color_g = "Group",
    byPanel = TRUE
  )
```

Plot chunk `(unnamed chunk)` — simulated object(s):
`dat, p, df, df_anova, a1, data, test0, test, fit2, random, correlation`

``` r
# ---- Source: SAP_NUMAB_01.Rmd | chunk: (unnamed chunk) ----

(fit.ar1 <- glmmTMB(NPX ~ ar1(Timepoint + 0 | Group), data=df_anova))



library(nlme)

test0 <- lme(fixed = NPX ~ factor(Timepoint) + Group, 
    random = ~1|PPID, 
    data = df_anova)


test <- lme(fixed = NPX ~ factor(Timepoint) + Group, 
    random = ~1|PPID, 
    correlation = corAR1(), 
    data = df_anova)
anova(update(test0, method = "ML"), update(test, method = "ML"))




afex_plot(a1, x = "Timepoint", trace = "Group")



fit2 <- lme(NPX ~ as.factor(Timepoint), 
            random = ~ as:factor(Timepoint)|PPID,
           
            data = df_anova,
            method="ML")


fit2 <- lme(NPX ~ as.factor(Timepoint), 
            random = ~1|PPID, 
            correlation = corAR1(form = ~as.factor(Timepoint)|PPID), # AR(1)
            data = df_anova,
            method="ML")
```

Plot chunk `(unnamed chunk)` — simulated object(s):
`dat, p, df, title, df_anova, data, test, Sum, pd, color, ymax, width`

``` r
# ---- Source: SAP_NUMAB_01.Rmd | chunk: (unnamed chunk) ----
library(rcompanion)

Sum = groupwiseMean(NPX ~ Group + Timepoint,
                    data   = df_anova,
                    conf   = 0.95,
                    digits = 3,
                    traditional = FALSE,
                    percentile  = TRUE)

Sum



library(ggplot2)

pd = position_dodge(.2)

ggplot(Sum, aes(x =    Timepoint,
                y =    Mean,
                color = Group)) +
    geom_errorbar(aes(ymin=Percentile.lower,
                      ymax=Percentile.upper),
                   width=.2, size=0.7, position=pd) +
    geom_point(shape=15, size=4, position=pd) +
    theme_bw() +
    theme(axis.title = element_text(face = "bold")) +
    ylab("NPX") + 
  guides(fill=guide_legend(title="Cohort")) +
    scale_color_manual(values = c("#00AFBB", "deeppink2")) +
  stat_compare_means(aes(group = Group), label = "p.signif", size =3, method = "wilcox.test")
  

  
 stat_compare_means(method = "wilcox.test", size = 3)  
```

Plot chunk `singletrajgroups, fig.width=10, fig.height=7` — simulated
object(s):
`PROBC, p, df, title, subtitle, color, df_plot, p03, x, p04, j`

``` r
# ---- Source: SAP_NUMAB_01.Rmd | chunk: singletrajgroups,  fig.width=10, fig.height=7 ----
j = "Olink Immune Response"
for (i in "IL6") {
  cat("\n\n### ", "Panel: ", j, " NPX trajectories over timepoints - Assay: ", i, "\n")
    df_plot <- PROBC %>% dplyr::arrange(PPID, Time)  %>% dplyr::filter((Panel %in% j) &
                                                                         (Assay %in% i))
    df_plot$Time <- as.factor(df_plot$Time)
    df_plot$PPID <- as.factor(df_plot$PPID)
    
 

    
 p03 <- ggplot(df_plot, aes(x = Time, y = NPX)) +
      geom_point(aes(group = PPID, color = PPID)) +
      geom_line(aes(group = PPID, color = PPID)) +
      geom_smooth(method = "loess", se = FALSE) +
      labs(
        x = "Timepoint (day)",
        y = "NPX",
        title = paste0(unique(df_plot$Panel), "- NPX trajectories over timepoints"),
        subtitle = i
      ) + facet_wrap(~ Group) +
      theme_bw() 
    
p04 <-    ggplot(df_plot, aes(Timepoint, NPX)) +
      geom_line(aes(group = PPID, color = PPID)) +
      geom_point(aes(color = PPID, shape = PPID)) +
      geom_smooth(method = "loess")  +
      scale_x_discrete(drop = F, breaks = unique(df_plot$Time)) +
      labs(
        x = "Timepoint (day)",
        y = "NPX",
        title = unique(df_plot$Panel),
        subtitle = paste0(i, "- Distribution of NPX over timepoints. 
                          \n Blue curve and the grey shade showing the trend line of all trajectoriesand and its Confidence Interval")
      ) + facet_wrap(~ Group) +
      theme_bw()  



print(p03)

# cat("\n")
}
```

Plot chunk `wiltestplot, fig.width=10, fig.height=6, fig.cap = ""` —
simulated object(s):
`PROBC, p, df, title, type, test, color, df_plot, x, j, colours1, Wilcox_plot, axis.title, axis.title.y, axis.title.x, axis.text.x, legend.position, legend.title, legend.text, strip.text, legend.background, legend.box`

``` r
# ---- Source: SAP_NUMAB_01.Rmd | chunk: wiltestplot, fig.width=10, fig.height=6, fig.cap = "" ----

colours1 = c("B1" = "steelblue", "B2" = "deeppink2")

j = "Olink Inflammation"
i = "IL6"
 
df_plot <- PROBC %>% dplyr::arrange(PPID, Time)  %>% dplyr::filter((Panel %in% j) &
                                                                         (Assay %in% i))
df_plot$Time <- as.factor(df_plot$Time)
df_plot$PPID <- as.factor(df_plot$PPID)

Wilcox_plot <- df_plot %>% 
  filter(Assay %in% "IL6") %>% 
  ggplot(aes(x = Timepoint, y = NPX, fill = Group)) + 
  geom_boxplot() + 
    #  geom_violin() +
  geom_jitter(shape = 16, position = position_jitter(0.07)) +
  scale_fill_manual(values = colours1) +
  scale_color_manual(values = colours1) +
   theme_bw() +
   theme(axis.text = element_text(size = 12),
         axis.title = element_text(size = 14),
          axis.title.y = element_text(angle=90,vjust =2),
          axis.title.x = element_text(vjust = -0.2),
         axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
         legend.position = "top",
         legend.title = element_text(face = "bold", size = 12),
         legend.text = element_text(size = 12),
         strip.text = element_text(size = 12, face = "bold"),
         legend.background = element_rect(size=.5, linetype="solid", color = "black"),
         legend.box = "vertical") + labs(x="Timepoint, days", 
        y="NPX", 
        fill="Cohort", 
        ) +
  guides(fill=guide_legend(title="Cohort")) +
    stat_compare_means(label = "p.signif", method = "anova",
                      ref.group = ".all.") +
   stat_compare_means(method = "wilcox.test")  

#+  facet_wrap(~ Timepoint, ncol = 3) 
    print(Wilcox_plot)
```

Plot chunk
`lmerplot, fig.width=10, fig.height=6, fig.cap = "Point-range plot for LMER"`
— simulated object(s):
`PROBC, p, df, random, x, col, plot, variable, x_axis_variable, col_variable`

``` r
# ---- Source: SAP_NUMAB_01.Rmd | chunk: lmerplot, fig.width=10, fig.height=6, fig.cap = "Point-range plot for LMER" ----
if (requireNamespace("lme4", quietly = TRUE) & requireNamespace("lmerTest", quietly = TRUE)){
  PROBC$Timepoint <-factor(PROBC$Timepoint)
  plot <- olink_lmer_plot(df = PROBC, 
                          olinkid_list = c("OID00936", "OID00937"), 
                          variable = c('Timepoint', 'Group'), 
                          x_axis_variable =  'Timepoint',
                          col_variable = 'Group',
                          random = 'PPID')
  plot[[1]]
}
```

Plot chunk
`Heatmap, fig.width=10, fig.height=6, fig.cap = "Heatmap showing the expression of proteins of interest across the Group"`
— simulated object(s):
`PROBC, dat, p, data, x, plot, variable, first10, first15samples, npx_data_small`

``` r
# ---- Source: SAP_NUMAB_01.Rmd | chunk: Heatmap, fig.width=10, fig.height=6, fig.cap = "Heatmap showing the expression of proteins of interest across the Group" ----
first10 <- PROBC %>%
  pull(OlinkID) %>% 
  unique() %>% 
  head(10)

first15samples <- PROBC$SampleID %>% 
  unique() %>% 
  sample(15)

npx_data_small <- PROBC %>% 
  filter(!str_detect(SampleID, 'CONT')) %>% 
  filter(OlinkID %in% first10) %>% 
  filter(SampleID %in% first15samples)


try({ #This statement might fail if dependencies are not installed
  olink_heatmap_plot(npx_data_small, variable_row_list =  'Group')
  })
```
