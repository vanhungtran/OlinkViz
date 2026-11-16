# Build an OlinkExperiment from long-format Olink data

Constructs an
[OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md)
from raw long-format Olink NPX data (one row per assay per sample), such
as the output of `OlinkAnalyze::read_NPX()` or the bundled OlinkViz
datasets. Columns for the assay, NPX value and sample ID are
auto-detected from common names; an optional LOD column is stored as a
parallel `"LOD"` assay.

## Usage

``` r
oe_from_long(
  data,
  assay_col = NULL,
  value_col = NULL,
  sample_col = NULL,
  lod_col = NULL,
  id_col = NULL,
  ...
)
```

## Arguments

- data:

  A data.frame or data.table in long format with one row per assay per
  sample.

- assay_col:

  Name of the assay (protein) column. If `NULL`, auto-detected from
  common names such as `Assay` or `OlinkID`.

- value_col:

  Name of the NPX value column. If `NULL`, auto-detected from common
  names such as `NPX`.

- sample_col:

  Name of the sample ID column. If `NULL`, auto-detected from common
  names such as `SampleID` or `SubjectID`.

- lod_col:

  Name of a column containing Limit Of Detection (LOD) values. If
  `NULL`, a column named `LOD` (or `MaxLOD`/`PlateLOD`) is searched for
  automatically. If LOD is present it is stored as a parallel `"LOD"`
  assay; otherwise the object contains only the `"NPX"` assay.

- id_col:

  Optional name of the protein identifier column to use as the row key
  (e.g. `"OlinkID"`). If `NULL`, the detected assay column is used
  unless its values are not unique (the same gene measured by several
  Olink probes), in which case an `OlinkID`-like column is used
  automatically so that every probe becomes its own row.

- ...:

  Further arguments passed to
  [`OlinkExperiment`](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md),
  e.g. `reducedDims`.

## Value

An
[OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md)
object.

## Details

The returned object has proteins as rows and samples as columns. Columns
of `data` that are constant within each assay (e.g., `OlinkID`,
`UniProt`, `Panel`) are placed in `rowData`, while columns that are
constant within each sample (e.g., `Sex`, `Group`) are placed in
`colData`. Columns that are neither (or contain only missing values) are
dropped with a message.

If a LOD column is supplied, it is pivoted to the same protein x sample
layout as NPX (a per-protein LOD value is broadcast across samples
automatically by the pivot), so `lod(oe)` is always a matrix parallel to
`npx(oe)`.

## See also

[`OlinkExperiment`](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md),
the underlying constructor. To build an OlinkExperiment directly from a
wide NPX matrix, call it as
`OlinkExperiment(assays = list(NPX = npx, LOD = lod), colData = cd, rowData = rd)`.

## Author

Lucas

## Examples

``` r
long <- data.frame(
  SampleID = rep(paste0("S", 1:4), each = 3),
  Assay    = rep(c("IL6", "TNF", "CXCL9"), times = 4),
  NPX      = rnorm(12, mean = 5),
  LOD      = rep(c(0.3, 0.5, 0.4), times = 4),
  Panel    = rep("Inflammation", 12),
  Group    = rep(c("case", "control"), each = 6)
)

oe <- oe_from_long(long)
oe
#> class: OlinkExperiment 
#> dim: 3 4 
#> metadata(0):
#> assays(2): NPX LOD
#> rownames(3): IL6 TNF CXCL9
#> rowData names(2): Assay Panel
#> colnames(4): S1 S2 S3 S4
#> colData names(2): SampleID Group
#> reducedDimNames(0):
dim(npx(oe))
#> [1] 3 4
dim(lod(oe))
#> [1] 3 4
colData(oe)
#> DataFrame with 4 rows and 2 columns
#>       SampleID       Group
#>    <character> <character>
#> S1          S1        case
#> S2          S2        case
#> S3          S3     control
#> S4          S4     control
rowData(oe)
#> DataFrame with 3 rows and 2 columns
#>             Assay        Panel
#>       <character>  <character>
#> IL6           IL6 Inflammation
#> TNF           TNF Inflammation
#> CXCL9       CXCL9 Inflammation
```
