# Compute a delta raster.

This function generates a delta (difference) raster, computed as the
difference between model estimates (`x`) and some observations
(`high_res_obs`). `x` is a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
of the variable we want to downscale, and it can contain multiple time
steps. `ref_time` sets the time slice for which the delta should be
computed.

## Usage

``` r
delta_compute(x, ref_time, obs, max_land = NULL)
```

## Arguments

- x:

  a
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  for the variable of interest, with all time steps of interest

- ref_time:

  the time (BP) of the slice that is used to compute the delta

- obs:

  the observations

- max_land:

  a
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  with the maximum land extent

## Value

a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
of the delta

## Details

If `obs` has a higher resolution than `x`, the latter is interpolated
using a bilinear algorithm. For areas that are present in some time
slices, but not in the observations (e.g. due to sea level change), the
delta map is extended to cover the maximum cumulative land mask (over
all time steps) using inverse distance weighted interpolation.
