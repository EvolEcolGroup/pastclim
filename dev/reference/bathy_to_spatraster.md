# Cast `bathy` to `SpatRaster`

This function converts a
[`marmap::bathy`](https://rdrr.io/pkg/marmap/man/as.bathy.html) object
to a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html).

## Usage

``` r
bathy_to_spatraster(bathy)
```

## Arguments

- bathy:

  a [`marmap::bathy`](https://rdrr.io/pkg/marmap/man/as.bathy.html) to
  convert

## Value

a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
with the relief for the chosen region
