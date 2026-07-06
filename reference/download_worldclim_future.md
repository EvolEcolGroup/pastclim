# Download the worldclim future time series.

This function downloads annual and monthly variables from the WorldClim
v2.1 dataset for future projections.

## Usage

``` r
download_worldclim_future(dataset, bio_var, filename = NULL)
```

## Arguments

- dataset:

  the name of the dataset

- bio_var:

  the variable name

- filename:

  ()

## Value

TRUE if the requested worldclim variable was downloaded successfully

## Details

Note: the data come as tiffs each containing all bio (or prec/temp)
variables for a given time step. From these, we generate a vrt per
variable. So, since we download the full set for a give variable type,
we create all the vrts for that variable type (e.g. all the bio). We use
the filename to get the version name, and then at the end to check that
we did generate it correctly given our programmatic way of creating the
names of all vrt files.
