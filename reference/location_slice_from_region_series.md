# Extract local climate for one or more locations for a given time slice.

This function extract local climate for a set of locations at the
appropriate times (selecting the closest time slice available for the
specific date associated with each location).

## Usage

``` r
location_slice_from_region_series(
  x,
  time_bp = NULL,
  time_ce = NULL,
  coords = NULL,
  region_series,
  nn_interpol = TRUE,
  buffer = FALSE,
  directions = 8
)
```

## Arguments

- x:

  a data.frame with columns x and y coordinates(see `coords` for
  standard coordinate names, or how to use custom ones), plus optional
  columns `time_bp` or `time_ce` (depending on the units used) and
  `name`. Alternatively, a vector of cell numbers.

- time_bp:

  used if no `time_bp` column is present in `x`: the dates in years
  before present (negative values represent time before present, i.e.
  1950, positive values time in the future) for each location.

- time_ce:

  time in years CE as an alternative to `time_bp`. Only one of `time_bp`
  or `time_ce` should be used.

- coords:

  a vector of length two giving the names of the "x" and "y"
  coordinates, as found in `data`. If left to NULL, the function will
  try to guess the columns based on standard names `c("x", "y")`,
  `c("X","Y")`, `c("longitude", "latitude")`, or `c("lon", "lat")`

- region_series:

  a
  [`terra::SpatRasterDataset`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  obtained with
  [`region_series()`](https://evolecolgroup.github.io/pastclim/reference/region_series.md)

- nn_interpol:

  boolean determining whether nearest neighbour interpolation is used to
  estimate climate for cells that lack such information (i.e. they are
  under water or ice). By default, interpolation is only performed from
  the first ring of nearest neighbours; if climate is not available, NA
  will be returned for that location. The number of neighbours can be
  changed with the argument `directions`. `nn_interpol` defaults to
  TRUE.

- buffer:

  boolean determining whether the variable will be returned as the mean
  of a buffer around the focal cell. If set to TRUE, it overrides
  `nn_interpol` (which provides the same estimates as `buffer` but only
  for locations that are in cells with an NA). The buffer size is
  determined by the argument `directions`. `buffer` defaults to FALSE.

- directions:

  character or matrix to indicate the directions in which cells are
  considered connected when using `nn_interpol` or `buffer`. The
  following character values are allowed: "rook" or "4" for the
  horizontal and vertical neighbours; "bishop" to get the diagonal
  neighbours; "queen" or "8" to get the vertical, horizontal and
  diagonal neighbours; or "16" for knight and one-cell queen move
  neighbours. If directions is a matrix it should have odd dimensions
  and have logical (or 0, 1) values.

## Value

a data.frame with the climatic variables of interest.
