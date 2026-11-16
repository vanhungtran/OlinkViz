# Longitudinal trajectory (spaghetti) plot

Plots individual trajectories of protein expression over time, with
optional group-level smoothing lines. Designed for paired/longitudinal
Olink data.

## Usage

``` r
plot_trajectory(
  data,
  subject_id = NULL,
  time = NULL,
  assay = NULL,
  group = NULL,
  facet = NULL,
  lod_col = NULL,
  show_lod = FALSE,
  assay_col = NULL,
  value_col = NULL,
  alpha_line = 0.3,
  alpha_point = 0.5,
  smooth_method = "loess",
  smooth_se = TRUE,
  palette = NULL,
  title = NULL,
  facet_by = NULL,
  ...
)
```

## Arguments

- data:

  A data.frame in long format containing a time column and a subject
  identifier column, or an
  [OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md).

- subject_id:

  Name of the column identifying individual subjects. If NULL,
  auto-detected (e.g. "SubjectID", "Patient", or "Assigned Participant
  ID").

- time:

  Name of the column containing time points. If NULL, auto-detected
  (e.g. "Time", "Timepoint", or "Visit").

- assay:

  Name(s) of the protein/assay(s) to plot. If NULL, the first assay in
  \`assay_col\` is used. When multiple assays are supplied, the plot is
  faceted by assay.

- group:

  Optional column to color by and add group-level LOESS smooth. If NULL,
  auto-detected from common group-like columns.

- facet, facet_by:

  Optional faceting. Either a column name to facet by, the string
  \`"subject"\` to create one panel per subject, or NULL for no faceting
  (default NULL). \`facet_by\` is an alias for \`facet\`.

- lod_col:

  Optional column name holding a per-assay LOD value; a dashed "MaxLOD"
  reference line is drawn at the maximum value per facet.

- show_lod:

  Logical; if \`TRUE\`, auto-detects the LOD column and draws a dashed
  reference line (default \`FALSE\`).

- assay_col:

  Name of the assay column. If NULL, auto-detected (e.g. "Assay").

- value_col:

  Name of the NPX value column. If NULL, auto-detected (e.g. "NPX").

- alpha_line:

  Alpha for individual lines (default 0.3).

- alpha_point:

  Alpha for individual points (default 0.5).

- smooth_method:

  Smoothing method: "loess", "lm", "glm", "gam", or "none" (default
  "loess").

- smooth_se:

  Show confidence bands for group smooth (default TRUE).

- palette:

  Optional color palette for groups.

- title:

  Plot title.

- ...:

  Additional arguments passed to \`ggplot2::stat_smooth()\`.

## Value

A ggplot object.

## Examples

``` r
if (FALSE) { # \dontrun{
# Subject, time and group columns are detected automatically
plot_trajectory(bansal_longitudinal, assay = "HAGH")

# Or specify them explicitly
plot_trajectory(bansal_longitudinal, subject_id = "Patient", time = "Time",
                assay = "HAGH", group = "Long_COVID")

# One panel per subject (with a per-facet LOD line when lod_col is given)
plot_trajectory(beatmg_npx, assay = "CD27", time = "Timepoint",
                facet = "subject")
} # }
```
