# Validate NPX data structure

Checks that a data frame has the minimum required columns for
long-format NPX data. Warnings are issued for common issues; errors for
missing columns.

## Usage

``` r
validate_npx(
  data,
  assay_col = NULL,
  value_col = NULL,
  sample_col = NULL,
  fail_on_missing = TRUE
)
```

## Arguments

- data:

  A data.frame or data.table.

- assay_col:

  Name of the assay/protein column. If NULL, auto-detected from common
  names such as \`Assay\`, \`Protein\`, or \`feature_name\`.

- value_col:

  Name of the NPX value column. If NULL, auto-detected from common names
  such as \`NPX\` or \`Value\`.

- sample_col:

  Name of the sample identifier column. If NULL, auto-detected from
  common names such as \`SampleID\` or \`SubjectID\`.

- fail_on_missing:

  If TRUE, stops on missing columns; otherwise warns.

## Value

Invisibly returns TRUE if all checks pass.
