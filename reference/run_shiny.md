# Launch the OlinkViz interactive Shiny application

Opens an interactive Shiny dashboard for exploring Olink proteomics
datasets. The app allows users to select from built-in curated datasets
or upload their own NPX data files, then generate publication-quality
plots interactively.

## Usage

``` r
run_shiny(...)
```

## Arguments

- ...:

  Additional arguments passed to \`shiny::runApp()\`.

## Value

Called for its side effect of launching a Shiny app.

## Examples

``` r
if (FALSE) { # \dontrun{
run_shiny()
} # }
```
