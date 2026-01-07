# Downscale an ice mask

Downscaling the ice mask presents some issues. The mask is a binary
raster, so any standard downscaling approach will still look very
blocky. We can smooth the contour by applying a Gaussian filter. How
strong that filter should be is very much a matter of personal opinion,
as we do not have any data to compare to. This function attempts to use
a sensible default value, but it is worth exploring alternative values
to find a good solution.

## Usage

``` r
downscale_ice_mask(
  ice_mask_low_res,
  land_mask_high_res,
  d = c(0.5, 3),
  expand_xy = c(5, 5)
)
```

## Arguments

- ice_mask_low_res:

  a
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  of the low resolution ice mask to downscale (e.g. as obtained with
  [`get_ice_mask()`](https://evolecolgroup.github.io/pastclim/dev/reference/get_ice_mask.md))

- land_mask_high_res:

  a
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  of the land masks at different times (e.g. as obtained from
  [`make_land_mask()`](https://evolecolgroup.github.io/pastclim/dev/reference/make_land_mask.md)).
  The ice mask will be cropped and matched for the resolution of this
  land mask.

- d:

  a numeric vector of length 2, specifying the parameters for the
  Gaussian filter. The first value is the standard deviation of the
  Gaussian filter (sigma), and the second value is the size of the
  matrix to return. The default is c(0.5, 3).

- expand_xy:

  a numeric vector of length 2, specifying the number of units to expand
  the extent of the ice mask in the x and y directions when applying the
  Gaussian filter. This is to avoid edge effects. The default is c(5,5).

## Value

a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
of the ice mask (1's), with the rest of the world (sea and land) as NA's

## Details

The Guassian filter can lead to edge effects. To minimise such effects,
this function initially crops the ice mask to an extent that is larger
than `land_mask_high_res`, as defined by `expand_xy`. After applying the
Gaussian filter, the resulting raster is then cropped to the exact size
of `land_mask_high_res`.
