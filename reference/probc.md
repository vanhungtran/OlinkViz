# Simulated Two-Group Longitudinal Olink Data (NUMAB project B design)

A fully simulated two-group longitudinal Olink dataset with the layout
of the NUMAB project B study: 13 patients per group, visits on days
1-85, and the Olink Target 96 Immune Response and Inflammation panels.
It contains no real patient data. NPX values are generated from patient
random intercepts, group, time and group x time effects (IL6, TNF and
IL8, which newer Olink panels call CXCL8, always carry a group x time
effect), plate offsets and residual noise, with protein- and
plate-specific LODs. Useful for demonstrating longitudinal plot types
(mean profiles, spaghetti, violin, LMER point-range, etc.).

## Usage

``` r
probc
```

## Format

A data.frame with 35,328 rows and 22 columns:

- SampleID:

  Simulated sample identifier

- OlinkID:

  Olink protein identifier

- UniProt:

  UniProt accession

- Assay:

  Protein assay name

- Panel:

  Olink panel name (Inflammation or Immune Response)

- NPX:

  Normalized Protein eXpression value (simulated)

- MaxLOD:

  Assay-specific limit of detection

- PPID:

  Simulated patient identifier

- Timepoint:

  Time point index

- Time:

  Time point as numeric days

- Project:

  Group: "Group1" or "Group2" (both simulated)

- ...:

  Additional Olink QC and metadata columns

## Source

Simulated by `data-raw/build_numab_probc.R`. Panel annotation from the
Olink Target 96 Immune Response and Inflammation panels. Versions before
2026-09-24 contained real project-B NPX values.
