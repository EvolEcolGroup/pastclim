# Sample points from a region time series

This function samples points from a region time series. Sampling can
either be performed for the same locations at all time steps (if only
one value is given for `size`), or for different locations for each time
step (if `size` is a vector of length equal to the number of time
steps). To sample the same number of points, but different locations,
for each time step, provide a vector repeating the same value for each
time step.

## Usage

``` r
sample_region_series(x, size, method = "random", replace = FALSE, na.rm = TRUE)
```

## Arguments

- x:

  a
  [`terra::SpatRasterDataset`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  returned by
  [`region_series()`](https://evolecolgroup.github.io/pastclim/dev/reference/region_series.md)

- size:

  number of points sampled. A single value is used to sample the same
  locations across all time steps, a vector of values to sample
  different locations at each time step.

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

## Details

This function wraps
[`terra::spatSample()`](https://rspatial.github.io/terra/reference/sample.html)
to appropriate sample the
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)s
in the
[`terra::SpatRasterDataset`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
returned by
[`region_series()`](https://evolecolgroup.github.io/pastclim/dev/reference/region_series.md).
