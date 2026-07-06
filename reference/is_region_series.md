# Check the object is a valid region series

A region series is a
[`terra::SpatRasterDataset`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
for which each sub-dataset is a variable, and all variables have the
same number of time steps.

## Usage

``` r
is_region_series(x, strict = FALSE)
```

## Arguments

- x:

  a
  [`terra::SpatRasterDataset`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  representing a time series of regional reconstructions obtained from
  [`region_series()`](https://evolecolgroup.github.io/pastclim/reference/region_series.md).

- strict:

  a boolean defining whether to preform a thorough test (see description
  above for details).

## Value

TRUE if the object is a region series

## Details

The standard test only checks that all sub-datasets (each of which is a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html))
have the same number of layers. The more thorough test (obtained with
*strict=TRUE*) actually checks that all variables have the same
identical time steps by comparing the result of
[`terra::time()`](https://rspatial.github.io/terra/reference/time.html)
applied to each variable.
