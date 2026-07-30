# OlinkViz bundled datasets -------------------------------------------------

#' IRIS Long COVID Olink Data
#'
#' Long-format Olink NPX proteomics data from the IRIS Long COVID study.
#' Contains protein expression values for patients with and without long COVID.
#'
#' @format A data.table with 16,000 rows and 7 columns:
#' \describe{
#'   \item{Assay}{Protein assay name}
#'   \item{NPX}{Normalized Protein eXpression value}
#'   \item{Sex}{Biological sex of the subject}
#'   \item{IRIS_number}{Subject identifier}
#'   \item{Panel}{Olink protein panel}
#'   \item{long_covid}{Factor: "Yes" or "No"}
#'   \item{timing_month}{Time point in months}
#' }
#' @source IRIS Long COVID study
"iris_longcovid"


#' PCNSL Plasma Olink Data
#'
#' Wide-format Olink NPX data from the Primary CNS Lymphoma (PCNSL)
#' plasma proteomics study. Samples are rows; protein NPX values are columns.
#'
#' @format A data.table with 172 rows and 1,010 columns:
#' \describe{
#'   \item{sample_id}{Sample identifier}
#'   \item{batch}{Experimental batch (factor)}
#'   \item{replicate_of}{Replicate information}
#'   \item{...}{Remaining columns are protein names with NPX values}
#' }
#' @source Study 20815686
"pcnsl_olink"


#' BeatMG Olink NPX Data
#'
#' Standard Olink NPX output from the BeatMG Myasthenia Gravis study.
#' Long format with protein expression values and QC metadata.
#'
#' @format A data.frame with approximately 112,000 rows and 19 columns:
#' \describe{
#'   \item{SubjectID}{Subject identifier}
#'   \item{SampleID}{Sample identifier}
#'   \item{OlinkID}{Olink protein identifier}
#'   \item{UniProt}{UniProt accession}
#'   \item{Assay}{Protein assay name}
#'   \item{Panel}{Olink panel name}
#'   \item{NPX}{Normalized Protein eXpression value}
#'   \item{...}{Additional QC and metadata columns}
#' }
#' @source BeatMG study
"beatmg_npx"


#' BeatMG Demographics
#'
#' Demographic and clinical annotation data for the BeatMG Myasthenia Gravis
#' study. One row per subject.
#'
#' @format A data.frame with 52 rows and 42 columns:
#' \describe{
#'   \item{SubjectID}{Subject identifier (links to beatmg_npx)}
#'   \item{Age}{Age of subject}
#'   \item{Sex}{Biological sex}
#'   \item{Ethnicity}{Self-reported ethnicity}
#'   \item{...}{Additional clinical and demographic variables}
#' }
#' @source BeatMG study
"beatmg_demo"


#' BeatMG NPX Merged with Demographics
#'
#' BeatMG NPX data left-joined with demographic annotations by SubjectID,
#' carrying clinical context onto every NPX row.
#'
#' @format A data.frame with approximately 112,000 rows and 60 columns.
#'   Combines columns from beatmg_npx and beatmg_demo.
#' @source BeatMG study
"beatmg_npx_merged"


#' Bansal Long COVID Baseline Data
#'
#' Baseline Olink proteomics data from the Bansal & Olechnowicz Long COVID
#' study. Contains 182 protein measurements and clinical variables for 57 subjects.
#'
#' @format A data.table with approximately 10,000 rows and 24 columns,
#'   including clinical variables and NPX values.
#' @source Bansal & Olechnowicz Long COVID study
"bansal_baseline57"


#' Bansal Long COVID Univariate Results
#'
#' Univariate (Wilcoxon) test results comparing protein expression between
#' groups for 182 proteins from the Bansal Long COVID study.
#'
#' @format A data.table with 182 rows and 14 columns of per-protein
#'   statistical test results.
#' @source Bansal & Olechnowicz Long COVID study
"bansal_univariate"


#' Bansal Long COVID Longitudinal Data
#'
#' Paired longitudinal Olink data from 34 subjects in the Bansal Long COVID
#' study. Contains repeated measures across time points.
#'
#' @format A data.table with approximately 18,000 rows and 24 columns.
#' @source Bansal & Olechnowicz Long COVID study
"bansal_longitudinal"


#' Qinfeng Tuberculosis Olink Data
#'
#' Wide-format Olink NPX data from a tuberculosis biomarker discovery study
#' by Qinfeng et al. (2025). Contains 92 protein measurements for 66 subjects.
#'
#' @format A data.table with 66 rows and 97 columns, including SampleID,
#'   92 protein NPX columns, and QC metrics.
#' @source Qinfeng et al. (2025) -- Tuberculosis Biomarkers
"qinfeng_npx"


#' TOFA Down Syndrome Olink Data
#'
#' Long-format Olink NPX data from the Tofacitinib for Immune Skin Conditions
#' in Down Syndrome (TOFA) study. Contains baseline and 16-week measurements.
#'
#' @format A data.table with approximately 454,000 rows and 16 columns:
#' \describe{
#'   \item{subjectid}{Subject identifier}
#'   \item{sampleid}{Sample identifier}
#'   \item{assay}{Protein assay name}
#'   \item{npx}{Normalized Protein eXpression value}
#'   \item{timepoint}{Time point (baseline or week 16)}
#'   \item{...}{Additional metadata columns}
#' }
#' @source TOFA Down Syndrome study
"tofa_data"


#' TOFA Data Dictionary
#'
#' Variable descriptions for the TOFA Down Syndrome Olink dataset.
#'
#' @format A data.table with 15 rows and 3 columns:
#' \describe{
#'   \item{variable}{Variable name}
#'   \item{description}{Human-readable description}
#'   \item{type}{Data type}
#' }
#' @source TOFA Down Syndrome study
"tofa_dictionary"
