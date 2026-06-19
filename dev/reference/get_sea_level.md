# Get sea level estimate

This function returns the estimated sea level from Spratt et al. 2016,
using the long PC1. Sea levels are from contemporary sea level (note
that the original data are with reference to the sea level during the
Holocene ~5k year ago).

## Usage

``` r
get_sea_level(time_bp, dataset = "Spratt2016")
```

## Arguments

- time_bp:

  the time of interest

- dataset:

  the dataset to use, either "Spratt2016" or "Clark2025"

## Value

a vector of sea levels in meters from present level
