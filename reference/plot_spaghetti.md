# Spaghetti plot of individual NPX trajectories

Plots one line per subject across time (a "spaghetti" plot), optionally
faceted by a grouping variable (e.g. treatment group) with an overlaid
LOESS trend line. Mirrors the trajectory figures in the NUMAB reports.

## Usage

``` r
plot_spaghetti(
  data,
  assay = NULL,
  subject_id = NULL,
  time = NULL,
  group = NULL,
  facet_by = NULL,
  assay_col = NULL,
  value_col = NULL,
  lod_col = NULL,
  show_lod = FALSE,
  smooth = "loess",
  alpha_line = 0.4,
  alpha_point = 0.5,
  palette = NULL,
  title = NULL,
  facet = NULL,
  ...
)
```

## Arguments

- data:

  A data.frame in long format, or an
  [OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md).

- assay:

  Name(s) of the protein/assay(s) to plot. If NULL, the first assay in
  \`assay_col\` is used. When multiple assays are supplied, the plot is
  faceted by assay.

- subject_id:

  Name of the column identifying individual subjects. If NULL,
  auto-detected (e.g. "SubjectID", "Patient", "PPID").

- time:

  Name of the column containing time points. If NULL, auto-detected
  (e.g. "Time", "Timepoint", "Visit").

- group:

  Optional column name to color individual lines by.

- facet_by, facet:

  Optional column name to facet the plot by (e.g. "TreatGroup").

- assay_col:

  Name of the assay column. If NULL, auto-detected (e.g. "Assay").

- value_col:

  Name of the NPX value column. If NULL, auto-detected (e.g. "NPX").

- lod_col:

  Optional column name holding a per-assay LOD value; a dashed "MaxLOD"
  reference line is drawn at the maximum value per facet.

- show_lod:

  Logical; if \`TRUE\`, auto-detects the LOD column and draws a dashed
  reference line (default \`FALSE\`).

- smooth:

  Optional smoothing method for an overlaid trend line: "loess", "lm",
  "gam", or "none" (default "loess").

- alpha_line:

  Alpha for individual lines (default 0.4).

- alpha_point:

  Alpha for individual points (default 0.5).

- palette:

  Optional color palette for \`group\`.

- title:

  Plot title.

- ...:

  Additional arguments passed to \`ggplot2::stat_smooth()\`.

## Value

A ggplot object.

## Examples

``` r
if (FALSE) { # \dontrun{
plot_spaghetti(
  bansal_longitudinal, assay = "HAGH",
  subject_id = "Assigned Participant  ID", time = "Time",
  facet_by = "Long_COVID status"
)
} # }
```
