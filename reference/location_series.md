# Extract a time series of bioclimatic variables for one or more locations.

This function extract a time series of local climate for a set of
locations. Note that this function does not apply any interpolation (as
opposed to
[`location_slice()`](https://evolecolgroup.github.io/pastclim/reference/location_slice.md)).
If you have a coastal location that just falls into the water for the
reconstructions, you will have to amend the coordinates to put it more
firmly on land.

## Usage

``` r
location_series(
  x,
  time_bp = NULL,
  time_ce = NULL,
  coords = NULL,
  bio_variables,
  dataset,
  path_to_nc = NULL,
  nn_interpol = FALSE,
  buffer = FALSE,
  directions = 8
)
```

## Arguments

- x:

  a data.frame with columns of x and y coordinates (and an optional
  `name` column), or a vector of cell numbers. See `coords` for standard
  coordinate names, or how to use custom ones.

- time_bp:

  time slices in years before present (negative values represent time
  before present, positive values time in the future). This parameter
  can be a vector of times (the slices need to exist in the dataset), a
  list with a min and max element setting the range of values, or left
  to NULL to retrieve all time steps. To check which slices are
  available, you can use
  [`get_time_bp_steps()`](https://evolecolgroup.github.io/pastclim/reference/get_time_bp_steps.md).

- time_ce:

  time slice in years CE (see `time_bp` for options). For available time
  slices in years CE, use
  [`get_time_ce_steps()`](https://evolecolgroup.github.io/pastclim/reference/get_time_bp_steps.md).
  Only one of `time_bp` or `time_ce` should be used.

- coords:

  a vector of length two giving the names of the "x" and "y"
  coordinates, as found in `data`. If left to NULL, the function will
  try to guess the columns based on standard names `c("x", "y")`,
  `c("X","Y")`, `c("longitude", "latitude")`, or `c("lon", "lat")`

- bio_variables:

  vector of names of variables to be extracted.

- dataset:

  string defining the dataset to use. If set to "custom", then a single
  nc file is used from "path_to_nc"

- path_to_nc:

  the path to the custom nc file containing the palaeoclimate
  reconstructions. All the variables of interest need to be included in
  this file.

- nn_interpol:

  boolean determining whether nearest neighbour interpolation is used to
  estimate climate for cells that lack such information (i.e. they are
  under water or ice). By default, interpolation is only performed from
  the first ring of nearest neighbours; if climate is not available, NA
  will be returned for that location. The number of neighbours can be
  changed with the argument `directions`. `nn_interpol` defaults to
  FALSE (this is DIFFERENT from
  [`location_slice()`](https://evolecolgroup.github.io/pastclim/reference/location_slice.md).

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

a data.frame with the climatic variables of interest
