# Best Practices for Olink Protein Biomarker Discovery and Validation

## Abstract

Olink’s Proximity Extension Assay (PEA) has become a leading platform
for high-throughput, high-sensitivity protein quantification in clinical
cohort studies. Its core technology — pairs of oligonucleotide-labeled
antibodies whose DNA strands hybridize and are extended upon proximal
binding — enables multiplexed detection of 92 to over 5,400 proteins
from minimal sample volumes (~1 µL of plasma), with readout by qPCR or
NGS yielding Normalized Protein eXpression (NPX) values on a log₂ scale.
This guide provides a practical, end-to-end roadmap for Olink-based
biomarker discovery, covering study design, quality control,
differential expression, machine learning, multi-protein signature
construction, functional interpretation, and reporting standards. Every
section is written specifically for the Olink practitioner, with code
examples drawn from the **OlinkViz** package and its bundled datasets.

------------------------------------------------------------------------

## 1. Introduction

### 1.1 The PEA Technology

The proximity extension assay (PEA) couples pairs of
oligonucleotide-labeled antibodies that bind adjacent epitopes on a
target protein. When both antibodies bind, their DNA strands hybridize
and are extended by a DNA polymerase, creating a PCR-amplifiable
amplicon unique to each protein. Quantification is performed by qPCR
(Olink Target 96, Target 48) or NGS (Olink Explore), yielding **NPX
values** — normalized log₂-transformed relative protein concentrations.

Key properties that shape the downstream analytical strategy:

- **NPX is on log₂ scale**: Differences between groups are directly
  interpretable as log₂ fold changes. An NPX difference of +1 equals a
  2-fold higher concentration; a difference of −0.58 equals
  approximately 0.67-fold (two-thirds).
- **One assay = one protein**: Unlike discovery proteomics, there is no
  peptide identification, protein inference, or parsimony grouping step.
  Each Olink assay maps to a single, pre-validated protein target.
- **Missing values are predominantly MNAR** (missing not at random):
  proteins fall below the assay’s limit of detection (LOD) because their
  true concentration is low. This has specific implications for
  imputation (see Section 3.5).
- **High sensitivity, wide dynamic range**: ~10 logs from fM to µM, with
  intra-assay CVs of 5–15% and inter-assay CVs of 10–25%.
- **Panel-based coverage**: Proteins are measured in pre-defined panels
  (Inflammation, Immune Response, Cardiometabolic, Neurology, Oncology,
  and the broader Explore panels). This is efficient but means pathway
  enrichment must account for the panel’s gene-set composition (see
  Section 7.1).

### 1.2 Olink Platforms at a Glance

| Platform | Readout | Proteins | Typical Use |
|----|----|----|----|
| **Target 96** | qPCR (Fluidigm BioMark) | 92 per panel | Focused hypothesis testing, targeted panels |
| **Target 48** | qPCR | 44 per panel | Custom mini-panels, signature validation |
| **Explore 384** | NGS (Illumina NovaSeq) | ~368 | Expanded discovery |
| **Explore 1536** | NGS | ~1,472 | Broad discovery |
| **Explore 3072** | NGS | ~2,944 | Comprehensive plasma proteome |
| **Explore HT** | NGS | ~5,400 | Largest PEA panel; proteome-wide |

### 1.3 What This Guide Covers

- **Study design**: Sample sizes, power, the three-phase biomarker
  framework
- **Data preprocessing**: QC, normalization, replicate handling, missing
  value imputation
- **Differential expression**: Test selection, multiple testing
  strategy, confounder adjustment
- **Machine learning**: Nested cross-validation, algorithm selection,
  feature stability
- **Signature building**: Composite scores, ROC evaluation, reporting
  standards
- **Functional interpretation**: Pathway enrichment with panel-aware
  backgrounds
- **Reproducibility**: Reporting standards and project structure

------------------------------------------------------------------------

## 2. Study Design

### 2.1 The Three-Phase Biomarker Development Framework

Protein biomarker development, regardless of measurement platform,
follows a well-characterized three-phase pipeline. Each phase serves a
distinct purpose and uses progressively stricter statistical thresholds:

    ┌─────────────────────┐    ┌──────────────────────┐    ┌──────────────────────┐
    │  Phase 1: Discovery │ →  │ Phase 2: Verification │ →  │ Phase 3: Validation  │
    │  n = 20-100/group   │    │  n = 100-500/group     │    │  n = 500-5,000+/group│
    │  Broad panels       │    │  Focused panel/custom  │    │  Custom targeted     │
    │  Liberal thresholds │    │  FDR < 0.05            │    │  Strict significance │
    │  Goal: include      │    │  Independent cohort    │    │  Multi-site cohorts  │
    └─────────────────────┘    └──────────────────────┘    └──────────────────────┘

