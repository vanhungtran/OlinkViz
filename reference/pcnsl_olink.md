# PCNSL Plasma Olink Data

Wide-format Olink NPX data from the Primary CNS Lymphoma (PCNSL) plasma
proteomics study. Samples are rows; protein NPX values are columns.

## Usage

``` r
pcnsl_olink
```

## Format

A data.table with 172 rows and 1,010 columns:

- sample_id:

  Sample identifier

- batch:

  Experimental batch (factor)

- replicate_of:

  Replicate information

- ...:

  Remaining columns are protein names with NPX values

## Source

Künzle T, Alentorn A (2026). Anonymized plasma Olink NPX matrices PCNSL
(LOC network). Zenodo.
[doi:10.5281/zenodo.20815686](https://doi.org/10.5281/zenodo.20815686)
