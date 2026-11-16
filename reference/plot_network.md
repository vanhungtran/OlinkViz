# STRING protein-protein interaction network

Maps a set of protein/assay identifiers to the STRING database and
downloads a protein-protein interaction network image via the
\`rbioapi\` package. Requires an internet connection.

## Usage

``` r
plot_network(
  assays,
  assay_col = NULL,
  species = 9606,
  required_score = 500,
  network_flavor = "confidence",
  add_white_nodes = 5,
  image_format = "image",
  outdir = tempdir(),
  ...
)
```

## Arguments

- assays:

  Character vector of protein identifiers (e.g. gene symbols or UniProt
  IDs). If a data.frame is supplied, \`assay_col\` is used to extract
  them.

- assay_col:

  Name of the assay/protein column when \`assays\` is a data.frame. If
  NULL, auto-detected (e.g. "Assay").

- species:

  NCBI taxonomy ID (default 9606, Homo sapiens).

- required_score:

  Confidence score threshold (0-1000, default 500).

- network_flavor:

  STRING network flavor: "confidence", "actions", "evidence",
  "interactive" (default "confidence").

- add_white_nodes:

  Number of white (neighborhood) nodes to add.

- image_format:

  Image format: "image" (PNG) or "highres_image" (default "image").

- outdir:

  Directory to save the downloaded image (default tempdir()).

- ...:

  Additional arguments passed to
  \`rbioapi::rba_string_network_image()\`.

## Value

Invisibly returns the path to the downloaded image.

## Examples

``` r
if (FALSE) { # \dontrun{
plot_network(c("IL6", "TNF", "CXCL10", "CD40", "IL10"))
} # }
```
