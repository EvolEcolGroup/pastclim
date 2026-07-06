# Sample the different number of points from a region time series

Internal function for sampling different number of points for each
timestep of a region series from
[`sample_region_series()`](https://evolecolgroup.github.io/pastclim/reference/sample_region_series.md),
used when size is a vector of values.

## Usage

``` r
sample_rs_variable(x, size, method = "random", replace = FALSE, na.rm = TRUE)
```

## Arguments

- x:

  a
  [`terra::SpatRasterDataset`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  returned by
  [`region_series()`](https://evolecolgroup.github.io/pastclim/reference/region_series.md)

- size:

  a vector of the number of points sampled for each time step

- method:

  one of the sampling methods from
  [`terra::spatSample()`](https://rspatial.github.io/terra/reference/sample.html).
  It defaults to "random"

- replace:

  boolean determining whether we sample with replacement

- na.rm:

  boolean determining whether NAs are removed

## Value

a data.frame with the sampled cells and their respective values for the
climate variables.
