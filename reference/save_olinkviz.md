# Save a plot at its final journal size and run pre-flight checks

Exports a ggplot, patchwork, or pheatmap object at an exact physical
size in one or more formats (\`"pdf"\`, \`"png"\`, \`"tiff"\`,
\`"eps"\`, \`"svg"\`, \`"jpeg"\`). PDFs and EPS use the Cairo device
when available so fonts are embedded; TIFFs use LZW compression.
\`width\` accepts numeric values in \`units\` or journal column keywords
(\`"single"\`, \`"1.5"\`, \`"double"\`), and \`height\` accepts numeric
values or \`"max"\` (see \[journal_width()\] and \[journal_height()\]).

## Usage

``` r
save_olinkviz(
  plot,
  file,
  width = 89,
  height = 70,
  units = "mm",
  formats = c("pdf", "png"),
  dpi = 300,
  journal = getOption("olinkviz.journal", "nature"),
  check = FALSE,
  ...
)
```

## Arguments

- plot:

  A \`ggplot\`, \`patchwork\`, \`pheatmap\`, or \`gtable\`/\`grob\`
  object.

- file:

  Output path. A file extension is ignored; one file per entry of
  \`formats\` is written next to it.

- width:

  Width in \`units\`, or a width keyword (\`"single"\`, \`"1.5"\`,
  \`"double"\`, \`"full"\`, \`"1col"\`, \`"2col"\`, \`"3col"\`). Default
  \`89\`.

- height:

  Height in \`units\`, or \`"max"\` for the journal's maximum height.
  Default \`70\`.

- units:

  \`"mm"\` (default), \`"cm"\` or \`"in"\`.

- formats:

  Any of \`"pdf"\`, \`"png"\`, \`"svg"\`, \`"tiff"\`, \`"eps"\`,
  \`"jpeg"\`. Default \`c("pdf", "png")\`.

- dpi:

  Resolution of raster formats (default 300).

- journal:

  Registered journal id (see \[journal_specs()\]) used to resolve width
  keywords and pre-flight check limits. Defaults to
  \`getOption("olinkviz.journal", "nature")\`.

- check:

  \`TRUE\`, \`FALSE\` (default), or a character vector of checks to run:
  any of \`"fit"\`, \`"size"\`, \`"text"\`, \`"lines"\`, \`"colour"\`.

- ...:

  Additional arguments passed to \[ggplot2::ggsave()\].

## Value

Invisibly, the paths of the files written.

## Details

With \`check = TRUE\`, the figure is audited against \`journal\` before
saving via \[olinkviz_check_size()\], \[olinkviz_check_fit()\],
\[olinkviz_check_text()\], and \[olinkviz_check_lines()\]. Findings are
reported as warnings or messages that never block the export.

## See also

Other export:
[`labs_panel()`](https://vanhungtran.github.io/OlinkViz/reference/labs_panel.md),
[`olinkviz_combine()`](https://vanhungtran.github.io/OlinkViz/reference/olinkviz_combine.md)

## Examples

``` r
# \donttest{
old <- olinkviz_options(base_size = 7, axes = "l")
p <- plot_boxplot(probc, assay = "IL6", group = "Project")
save_olinkviz(p, file.path(tempdir(), "il6_boxplot"), width = 89, height = 70)
save_olinkviz(p, file.path(tempdir(), "il6_nature"), width = "single", height = 70,
              journal = "nature", check = TRUE)
#> olinkviz_check_text(): 1 text item(s) are above the 7 pt maximum the nature guide states: plot title 9 pt (x1). (Shown once per session; olinkviz_check_text() or olinkviz_preflight() show it on demand.)
options(old)
# }
```
