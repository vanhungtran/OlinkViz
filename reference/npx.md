# Named assay getters and setters for Olink data

Methods for getting or setting Olink-specific assays of an
[OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md)
object. These provide convenient access to the standard Olink assay
names and encourage standardization of assay names across packages.

## Available methods

In the following code snippets, `x` is an
[OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md)
object, `value` is a matrix-like object with the same dimensions as `x`,
and `...` are further arguments passed to `assay` (for the getter) or
`assay<-` (for the setter).

- `npx(x, ...)`, `npx(x, ...) <- value`::

  Get or set the matrix of Normalized Protein eXpression (NPX) values.
  NPX values are on a log2-like scale and are the standard
  quantification reported by Olink.

- `lod(x, ...)`, `lod(x, ...) <- value`::

  Get or set the matrix of Limit Of Detection (LOD) values. A single LOD
  value per protein is typically broadcast across all samples.

- `pcount(x, ...)`, `pcount(x, ...) <- value`::

  Get or set the matrix of raw protein counts. This is the raw number of
  detected protein molecules prior to normalization to NPX.

If `i` is in `...`, it will be ignored and a warning will be raised. For
each method described above, the name of the assay in `x` is always the
same as the function name, e.g., `npx(x)` will retrieve the assay named
`"NPX"`.

## See also

`assay` and `assay<-`, for the wrapped methods.

## Author

Lucas

## Examples

``` r
example(OlinkExperiment, echo = FALSE) # Using the class example

dim(npx(oe))
#> [1] 200  20
npx(oe)[1:3, 1:3]
#>       Sample1  Sample2  Sample3
#> OID1 4.497808 5.028172 3.715171
#> OID2 5.131531 4.643297 4.858218
#> OID3 4.921083 5.852626 6.438785

# The getter/setter wraps assay("NPX")
npx(oe) <- npx(oe) + 1

# LOD accessor
lod(oe)[1:3, 1:3]
#>      Sample1 Sample2 Sample3
#> OID1     0.5     0.5     0.5
#> OID2     0.5     0.5     0.5
#> OID3     0.5     0.5     0.5
```
