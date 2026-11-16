# Reduced dimensions methods

Methods to get or set dimensionality reduction results in an
[OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md)
object. These are typically used to store and retrieve low-dimensional
representations of Olink datasets (e.g., PCA, UMAP, t-SNE). Each row of
a reduced dimension result is expected to correspond to a column of the
OlinkExperiment object.

## Getters

In the following examples, `x` is an
[OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md)
object.

- `reducedDim(x, type, withDimnames=TRUE)`::

  Retrieves a matrix (or matrix-like object) containing reduced
  dimension coordinates for samples (rows) and dimensions (columns).
  `type` is either a string specifying the name of the dimensionality
  reduction result in `x` to retrieve, or a numeric scalar specifying
  the index of the desired result, defaulting to the first entry if
  missing. If `withDimnames=TRUE`, row names of the output matrix are
  replaced with the column names of `x`.

- `reducedDimNames(x)`::

  Returns a character vector containing the names of all dimensionality
  reduction results in `x`.

- `reducedDims(x, withDimnames=TRUE)`::

  Returns a named List of matrices containing one or more dimensionality
  reduction results. Each result is a matrix (or matrix-like object)
  with the same number of rows as `ncol(x)`. If `withDimnames=TRUE`, row
  names of each matrix are replaced with the column names of `x`.

## Single-result setter

`reducedDim(x, type, withDimnames=TRUE) <- value` will add or replace a
dimensionality reduction result in an
[OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md)
object `x`. The value of `type` determines how the result is added or
replaced:

- If `type` is missing, `value` is assigned to the first result. If the
  result already exists, its name is preserved; otherwise it is given a
  default name `"unnamed1"`.

- If `type` is a numeric scalar, it must be within the range of existing
  results, and `value` will be assigned to the result at that index.

- If `type` is a string and a result exists with this name, `value` is
  assigned to that result. Otherwise a new result with this name is
  appended to the existing list of results.

`value` is expected to be a matrix or matrix-like object with number of
rows equal to `ncol(x)`. Alternatively, if `value` is `NULL`, the result
corresponding to `type` is removed from the object.

## Other setters

In the following examples, `x` is an
[OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md)
object.

- `reducedDims(x, withDimnames=TRUE) <- value`::

  Replaces all dimensionality reduction results in `x` with those in
  `value`. The latter should be a list-like object containing any number
  of matrices or matrix-like objects with number of rows equal to
  `ncol(x)`. If `value` is `NULL`, all dimensionality reduction results
  in `x` are removed.

- `reducedDimNames(x) <- value`::

  Replaces all names for dimensionality reduction results in `x` with a
  character vector `value`.

## Author

Lucas

## Examples

``` r
example(OlinkExperiment, echo = FALSE) # Using the class example

pca <- matrix(rnorm(ncol(oe) * 5), ncol = 5,
    dimnames = list(colnames(oe), paste0("PC", seq_len(5))))
umap <- matrix(rnorm(ncol(oe) * 2), ncol = 2,
    dimnames = list(colnames(oe), c("UMAP1", "UMAP2")))
reducedDims(oe) <- S4Vectors::SimpleList(PCA = pca, UMAP = umap)
reducedDim(oe, "PCA")
#>                 PC1         PC2         PC3          PC4         PC5
#> Sample1   1.5022631 -0.47052347  0.21605619 -1.362832165 -0.98497272
#> Sample2  -0.2734395 -0.48260789 -0.26025664 -1.695848217 -0.51816478
#> Sample3  -0.5248542  0.31856329  0.42689013  0.225675940 -1.10720493
#> Sample4  -0.1291835 -0.21923586 -0.54516506  0.520617543 -2.56653421
#> Sample5  -0.4579804  1.13448483 -0.76739360  0.431576979 -1.57658433
#> Sample6   0.2766668  0.70004629 -1.08569496 -0.451726567  0.72835193
#> Sample7   0.0123424 -0.46967286 -1.05333635  1.137841032  0.71117872
#> Sample8  -0.4471121  0.09526515  0.38676047  0.334693446  1.65344485
#> Sample9   0.1656488  1.01317079 -0.07471301 -0.599512560  0.57541701
#> Sample10 -1.6509121  0.45666360  0.34741063 -0.236623267 -0.34902941
#> Sample11 -1.4750650  0.41682934  1.67137257 -0.665844329  0.24480517
#> Sample12 -0.1380302  0.23617747 -0.23313089  0.343140381  1.78123179
#> Sample13 -0.7292744 -1.19816316 -1.29497362 -0.262997226 -0.05161329
#> Sample14  0.6105677 -0.25348100  0.94494818  1.001986977  0.46250793
#> Sample15  0.8856688  0.23550910  0.43599523 -0.608161540 -0.99382577
#> Sample16  0.1219470 -0.13296078  1.45243956  0.046179919  2.23919734
#> Sample17 -0.4061575  1.07051260 -1.15984904  1.720676959 -1.28650187
#> Sample18  1.7749323 -1.30886723 -0.69761674  0.004409094  0.06848145
#> Sample19 -0.5989549  0.74876088  1.25436769  2.237614951 -1.26617827
#> Sample20  0.8501840  0.17711800  0.01607587  1.147096667 -0.28420165
reducedDims(oe)
#> List of length 2
#> names(2): PCA UMAP

reducedDim(oe, "PCA") <- NULL
reducedDims(oe)
#> List of length 1
#> names(1): UMAP
```
