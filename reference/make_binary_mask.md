# Create a binary mask

Create a binary mask from a raster: NAs are converted to 0s, and any
other value to 1.

## Usage

``` r
make_binary_mask(x)
```

## Arguments

- x:

  a
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)

## Value

a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
with 0s and 1s
