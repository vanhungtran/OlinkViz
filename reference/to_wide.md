# Pivot long-format NPX data to wide format

Converts long-format Olink data (one row per assay per sample) to a wide
matrix where rows are samples and columns are assays (proteins).

## Usage

``` r
to_wide(
  data,
  assay_col = NULL,
  value_col = NULL,
  sample_col = NULL,
  id_cols = NULL,
  probe_dups = c("average", "panel_suffix", "olink_id")
)
```

## Arguments

- data:

  A data.frame in long format.

- assay_col:

  Name of the assay column. If NULL, auto-detected from common names
  such as \`Assay\` or \`feature_name\`.

- value_col:

  Name of the NPX value column. If NULL, auto-detected from common names
  such as \`NPX\` or \`Value\`.

- sample_col:

  Name of the sample ID column. If NULL, auto-detected from common names
  such as \`SampleID\` or \`SubjectID\`.

- id_cols:

  Additional columns to keep as sample-level identifiers. If NULL
  (default), non-numeric columns (except assay/value columns) are
  automatically preserved as identifiers.

- probe_dups:

  How to handle duplicate \`(sample, assay)\` rows when the same protein
  is measured on multiple Olink panels or probes: \`"average"\`
  (default; averages replicate NPX values), \`"panel_suffix"\` (appends
  \`" (\<Panel\>)"\` to duplicated assay names when a panel column is
  present), or \`"olink_id"\` (uses the \`OlinkID\` column or appends
  \`" (\<OlinkID\>)"\` to disambiguate probes).

## Value

A data.frame in wide format.
