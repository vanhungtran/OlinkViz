# Pivot wide-format data to long format

Converts wide-format data (samples as rows, proteins as columns) to long
format compatible with OlinkViz plot functions.

## Usage

``` r
to_long(
  data,
  assay_cols = NULL,
  id_cols = NULL,
  assay_col = "Assay",
  value_col = "NPX",
  exclude_cols = NULL
)
```

## Arguments

- data:

  A data.frame in wide format.

- assay_cols:

  Character vector of column names to pivot (the protein/assay columns).
  If NULL, all columns not in \`id_cols\` are treated as assay columns.

- id_cols:

  Columns to keep as identifiers (not pivoted).

- assay_col:

  Name for the new assay column (default "Assay").

- value_col:

  Name for the new NPX value column (default "NPX").

- exclude_cols:

  Character vector of column names to exclude from auto-detected assay
  columns when \`assay_cols = NULL\`. Ignored when \`assay_cols\` is
  provided explicitly. Defaults to common non-protein identifier
  columns.

## Value

A data.frame in long format.
