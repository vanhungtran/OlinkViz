# Enriched pathways for a set of proteins

Runs pathway/GO enrichment on a set of protein (gene) identifiers using
the gprofiler2 package (an internet connection is required) and returns
a protein → pathway mapping that can be used as a row annotation for
`plot_heatmap(..., pathway_annotation = TRUE)`.

## Usage

``` r
enrich_pathways(
  proteins,
  organism = "hsapiens",
  sources = NULL,
  p_cutoff = 0.05,
  ...
)
```

## Arguments

- proteins:

  Character vector of protein/gene identifiers (e.g. gene symbols such
  as `"IL6"`, `"CD40"`).

- organism:

  Organism used by
  [`gprofiler2::gost()`](https://rdrr.io/pkg/gprofiler2/man/gost.html)
  (default `"hsapiens"`).

- sources:

  Optional character vector of gprofiler2 data sources (e.g. `"GO:BP"`,
  `"KEGG"`, `"REAC"`, `"WP"`). If `NULL`, the gprofiler2 defaults are
  used.

- p_cutoff:

  Significance threshold for enriched pathways (default 0.05).

- ...:

  Additional arguments passed to
  [`gprofiler2::gost()`](https://rdrr.io/pkg/gprofiler2/man/gost.html).

## Value

A data.frame with one row per (protein, pathway) pair for the
significant enriched pathways, with columns `Protein`, `Pathway`,
`term_id`, `source` and `p_value` (sorted by p-value). Returns `NULL`
(with a message) if gprofiler2 is unavailable, no internet connection is
available, or no significant enrichment is found.

## Examples

``` r
if (FALSE) { # \dontrun{
enrich_pathways(c("IL6", "CD40", "IL10", "TNF", "CCL2", "CXCL8"))
} # }
```
