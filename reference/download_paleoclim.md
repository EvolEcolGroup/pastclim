# Download the paleoclim time series.

This function downloads annual and monthly variables from the Paleoclim
V1.0 dataset.

## Usage

``` r
download_paleoclim(dataset, bio_var, filename = NULL)
```

## Arguments

- dataset:

  the name of the dataset

- bio_var:

  the variable name

- filename:

  (NOT USED FOR THIS FUNCTION: the data come as zip of all bio
  variables, so we generate multiple files, not a single one)

## Value

TRUE if the requested paleoclim variable was downloaded successfully
