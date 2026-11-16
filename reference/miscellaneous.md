# Miscellaneous OlinkExperiment methods

Miscellaneous methods for the
[OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md)
class that do not fit in any other documentation category.

## Available methods

In the following code snippets, `x` and `object` are
[OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md)
objects.

- `show(object)`::

  Print a message to screen describing the contents of `object`.

- `objectVersion(x)`::

  Return the version of the package with which `x` was constructed.

## See also

`updateObject`, where `objectVersion` is used.

## Author

Lucas

## Examples

``` r
example(OlinkExperiment, echo = FALSE) # Using the class example

show(oe)
#> class: OlinkExperiment 
#> dim: 200 20 
#> metadata(0):
#> assays(2): NPX LOD
#> rownames(200): OID1 OID2 ... OID199 OID200
#> rowData names(2): OlinkID Panel
#> colnames(20): Sample1 Sample2 ... Sample19 Sample20
#> colData names(2): SampleID Group
#> reducedDimNames(0):
objectVersion(oe)
#> [1] '0.1.1'
```