#### Phase 1: Discovery

- **Sample size**: 20–100 per group. Small N risks false negatives;
  large N without adequate power planning risks identifying
  statistically significant but biologically irrelevant differences. Use
  prospective power calculations (Section 2.2).
- **Panel selection**: Choose the broadest panel(s) relevant to your
  disease biology. For inflammatory or autoimmune conditions, combine
  Olink Target 96 Inflammation + Immune Response (184 proteins). For
  broader discovery or hypothesis-free work, use Explore 1536, 3072, or
  HT.
- **Statistical approach**: Use a liberal threshold — nominal p \< 0.05
  without correction, or a relaxed FDR of 10–20%. The goal is
  **sensitivity**: include as many true candidates as possible.
  Specificity will be handled in later phases.
- **Fold-change filter**: Require a minimum effect size (e.g.,
  \|log₂FC\| \> 0.5, ~1.4-fold). This eliminates proteins with
  statistically detectable but biologically trivial differences.
- **Output**: A ranked candidate list of 15–50 proteins.

``` r

# Phase 1 discovery with OlinkViz
library(OlinkViz)
library(dplyr)

data("bansal_baseline57")

# Per-protein Wilcoxon: Healthy vs Long COVID
long_data <- bansal_baseline57 %>%
  filter(`Long_COVID status` %in% c("Healthy", "Long COVID"))

discovery_results <- lapply(unique(long_data$Assay), function(prot) {
  sub <- long_data %>% filter(Assay == prot)
  test <- wilcox.test(
    NPX ~ `Long_COVID status`,
    data = sub,
    exact = FALSE
  )
  data.frame(
    Assay  = prot,
    p.value = test$p.value,
    mean_healthy = mean(sub$NPX[sub$`Long_COVID status` == "Healthy"], na.rm = TRUE),
    mean_lc      = mean(sub$NPX[sub$`Long_COVID status` == "Long COVID"], na.rm = TRUE)
  )
}) %>% bind_rows()

discovery_results$log2FC <- discovery_results$mean_lc - discovery_results$mean_healthy

# Phase 1 filters: nominal p < 0.05, |log2FC| > 0.5
candidates <- discovery_results %>%
  filter(p.value < 0.05, abs(log2FC) > 0.5) %>%
  arrange(p.value)

plot_volcano(discovery_results, title = "Phase 1: Discovery")
```

#### Phase 2: Verification

- **Sample size**: 100–500 per group, drawn from an **independent
  cohort**. This is the single most important step for eliminating false
  discoveries.
- **Approach**: Test only the candidate proteins from Phase 1. If using
  Olink Target 96, you may design a custom panel or measure candidates
  via individual assays. For Explore datasets, subset the analysis to
  the candidate list.
- **Statistical threshold**: Apply Benjamini-Hochberg FDR correction at
  FDR \< 0.05. All candidates passing this threshold advance to Phase 3.
- **Output**: A refined list of 5–15 proteins.

``` r

# Phase 2 runs on an independent dataset
candidates_verified <- candidates %>%
  mutate(p_adj = p.adjust(p.value, method = "BH")) %>%
  filter(p_adj < 0.05)
```

#### Phase 3: Clinical Validation

- **Sample size**: 500–5,000+, ideally multi-site with broad demographic
  representation.
- **Approach**: Pre-specify the full analysis — the protein signature
  from Phase 2, the statistical model, thresholds, and clinical
  endpoint. Register the analysis plan (ClinicalTrials.gov or OSF)
  before execution.
- **Output**: A validated biomarker signature with sensitivity,
  specificity, PPV, and NPV estimated in the target population.

### 2.2 Sample Size and Power

Power calculations for Olink studies must account for:

- **Multiple testing burden**: For a Target 96 panel (92 proteins),
  Bonferroni correction requires α = 0.05/92 ≈ 5.4 × 10⁻⁴ per protein.
  In practice, use BH-FDR at 5% for verification/validation phases.
- **Realistic effect sizes**: Clinically meaningful plasma protein
  differences are often modest — 1.2–1.8 fold (log₂FC = 0.26–0.85).
  Power calculations should use effect sizes drawn from prior
  literature, not optimistic guesses.
- **Olink CVs**: Intra-assay CV 5–15%, inter-assay CV 10–25%. Use the
  upper bound for conservative planning.

Practical sample-size guidelines for Olink Target 96 discovery (80%
power, α = 0.05, two-sided two-sample t-test):

| Target fold change | log₂FC | N per group |
|--------------------|--------|-------------|
| 1.2-fold           | ~0.26  | ~90         |
| 1.5-fold           | ~0.58  | ~25         |
| 2.0-fold           | ~1.0   | ~10         |

