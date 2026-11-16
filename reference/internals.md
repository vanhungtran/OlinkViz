# Internal OlinkExperiment functions

Methods to get or set internal fields from the OlinkExperiment class.
These functions are intended for package developers who want to add
protected fields to an OlinkExperiment. They should *not* be used by
ordinary users of the OlinkViz package.

## Getters

In the following code snippets, `x` is an
[OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md).

- `int_elementMetadata(x)`::

  Returns a DataFrame of internal row metadata, with number of rows
  equal to `nrow(x)`. This is analogous to the user-visible `rowData`.

- `int_colData(x)`::

  Returns a DataFrame of internal column metadata, with number of rows
  equal to `ncol(x)`. This is analogous to the user-visible `colData`.

- `int_metadata(x)`::

  Returns a list of internal metadata, analogous to the user-visible
  `metadata`.

It may occasionally be useful to return both the visible and the
internal `colData` in a single DataFrame. This is facilitated by the
following methods:

- `rowData(x, ..., internal=FALSE)`:

  Returns a DataFrame of the user-visible row metadata. If
  `internal=TRUE`, the internal row metadata is added column-wise to the
  user-visible metadata.

- `colData(x, ..., internal=FALSE)`:

  Returns a DataFrame of the user-visible column metadata. If
  `internal=TRUE`, the internal column metadata is added column-wise to
  the user-visible metadata.

## Setters

In the following code snippets, `x` is an
[OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md).

- `int_elementMetadata(x) <- value`:

  Replaces the internal row metadata with `value`, a DataFrame with
  number of rows equal to `nrow(x)`.

- `int_colData(x) <- value`:

  Replaces the internal column metadata with `value`, a DataFrame with
  number of rows equal to `ncol(x)`.

- `int_metadata(x) <- value`:

  Replaces the internal metadata with `value`, analogous to the
  user-visible `metadata<-`.

## Comments

The internal metadata fields allow easy and extensible storage of
additional elements that are parallel to the rows or columns of an
[OlinkExperiment](https://vanhungtran.github.io/OlinkViz/reference/OlinkExperiment.md)
class. This avoids the need to specify new slots and adjust the
subsetting/combining code for a new data element. For example,
[`reducedDims`](https://vanhungtran.github.io/OlinkViz/reference/reducedDims.md)
is implemented as a field in the internal column metadata.

## See also

`colData`, `rowData` and `metadata` for the user-visible equivalents.

## Author

Lucas

## Examples

``` r
example(OlinkExperiment, echo = FALSE) # Using the class example
int_metadata(oe)$whee <- 1
```
