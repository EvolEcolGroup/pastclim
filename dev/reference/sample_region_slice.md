# Sample points from a region time slice

This function samples points from a region time slice (i.e. a time
point).

## Usage

``` r
sample_region_slice(x, size, method = "random", replace = FALSE, na.rm = TRUE)
```

## Arguments

- x:

  a
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  returned by
  [`region_slice()`](https://evolecolgroup.github.io/pastclim/dev/reference/region_slice.md)

- size:

  number of points sampled.

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
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
returned by
[`region_slice()`](https://evolecolgroup.github.io/pastclim/dev/reference/region_slice.md).
You can also use
[`terra::spatSample()`](https://rspatial.github.io/terra/reference/sample.html)
directly on a slice (which is a standard
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)).
