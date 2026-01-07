# Extract data frame from a region series

Extract the climatic information from a region series and organise them
as a data frame.

## Usage

``` r
df_from_region_series(x, xy = TRUE)
```

## Arguments

- x:

  climate time series generated with
  [`region_series()`](https://evolecolgroup.github.io/pastclim/dev/reference/region_series.md)

- xy:

  a boolean whether x and y coordinates should be added to the dataframe
  (default to TRUE)

## Value

a data.frame where each cell each raster layer (i.e. timestep) is a row,
and the available variables are columns.

## Details

To extract a data frame from a region slice, see
[`df_from_region_slice()`](https://evolecolgroup.github.io/pastclim/dev/reference/df_from_region_slice.md).