For FDR-controlled analysis across 92 proteins, multiply per-group N by
~1.5–2×. For Explore 3072, use BH-FDR throughout and increase sample
sizes proportionally.

------------------------------------------------------------------------

## 3. Data Preprocessing and Quality Control

### 3.1 Olink Data Structure

Olink delivers data in a standardized long format. The key columns are:

| Column | Description | Common Names |
|----|----|----|
| `SampleID` | Unique sample identifier | SampleID, SubjectID, Participant |
| `Assay` | Protein/gene name | Assay, Protein, Target |
| `NPX` | Normalized log₂ protein expression | NPX, Value |
| `Panel` | Olink panel name | Panel |
| `LOD` | Limit of detection | LOD |
| `QC Warning` | Quality flag | QC Warning, Warning |

OlinkViz detects these columns automatically via `detect_columns()` and
validates the data structure with
[`validate_npx()`](https://vanhungtran.github.io/OlinkViz/reference/validate_npx.md).

### 3.2 Quality Control

#### 3.2.1 Visual QC First — Before Any Statistical Test

The first step in every Olink analysis is a visual survey of the data.
Batch effects, whether from plates, reagent lots, or run order, are the
\#1 cause of false discoveries.

``` r

# PCA colored by potential sources of unwanted variation
plot_dim_reduc(my_data, type = "pca", color = "Plate")
plot_dim_reduc(my_data, type = "pca", color = "Panel")
plot_dim_reduc(my_data, type = "pca", color = "Group")

# Heatmap of top variable proteins — reveals outlier samples at a glance
plot_heatmap(my_data, scale = "row", show_rownames = FALSE)

# Sample correlation — detects swaps and gross outliers
plot_corr(my_data, method = "spearman", top_n = 50)
```

#### 3.2.2 Sample-Level QC

``` r

sample_qc <- my_data %>%
  group_by(SampleID) %>%
  summarise(
    n_detected   = sum(!is.na(NPX)),
    n_total      = n(),
    frac_missing = mean(is.na(NPX)),
    mean_npx     = mean(NPX, na.rm = TRUE),
    sd_npx       = sd(NPX, na.rm = TRUE),
    .groups = "drop"
  )

# Flag samples with >30% missing or mean NPX > 3 SD from grand mean
grand_mean <- mean(sample_qc$mean_npx, na.rm = TRUE)
grand_sd   <- sd(sample_qc$mean_npx, na.rm = TRUE)
flagged <- sample_qc %>%
  filter(frac_missing > 0.30 | abs(mean_npx - grand_mean) > 3 * grand_sd)
```

#### 3.2.3 Protein-Level QC

Proteins with a high proportion of values below LOD need careful
handling:

| Fraction below LOD | Action |
|----|----|
| **\>50%** | Consider exclusion (insufficient dynamic range); retain only if biologically essential |
| **20–50%** | Retain, with left-censored imputation (Section 3.5) |
| **\<20%** | Retain with standard handling |

``` r

protein_qc <- my_data %>%
  group_by(Assay) %>%
  summarise(
    n_below_lod    = sum(NPX < LOD, na.rm = TRUE),
    frac_below_lod = mean(NPX < LOD, na.rm = TRUE),
    mean_npx       = mean(NPX, na.rm = TRUE),
    cv             = sd(NPX, na.rm = TRUE) / abs(mean(NPX, na.rm = TRUE)),
    .groups = "drop"
  )
```

### 3.3 Normalization

Olink NPX values are already normalized during the NPX Manager pipeline
(extension control normalization, inter-plate adjustment, and log₂
transformation). **Do not apply additional normalization unless a
specific batch effect is visually confirmed.**

When batch effects are present despite Olink’s internal normalization
(e.g., different reagent lots, plate effects identifiable on PCA),
consider:

1.  **Including batch as a model covariate** — the preferred approach.
    Add `+ Plate` or `+ Batch` to your statistical model rather than
    pre-correcting the data. This preserves biological signal while
    adjusting for technical variation.
2.  **ComBat** (`sva::ComBat()`) — parametric batch correction for when
    the model-inclusion approach isn’t feasible. Requires adequate
    sample size per batch.
3.  **[`limma::removeBatchEffect()`](https://rdrr.io/pkg/limma/man/removeBatchEffect.html)**
    — use only for visualization, not as input to downstream statistical
    tests.

**Always** compare PCA plots before and after any batch correction. A
correction that collapses genuine biological separation alongside batch
effects has done more harm than good.

### 3.4 Replicate Measurements

- **Intra-assay replicates** (same plate): Average NPX values. Report
  the CV.
- **Inter-assay replicates** (different plates/runs): Average after
  confirming acceptable CV (\<25%), or use a mixed-effects model with
  plate as a random effect.

OlinkViz’s
[`to_wide()`](https://vanhungtran.github.io/OlinkViz/reference/to_wide.md)
averages replicates automatically:

``` r

wide <- to_wide(my_data)
# Auto-detected columns: sample_col = 'SampleID'
# Averaged 8 replicate(s) across 2 plate(s)
```

### 3.5 Missing Value Imputation

Missing values in Olink data are predominantly **MNAR** (missing not at
random): the protein concentration is below the assay’s LOD. This is
fundamentally different from stochastic missingness and requires a
different imputation approach.

#### Imputation Methods (Ordered by Preference for Olink Data)

1.  **Down-shift imputation** (recommended): Draw from a Gaussian
    centered at (LOD − 1.8σ) with σ = 0.3 × SD(observed values). This
    preserves the left-censored structure of the data.
2.  **Minimal value replacement**: Replace with LOD or LOD/√2. Simple,
    conservative, widely used in the Olink literature.
3.  **Quantile regression imputation** (`imputeLCMD`): More
    sophisticated, dataset-adaptive left-censored imputation.
4.  **KNN imputation**: Only for technical (MCAR) missingness — e.g., a
    sample with a processing error. Do not use for values below LOD.

**Never use mean imputation.** It systematically overestimates
low-abundance proteins — the proteins most likely to differ between
disease states — and attenuates fold changes exactly where they matter
most.

``` r

impute_left_censored <- function(npx_values, lod_values) {
  below <- which(npx_values < lod_values)
  if (length(below) == 0) return(npx_values)

  observed <- npx_values[npx_values >= lod_values]
  sd_obs <- sd(observed, na.rm = TRUE)

  set.seed(42)
  imputed_values <- rnorm(
    length(below),
    mean = lod_values[below] - 1.8 * sd_obs,
    sd   = 0.3 * sd_obs
  )
  npx_values[below] <- imputed_values
  npx_values
}
```

------------------------------------------------------------------------

## 4. Statistical Analysis

### 4.1 Choosing the Right Test

| Scenario | Recommended Method | Notes |
|----|----|----|
| Two-group, n \< 20/group | Wilcoxon rank-sum | Robust to non-normality; `exact = FALSE` |
| Two-group, n ≥ 20/group | Moderated t-test (`limma`) | Gold standard — borrows strength across proteins |
| Paired / longitudinal | Linear mixed model (`lmer`) | Random intercept per subject; handles missing visits |
| Multi-group | Kruskal-Wallis or one-way ANOVA | Follow with pairwise post-hoc tests |
| Continuous outcome | Spearman correlation or linear regression | `NPX ~ clinical_variable` |
| Adjusted analysis | `limma` or ANCOVA with covariates | `~ group + age + sex + bmi` |

**Moderated t-tests via limma** are the gold standard for Olink
differential expression. By borrowing variance information across all
proteins on the panel, limma produces stable variance estimates even
when n per group is small — a common scenario in Olink studies where n =
10–30 per group is typical.

``` r

library(limma)

# Prepare wide matrix: rows = proteins, columns = samples
wide_matrix <- to_wide(my_data) %>%
  tibble::column_to_rownames("Assay") %>%
  as.matrix()

# Design matrix
group <- factor(col_data$Group)
design <- model.matrix(~ group)

# Fit and moderate
fit <- lmFit(wide_matrix, design)
fit <- eBayes(fit)

# Extract results
results <- topTable(fit, coef = 2, number = Inf, adjust.method = "BH")

# Visualize
plot_volcano(results, pval_col = "adj.P.Val", fc_col = "logFC",
             title = "limma: Differential Expression")
```

### 4.2 Multiple Testing Strategy by Phase

The appropriate correction depends on the study phase — do not apply the
same threshold everywhere:

| Phase | Correction | Rationale |
|----|----|----|
| **Discovery** | Nominal p \< 0.05, or relaxed FDR 10–20% | Maximize sensitivity; false positives are filtered in verification |
| **Verification** | BH-FDR \< 0.05 | Balance; independent cohort adds protection |
| **Validation** | BH-FDR \< 0.05 or Bonferroni | Pre-specified analysis; strict control required |
| **Exploratory** | Report nominal and adjusted | Full transparency |

**Common pitfall**: Applying Bonferroni correction to a Phase 1
discovery study with 184 proteins (two Target 96 panels). This
eliminates most true positives while only marginally improving
specificity — directly defeating the purpose of a discovery phase.

### 4.3 Interpreting Fold Changes in NPX Space

Because NPX is on log₂ scale, the difference between two group means
**is** the log₂ fold change:

- `mean_NPX_case − mean_NPX_control = +1.0` → 2× higher in cases
- `mean_NPX_case − mean_NPX_control = +0.58` → 1.5× higher
- `mean_NPX_case − mean_NPX_control = −1.0` → 0.5× (half) in cases
- `mean_NPX_case − mean_NPX_control = −0.58` → ~0.67× (two-thirds) in
  cases

Use **both** statistical significance and biological significance (fold
change) for candidate prioritization:

- **\|log₂FC\| \> 0.5** (~1.4-fold): Minimum meaningful change for most
  plasma proteins.
- **\|log₂FC\| \> 1.0** (2-fold): Strong effect — prioritize for
  verification.
- **Detected in one group, below LOD in the other**: Biologically
  meaningful even if the numerical NPX difference is small — flag
  separately; do not let the small numerical delta bury this signal.

### 4.4 Confounders and Covariate Adjustment

Plasma protein levels are influenced by more than disease status. Common
confounders in Olink studies:

| Category | Variables |
|----|----|
| **Demographic** | Age, sex, BMI |
| **Pre-analytical** | Fasting status, time of day, anticoagulant (EDTA vs. citrate vs. heparin), storage duration, freeze-thaw cycles |
| **Clinical** | Comorbidities, medications, disease severity |
| **Technical** | Plate, plate position, run order, reagent lot |

**Workflow**: 1. Record all potential confounders at sample collection.
2. Check for imbalance between groups (t-test, chi-squared). 3. Adjust
for imbalanced covariates in the model:
`~ group + age + sex + bmi + Plate`. 4. Report unadjusted and adjusted
results; concordance strengthens confidence.

------------------------------------------------------------------------

## 5. Machine Learning for Biomarker Discovery

### 5.1 Nested Cross-Validation

The most consequential statistical error in biomarker discovery is
reporting model performance evaluated on the same data used for feature
selection and training. This produces catastrophically overfitted AUC
estimates — an AUC of 0.95 from a study that selected features and
evaluated the model on the same N = 30 samples is not impressive; it is
expected under random chance alone.

The solution is **nested (double) cross-validation**:

    Outer CV loop (5-fold): estimate generalization performance
      ├─ Inner CV loop (3-5 fold): select features and tune hyperparameters
      │   ├─ Feature selection (e.g., top-k by t-test, or L1 regularization)
      │   ├─ Model training with selected features
      │   └─ Hyperparameter tuning
      └─ Evaluate on held-out outer fold
    → Report mean ± SD of outer-fold AUC

``` r

library(caret)

ctrl <- trainControl(
  method = "repeatedcv",
  number = 5,
  repeats = 5,
  search = "grid"
)

set.seed(123)
lasso_fit <- train(
  x = wide_matrix,
  y = factor(group_labels),
  method = "glmnet",
  trControl = ctrl,
  tuneLength = 20
)
```

**Red flag**: Any study reporting a biomarker panel discovered and
evaluated on the same samples without nested CV or an independent
validation cohort is presenting performance estimates that are
systematically and often dramatically inflated.

### 5.2 Algorithm Selection for Olink

| Algorithm | Strengths | When to Use |
|----|----|----|
| **Lasso (L1)** | Built-in feature selection; interpretable coefficients | Typical Olink: p = 92–184, n = 50–200 |
| **Elastic Net** | Handles correlated predictors well | When proteins co-vary strongly (common in Olink panels) |
| **Random Forest** | Captures non-linear relationships; robust to outliers | Larger n; pair with permutation importance |
| **SVM (RBF)** | Effective with small n and complex boundaries | Two-group classification with n \< 50/group |
| **Penalized logistic regression** | Well-calibrated probabilities; interpretable ORs | Case-control designs where interpretability matters |

### 5.3 Panel-Aware Feature Selection

Olink panels contain groups of functionally related proteins (e.g.,
multiple chemokines in the Inflammation panel). Two practical
considerations:

- **Correlation-aware selection**: Lasso selects one representative from
  each correlated group. Elastic net retains the group. Choose based on
  whether you want a minimal signature (Lasso) or a redundant, robust
  one (Elastic Net).
- **Stability analysis**: Run feature selection on 100 bootstrap
  resamples; report how often each protein is selected. Proteins
  selected in \>50% of resamples are stable candidates.
- **Panel dominance check**: If using multiple panels (e.g.,
  Inflammation + Immune Response), verify the final signature isn’t
  dominated by one panel — this may indicate a panel-level batch
  artifact.

------------------------------------------------------------------------

## 6. Multi-Protein Signatures

### 6.1 Building a Composite Score

Individual proteins rarely provide sufficient discriminatory power for
clinical use. A multi-protein composite score almost always outperforms
any single marker.

#### Approach 1: Sign-Weighted Z-Score Sum

For each protein, compute a z-score within the cohort, multiply by +1
(higher in disease) or −1 (lower in disease), then sum across the
signature. This approach is simple, requires no model training, and is
used in the OlinkViz paper-inspired workflows:

``` r

# Step 1: Determine direction from univariate AUC
prot_direction <- bansal_baseline57 %>%
  filter(`Long_COVID status` %in% c("Healthy", "Long COVID")) %>%
  group_by(Assay) %>%
  summarise(
    auc = as.numeric(pROC::auc(
      pROC::roc(as.integer(`Long_COVID status` == "Long COVID"), NPX, quiet = TRUE)
    )),
    direction = ifelse(auc >= 0.5, 1, -1),
    .groups = "drop"
  )

# Step 2: Compute z-scores and aggregate
signature_proteins <- c("CXCL10", "IL6", "CCL2", "TNF", "IFNG")
signature_scores <- bansal_baseline57 %>%
  filter(Assay %in% signature_proteins) %>%
  left_join(prot_direction, by = "Assay") %>%
  group_by(Assay) %>%
  mutate(z_npx = as.numeric(scale(NPX))) %>%
  group_by(SampleID, `Long_COVID status`) %>%
  summarise(
    signature_score = sum(direction * z_npx, na.rm = TRUE),
    .groups = "drop"
  )
```

#### Approach 2: Model-Weighted Score

Use coefficients from a fitted model (lasso, elastic net, or logistic
regression) as weights:

``` r

sig_data <- wide_matrix[, signature_proteins]
fit <- glm(group_labels ~ ., data = as.data.frame(sig_data), family = binomial)
composite_score <- predict(fit, newdata = as.data.frame(sig_data), type = "link")
```

#### Approach 3: PCA-Based Score

Use PC1 of the signature proteins as the composite score. This captures
the dominant co-variation pattern without requiring outcome labels, but
loses directionality — the sign of PC1 is arbitrary.

### 6.2 Evaluating Signature Performance

For individual proteins or pre-computed signature scores,
[`plot_roc()`](https://vanhungtran.github.io/OlinkViz/reference/plot_roc.md)
draws empirical or binormal-smoothed ROC curves with DeLong 95% CIs and
optional bootstrap sensitivity ribbons (`add_ci = TRUE`,
`smooth_method = "binormal"`):

``` r

library(pROC)

# Multi-protein smoothed ROC curves with 95% bootstrap sensitivity ribbons
plot_roc(
  bansal_baseline57[bansal_baseline57$`Long_COVID status` %in% c("Healthy", "Long COVID"), ],
  assays        = c("CXCL10", "IL6", "CCL2", "TNF"),
  group         = "Long_COVID status",
  smooth_method = "binormal",
  add_ci        = TRUE,
  show_direction = TRUE
)

roc_obj <- pROC::roc(
  signature_scores$`Long_COVID status` == "Long COVID",
  signature_scores$signature_score
)
plot(roc_obj, main = "Signature ROC", print.auc = TRUE, print.auc.cex = 1.2)
```

**Minimum reporting standards for a biomarker signature:** - AUC with
95% CI (DeLong method) - Sensitivity, specificity, PPV, and NPV at the
Youden-optimal threshold - The same metrics at one or more
pre-specified, clinically motivated thresholds - Explicit statement if
the threshold was optimized on the evaluation data - For Phase 3:
pre-registration of the analysis plan

------------------------------------------------------------------------

## 7. Functional Interpretation

### 7.1 Pathway Enrichment — Panel-Aware Background

OlinkViz provides
[`enrich_pathways()`](https://vanhungtran.github.io/OlinkViz/reference/enrich_pathways.md),
a wrapper around gProfiler2 supporting GO, KEGG, Reactome, and
WikiPathways:

``` r

de_proteins <- discovery_results %>%
  filter(p.value < 0.05) %>%
  pull(Assay)

enrichment <- enrich_pathways(
  de_proteins,
  sources = c("GO:BP", "KEGG", "REAC"),
  p_cutoff = 0.05
)
```

**Critical**: Olink panels are not random samples of the proteome. Each
panel is designed around a biological theme — the Inflammation panel is
enriched for chemokines, cytokines, and acute phase proteins. If you
test inflammatory-disease DE proteins against the whole-genome
background, every immune-related pathway will appear highly significant
because your input list is pre-enriched for it.

**Solution**: Supply the full Olink panel gene list as the custom
background (`custom_bg` argument in `gost()`). This asks: “Among the
proteins we actually measured, which pathways are over-represented in
the DE set?” rather than the misleading “Among all ~20,000 human genes,
which pathway terms appear?”.

### 7.2 Protein-Protein Interaction Networks

``` r

# STRING PPI network
plot_network(de_proteins[1:30], required_score = 500)

# Correlation-based network
plot_corr(my_data, top_n = 25, display_method = "color")
```

### 7.3 Clinical Variable Correlations

Linking Olink protein levels to clinical measurements — vital signs, lab
values, disease severity scores — establishes face validity and suggests
functional relevance. See `scripts/generate_figures_jir.R` for a
complete worked example from the Tan et al. (2025) AMI biomarker
template.

------------------------------------------------------------------------

## 8. Reproducibility and Reporting Standards

### 8.1 Minimum Reporting Checklist

1.  **Pre-analytical**
    - Sample type, collection tube, anticoagulant
    - Centrifugation, time to freezer, storage temperature and duration
    - Freeze-thaw cycles, fasting status
2.  **Olink assay**
    - Panel name(s), version, lot number
    - Platform and readout method
    - Number of plates, plate layout, randomization scheme
    - Internal control performance (Incubation, Detection, Extension
      controls)
3.  **Data processing**
    - Software version (NPX Manager or Olink Analyze)
    - QC exclusion criteria for samples and assays
    - Missing value handling: proportion below LOD per assay, imputation
      method
    - Batch correction method (if any)
4.  **Statistical analysis**
    - Statistical test and rationale
    - Multiple testing correction
    - Covariates in adjusted models
    - Software: R version, package versions
      ([`sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html))
5.  **Biomarker evaluation** (Phase 2–3)
    - Pre-specified analysis plan (registration recommended)
    - Sample size justification
    - Model features, training procedure, threshold selection
    - Validation strategy: CV scheme (internal), independent cohort
      (external)
    - Performance metrics with confidence intervals

### 8.2 Reproducible Project Structure

    my_olink_study/
    ├── data/
    │   ├── raw/           # Untouched Olink NPX Manager exports
    │   └── processed/     # QC'd, imputed, normalized data
    ├── scripts/
    │   ├── 01_qc.R
    │   ├── 02_preprocess.R
    │   ├── 03_differential_expression.R
    │   ├── 04_biomarker_modeling.R
    │   └── 05_figures.R
    ├── output/
    │   ├── figures/
    │   └── tables/
    ├── renv.lock          # Package version control
    └── my_olink_study.Rproj

End every analysis with
[`sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html).

------------------------------------------------------------------------

## 9. Common Pitfalls

| Pitfall | Consequence | Solution |
|----|----|----|
| **Using t-test with n = 3/group** | No variance estimation; p-values meaningless | Moderated t-test (limma) or Wilcoxon for n \< 10 |
| **No covariate adjustment** | Spurious associations from age/sex/BMI confounding | Record and adjust for known confounders |
| **Overfitting in small samples** | “AUC = 0.99” that vanishes on replication | Nested CV; external validation cohort |
| **Whole-genome background for enrichment** | Inflated significance for panel-relevant pathways | Use Olink panel gene list as enrichment background |
| **Mean imputation for below-LOD values** | Attenuated fold changes; false negatives | Left-censored imputation (Section 3.5) |
| **Discovery and validation on same samples** | Grossly overestimated performance | Physically separate cohorts, or nested CV at minimum |
| **Bonferroni in Phase 1 discovery** | Eliminated true candidates | Relaxed thresholds in discovery; correct in verification |
| **Treating NPX as linear concentration** | Misinterpreted fold changes | NPX is log₂: differences ARE log₂ fold changes |
| **Comparing NPX across panel versions without bridging** | Apparent differences are platform artifacts | Bridging study with overlapping samples |

------------------------------------------------------------------------

## 10. Practical Workflow

``` r

library(OlinkViz)
library(ggplot2)
library(dplyr)
library(tidyr)
library(pROC)

# 1. Load and inspect
data("bansal_baseline57")
validate_npx(bansal_baseline57)

# 2. QC
plot_dim_reduc(bansal_baseline57, type = "pca", color = "Panel", ellipse = TRUE)
plot_heatmap(bansal_baseline57, scale = "row", show_rownames = FALSE)

# 3. Differential expression
long_data <- bansal_baseline57 %>%
  filter(`Long_COVID status` %in% c("Healthy", "Long COVID"))

de_results <- long_data %>%
  group_by(Assay) %>%
  summarise(
    p.value = wilcox.test(NPX ~ `Long_COVID status`, exact = FALSE)$p.value,
    mean_hc = mean(NPX[`Long_COVID status` == "Healthy"], na.rm = TRUE),
    mean_lc = mean(NPX[`Long_COVID status` == "Long COVID"], na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    log2FC = mean_lc - mean_hc,
    p_adj  = p.adjust(p.value, method = "BH")
  )

# 4. Volcano plot
plot_volcano(de_results, pval_threshold = 0.05, fc_threshold = 0.5,
             title = "Healthy vs Long COVID")

# 5. Top candidates
top_hits <- de_results %>%
  filter(p_adj < 0.05) %>%
  slice_min(p.value, n = 6)

plot_boxplot(long_data, assay = top_hits$Assay[1], group = "Long_COVID status")
plot_corr(long_data %>% filter(Assay %in% top_hits$Assay),
          method = "spearman", top_n = 20)

# 6. Pathway enrichment
enrich_pathways(
  de_results %>% filter(p.value < 0.05) %>% pull(Assay),
  sources = c("GO:BP", "KEGG")
)

# 7. Signature construction → see scripts/generate_figures_paper.R
```

------------------------------------------------------------------------

## 11. Further Reading

1.  **Al-Nesf et al. (2022)**. Prognostic tools and candidate drugs
    based on plasma proteomics of patients with severe COVID-19
    complications. *Nature Communications*, 13:2406. — Olink-based
    12-protein severity signature with ROC, clustering, and network
    analysis across 893 proteins and three Olink panels.

2.  **Tan et al. (2025)**. Identification of Cardiometabolic Protein
    Biomarkers for Acute Myocardial Infarction Using Olink Proteomics.
    *Journal of Inflammation Research*. — Olink Target 96
    Cardiometabolic panel for AMI biomarker discovery with GO/KEGG
    enrichment, STRING PPI, and combined ROC.

3.  **Assarsson et al. (2014)**. Homogenous 96-Plex PEA Immunoassay
    Exhibiting High Sensitivity, Specificity, and Excellent Scalability.
    *PLOS ONE*, 9(4):e95192. — Foundational PEA technology paper; assay
    performance characteristics, dynamic range, cross-reactivity data.

4.  **Rifai et al. (2006)**. Protein biomarker discovery and validation:
    the long and uncertain path to clinical utility. *Nature
    Biotechnology*, 24(8):971–983. — The canonical three-phase biomarker
    development framework.

5.  **Broadhurst & Kell (2006)**. Statistical strategies for avoiding
    false discoveries in metabolomics and related experiments.
    *Metabolomics*, 2(4):171–196. — Essential reading on multiple
    testing, cross-validation pitfalls, and overfitting in omics
    biomarker studies.

6.  **Lazar et al. (2016)**. Accounting for the Multiple Natures of
    Missing Values in Label-Free Quantitative Proteomics Data Sets to
    Compare Imputation Strategies. *Journal of Proteome Research*,
    15(4):1116–1125. — Framework for choosing imputation methods based
    on missingness mechanism.

7.  **Olink (2023)**. Data normalization and standardization. *Olink
    Proteomics Technical Note*. — NPX normalization pipeline, QC
    metrics, and data interpretation guidelines.

8.  **OlinkViz vignettes**:
    [`vignette("OlinkViz")`](https://vanhungtran.github.io/OlinkViz/articles/OlinkViz.md)
    for the visualization cookbook; `scripts/generate_figures_paper.R`
    and `scripts/generate_figures_jir.R` for end-to-end biomarker
    analysis workflows using the bundled datasets.

------------------------------------------------------------------------

## Session Info

``` r

sessionInfo()
#> R version 4.6.1 (2026-06-24 ucrt)
#> Platform: x86_64-w64-mingw32/x64
#> Running under: Windows 11 x64 (build 26300)
#> 
#> Matrix products: default
#>   LAPACK version 3.12.1
#> 
#> locale:
#> [1] LC_COLLATE=English_Switzerland.utf8  LC_CTYPE=English_Switzerland.utf8   
#> [3] LC_MONETARY=English_Switzerland.utf8 LC_NUMERIC=C                        
#> [5] LC_TIME=English_Switzerland.utf8    
#> 
#> time zone: Europe/Zurich
#> tzcode source: internal
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> loaded via a namespace (and not attached):
#>  [1] digest_0.6.39     desc_1.4.3        R6_2.6.1          fastmap_1.2.0    
#>  [5] xfun_0.60         cachem_1.1.0      knitr_1.51        htmltools_0.5.9  
#>  [9] rmarkdown_2.31    lifecycle_1.0.5   cli_3.6.6         sass_0.4.10      
#> [13] pkgdown_2.2.1     textshaping_1.0.5 jquerylib_0.1.4   systemfonts_1.3.2
#> [17] compiler_4.6.1    tools_4.6.1       ragg_1.5.2        bslib_0.12.0     
#> [21] evaluate_1.0.5    yaml_2.3.12       otel_0.2.0        jsonlite_2.0.0   
#> [25] rlang_1.3.0       fs_2.1.0          htmlwidgets_1.6.4
```
