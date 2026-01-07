# Sample the same locations from a region time series

Internal function for fixed sampling from
[`sample_region_series()`](https://evolecolgroup.github.io/pastclim/dev/reference/sample_region_series.md),
used when a single size is given.

## Usage

``` r
sample_rs_fixed(x, size, method = "random", replace = FALSE, na.rm = TRUE)
```

## Arguments

- x:

  a
  [`terra::SpatRasterDataset`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  returned by
  [`region_series()`](https://evolecolgroup.github.io/pastclim/dev/reference/region_series.md)

- size:

  number of points sampled; the same locations across all time steps

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
