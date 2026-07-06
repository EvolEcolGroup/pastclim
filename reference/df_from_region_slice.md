# Extract data frame from a region slice

Extract the climatic information from a region slice and organise it as
a data frame. This is just a wrapper around
[`terra::as.data.frame()`](https://rspatial.github.io/terra/reference/as.data.frame.html).

## Usage

``` r
df_from_region_slice(x, xy = TRUE)
```

## Arguments

- x:

  climate time slice (i.e. a
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html))
  generated with
  [`region_slice()`](https://evolecolgroup.github.io/pastclim/reference/region_slice.md)

- xy:

  a boolean whether x and y coordinates should be added to the dataframe
  (default to TRUE)

## Value

a data.frame where each cell the raster is a row, and the available
variables are columns.

## Details

To extract a data frame from a region series, see
[`df_from_region_series()`](https://evolecolgroup.github.io/pastclim/reference/df_from_region_series.md).
