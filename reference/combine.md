# Combining or subsetting OlinkExperiment objects

An overview of methods to combine multiple
[OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md)
objects by row or column, or to subset an OlinkExperiment by row or
column. These methods are useful for ensuring that all data fields
remain synchronized when samples or proteins are added or removed.

## Combining

In the following code snippets, `...` contains one or more
[OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md)
objects.

- `rbind(..., deparse.level=1)`::

  Returns an OlinkExperiment where all objects in `...` are combined
  row-wise, i.e., rows in successive objects are appended to the first
  object. Refer to `?"rbind,SummarizedExperiment-method"` for details on
  how metadata is combined in the output object. Note that all objects
  in `...` must have the exact same values for
  [`reducedDims`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md).

- `cbind(..., deparse.level=1)`::

  Returns an OlinkExperiment where all objects in `...` are combined
  column-wise, i.e., columns in successive objects are appended to the
  first object. Each object `x` in `...` must have the same values of
  [`reducedDimNames`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)`(x)`
  (though they can be unordered). Dimensionality reduction results with
  the same name across objects will be combined row-wise to create the
  corresponding entry in the output object. Refer to
  `?"cbind,SummarizedExperiment-method"` for details on how metadata is
  combined in the output object.

## Subsetting

In the following code snippets, `x` is an
[OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md)
object.

- `x[i, j, ..., drop=TRUE]`::

  Returns an OlinkExperiment containing the specified rows `i` and
  columns `j`. `i` and `j` can be a logical, integer or character vector
  of subscripts, indicating the rows and columns respectively to retain.
  Either can be missing, in which case subsetting is only performed in
  the specified dimension. Arguments in `...` and `drop` are passed to
  `[,SummarizedExperiment-method`.

## Author

Lucas

## Examples

``` r
example(OlinkExperiment, echo = FALSE) # using the class example

# Combining:
rbind(oe, oe)
#> class: OlinkExperiment 
#> dim: 400 20 
#> metadata(0):
#> assays(2): NPX LOD
#> rownames(400): OID1 OID2 ... OID199 OID200
#> rowData names(2): OlinkID Panel
#> colnames(20): Sample1 Sample2 ... Sample19 Sample20
#> colData names(2): SampleID Group
#> reducedDimNames(0):
cbind(oe, oe)
#> class: OlinkExperiment 
#> dim: 200 40 
#> metadata(0):
#> assays(2): NPX LOD
#> rownames(200): OID1 OID2 ... OID199 OID200
#> rowData names(2): OlinkID Panel
#> colnames(40): Sample1 Sample2 ... Sample19 Sample20
#> colData names(2): SampleID Group
#> reducedDimNames(0):

# Subsetting:
oe[1:10, ]
#> class: OlinkExperiment 
#> dim: 10 20 
#> metadata(0):
#> assays(2): NPX LOD
#> rownames(10): OID1 OID2 ... OID9 OID10
#> rowData names(2): OlinkID Panel
#> colnames(20): Sample1 Sample2 ... Sample19 Sample20
#> colData names(2): SampleID Group
#> reducedDimNames(0):
oe[, 1:5]
#> class: OlinkExperiment 
#> dim: 200 5 
#> metadata(0):
#> assays(2): NPX LOD
#> rownames(200): OID1 OID2 ... OID199 OID200
#> rowData names(2): OlinkID Panel
#> colnames(5): Sample1 Sample2 Sample3 Sample4 Sample5
#> colData names(2): SampleID Group
#> reducedDimNames(0):
```
