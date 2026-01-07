# Extract a slice for a time series of climate variables for a region

This function extracts a time slice from time series of one or more
climate variables for a given dataset covering a region (or the whole
world).

## Usage

``` r
slice_region_series(x, time_bp = NULL, time_ce = NULL)
```

## Arguments

- x:

  climate time series generated with
  [`region_series()`](https://evolecolgroup.github.io/pastclim/dev/reference/region_series.md)

- time_bp:

  time slice in years before present (i.e. 1950, negative integers for
  values in the past). The slices need to exist in the dataset. To check
  which slices are available, you can use `time_bp(x)`.

- time_ce:

  time slice in years CE. Only one of `time_bp` or `time_ce` should be
  used.

## Value

a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
of the relevant slice.
