# Save a plot at its final journal size

Exports a ggplot, patchwork, or pheatmap object at an exact physical
size in one or more formats. PDFs use the Cairo device so fonts are
embedded; PNG, SVG and TIFF use \`ggplot2::ggsave()\` defaults (ragg or
svglite when installed). Typical widths are 89 mm (single column) and
183 mm (double column), but check the journal's author guidelines.

## Usage

``` r
save_olinkviz(
  plot,
  file,
  width = 89,
  height = 70,
  units = "mm",
  formats = c("pdf", "png"),
  dpi = 300
)
```

## Arguments

- plot:

  A \`ggplot\`, \`patchwork\`, \`pheatmap\`, or \`gtable\`/\`grob\`
  object, e.g. the result of any \`plot\_\*()\` function. For
  base-graphics plots (\[plot_corr()\]) open a device yourself (for
  example \`grDevices::cairo_pdf()\`), call the function, and close the
  device.

- file:

  Output path. A file extension is ignored; one file per entry of
  \`formats\` is written next to it.

- width, height:

  Size of the figure in \`units\`.

- units:

  \`"mm"\` (default), \`"cm"\` or \`"in"\`.

- formats:

  Any of \`"pdf"\`, \`"png"\`, \`"svg"\`, \`"tiff"\`. Default \`c("pdf",
  "png")\`.

- dpi:

  Resolution of raster formats (default 300).

## Value

Invisibly, the paths of the files written.

## Examples

``` r
# \donttest{
old <- olinkviz_options(base_size = 7)
p <- plot_boxplot(probc, assay = "IL6", group = "Project")
save_olinkviz(p, file.path(tempdir(), "il6_boxplot"), width = 89, height = 70)
options(old)
# }
```
