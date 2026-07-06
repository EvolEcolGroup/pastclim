# Generate file names to download the chelsa present dataset

This function creates a vector of paths needed to download the CHELSA
present dataset. Possible names are "paleoclim_1.0_10m",
"paleoclim_1.0_5m", "paleoclim_1.0_2.5m"

## Usage

``` r
filenames_paleoclim(dataset, bio_var)
```

## Arguments

- dataset:

  the name of the dataset of interest (currently unused)

- bio_var:

  the variable of interest

## Value

a vector of times, one per band
