# BeatMG Olink NPX Data

Standard Olink NPX output from the BeatMG Myasthenia Gravis study. Long
format with protein expression values and QC metadata.

## Usage

``` r
beatmg_npx
```

## Format

A data.frame with approximately 112,000 rows and 19 columns:

- SubjectID:

  Subject identifier

- SampleID:

  Sample identifier

- OlinkID:

  Olink protein identifier

- UniProt:

  UniProt accession

- Assay:

  Protein assay name

- Panel:

  Olink panel name

- NPX:

  Normalized Protein eXpression value

- ...:

  Additional QC and metadata columns

## Source

BeatMG study (ClinicalTrials.gov NCT02110706). Nowak RJ, et al. (2022).
Phase 2 Trial of Rituximab in Acetylcholine Receptor Antibody-Positive
Generalized Myasthenia Gravis: The BeatMG Study. Neurology.
[doi:10.1212/WNL.0000000000013121](https://doi.org/10.1212/WNL.0000000000013121)
