# Download the CHELSA trace21k

This function downloads annual and monthly variables from the CHELSA
trace v1.0 dataset.

## Usage

``` r
download_chelsa_trace21k(dataset, bio_var, filename = NULL, time_bp = NULL)
```

## Arguments

- dataset:

  the name of the dataset

- bio_var:

  the variable name

- filename:

  the filename as stored in the `data_path` of `pastclim` (includes the
  full data path)

- time_bp:

  the time steps for which the dataset should be built (NULL for all
  time steps)

## Value

TRUE if the requested CHELSA variable was downloaded successfully

## Details

As this dataset is huge, we should not download all files in most
situations. For this reason, time_bp has to be set for downloading (but
it is allowed for virtual datasets)
