# Compute a raster of distances from the sea for each land pixel.

Get the land mask for a dataset at a given time point, and compute
distance from the sea for each land pixel.

## Usage

``` r
distance_from_sea(time_bp = NULL, time_ce = NULL, dataset)
```

## Arguments

- time_bp:

  time slice in years before present (negative)

- time_ce:

  time slice in years CE. Only one of `time_bp` or `time_ce` should be
  used.

- dataset:

  string defining the dataset to use (a list of possible values can be
  obtained with
  [`list_available_datasets()`](https://evolecolgroup.github.io/pastclim/reference/list_available_datasets.md)).
  This function will not work on custom datasets.

## Value

a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
of distances from the coastline in km
