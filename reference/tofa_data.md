# TOFA Down Syndrome Olink Data

Long-format Olink NPX data from the Tofacitinib for Immune Skin
Conditions in Down Syndrome (TOFA) study. Contains baseline and 16-week
measurements.

## Usage

``` r
tofa_data
```

## Format

A data.table with approximately 454,000 rows and 16 columns:

- subjectid:

  Subject identifier

- sampleid:

  Sample identifier

- assay:

  Protein assay name

- npx:

  Normalized Protein eXpression value

- timepoint:

  Time point (baseline or week 16)

- ...:

  Additional metadata columns

## Source

Rachubinski AL, et al. (2024). JAK inhibition decreases the autoimmune
burden in Down syndrome. eLife.
[doi:10.7554/elife.99323](https://doi.org/10.7554/elife.99323)
