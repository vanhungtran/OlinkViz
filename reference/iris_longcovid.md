# IRIS Long COVID Olink Data

Long-format Olink NPX proteomics data from the IRIS Long COVID study.
Contains protein expression values for patients with and without long
COVID.

## Usage

``` r
iris_longcovid
```

## Format

A data.table with 16,000 rows and 7 columns:

- Assay:

  Protein assay name

- NPX:

  Normalized Protein eXpression value

- Sex:

  Biological sex of the subject

- IRIS_number:

  Subject identifier

- Panel:

  Olink protein panel

- long_covid:

  Factor: "Yes" or "No"

- timing_month:

  Time point in months

## Source

Hamlin R, Pienkos S, Blish C (2024). Long COVID IRIS Study Olink
Proteomics Dataset. Zenodo.
[doi:10.5281/zenodo.13363117](https://doi.org/10.5281/zenodo.13363117)
