# Download the CHELSA modern and future observations.

This function downloads annual and monthly variables from the CHELSA
v2.1 dataset.

## Usage

``` r
download_chelsa(dataset, bio_var, filename)
```

## Arguments

- dataset:

  the name of the dataset

- bio_var:

  the variable name

- filename:

  the filename as stored in the `data_path` of `pastclim` (includes the
  full data path)

## Value

TRUE if the requested CHELSA variable was downloaded successfully
