# The OlinkExperiment class

The OlinkExperiment class is designed to represent Olink proteomics
data. It inherits from the RangedSummarizedExperiment class and is used
in the same manner: rows represent proteins while columns represent
samples. In addition, the class supports storage of dimensionality
reduction results (e.g., PCA, UMAP) via
[`reducedDims`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md).

## Usage

``` r
OlinkExperiment(..., reducedDims = list())
```

## Arguments

- ...:

  Arguments passed to the `SummarizedExperiment` constructor to fill the
  slots of the base class. In particular, the `assays` argument should
  be a list of matrices (or matrix-like objects) with one row per
  protein and one column per sample. Olink NPX values are conventionally
  stored in an assay named `"NPX"` (see
  [`npx`](https://vanhungtran.github.io/OlinkViz/reference/npx.md)),
  with the limit of detection in `"LOD"` (see
  [`lod`](https://vanhungtran.github.io/OlinkViz/reference/npx.md)) and
  raw protein counts in `"PC"` (see
  [`pcount`](https://vanhungtran.github.io/OlinkViz/reference/npx.md)).

- reducedDims:

  A list of any number of matrix-like objects containing dimensionality
  reduction results, each of which should have the same number of rows
  as the output OlinkExperiment object (i.e., one row per sample).

## Value

An OlinkExperiment object.

## Details

In this class, rows should represent proteins while columns represent
samples generated from Olink proteomics experiments.

As with any SummarizedExperiment derivative, different quantifications
(e.g., NPX, LOD, protein counts) can be stored simultaneously in the
`assays` slot, and row and column metadata can be attached using
`rowData` and `colData`, respectively. Here, `rowData` is expected to
contain protein-level annotation (e.g., OlinkID, UniProt, Panel, Assay)
while `colData` is expected to contain sample-level annotation (e.g.,
SampleID, SubjectID, group, time point).

The extra arguments in the constructor (e.g.,
[`reducedDims`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md))
represent the main extension implemented in the OlinkExperiment class.
This enables a consistent, formalized representation of the data
structures commonly encountered during Olink data analysis.

An OlinkExperiment can also be created by coercing from a
SummarizedExperiment or RangedSummarizedExperiment instance; see
`coerce,OlinkExperiment,SummarizedExperiment-method`.

## See also

[`reducedDims`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md),
for representation of dimensionality reduction results.

[`npx`](https://vanhungtran.github.io/OlinkViz/reference/npx.md),
[`lod`](https://vanhungtran.github.io/OlinkViz/reference/npx.md) and
[`pcount`](https://vanhungtran.github.io/OlinkViz/reference/npx.md), for
Olink-specific named assay accessors.

`?"`[`OE-internals`](https://vanhungtran.github.io/OlinkViz/reference/internals.md)`"`,
for developer use.

## Author

Lucas

## Examples

``` r
nproteins <- 200
nsamples <- 20
set.seed(100)

# Simulated NPX and LOD matrices (proteins x samples)
npx_mat <- matrix(rnorm(nproteins * nsamples, mean = 5, sd = 1),
    nrow = nproteins, ncol = nsamples,
    dimnames = list(paste0("OID", seq_len(nproteins)),
        paste0("Sample", seq_len(nsamples))))
lod_mat <- matrix(0.5, nrow = nproteins, ncol = nsamples,
    dimnames = dimnames(npx_mat))

# Sample and protein annotation
colData_df <- S4Vectors::DataFrame(SampleID = colnames(npx_mat),
    Group = rep(c("case", "control"), each = nsamples / 2))
rowData_df <- S4Vectors::DataFrame(OlinkID = rownames(npx_mat),
    Panel = rep(c("Inflammation", "Cardiometabolic"), length.out = nproteins))

oe <- OlinkExperiment(
    assays = list(NPX = npx_mat, LOD = lod_mat),
    colData = colData_df,
    rowData = rowData_df
)
oe
#> class: OlinkExperiment 
#> dim: 200 20 
#> metadata(0):
#> assays(2): NPX LOD
#> rownames(200): OID1 OID2 ... OID199 OID200
#> rowData names(2): OlinkID Panel
#> colnames(20): Sample1 Sample2 ... Sample19 Sample20
#> colData names(2): SampleID Group
#> reducedDimNames(0):

## coercion from SummarizedExperiment
se <- SummarizedExperiment::SummarizedExperiment(assays = list(NPX = npx_mat, LOD = lod_mat))
as(se, "OlinkExperiment")
#> class: OlinkExperiment 
#> dim: 200 20 
#> metadata(0):
#> assays(2): NPX LOD
#> rownames(200): OID1 OID2 ... OID199 OID200
#> rowData names(0):
#> colnames(20): Sample1 Sample2 ... Sample19 Sample20
#> colData names(0):
#> reducedDimNames(0):

## coercion to a SummarizedExperiment
as(oe, "SummarizedExperiment")
#> class: SummarizedExperiment 
#> dim: 200 20 
#> metadata(0):
#> assays(2): NPX LOD
#> rownames: NULL
#> rowData names(0):
#> colnames(20): Sample1 Sample2 ... Sample19 Sample20
#> colData names(2): SampleID Group
```
