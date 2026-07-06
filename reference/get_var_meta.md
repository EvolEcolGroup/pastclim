# Get the metadata for a variable in a given dataset.

Internal getter function

## Usage

``` r
get_var_meta(variable, dataset)
```

## Arguments

- variable:

  one or more variable names to be downloaded

- dataset:

  string defining dataset to be downloaded (a list of possible values
  can be obtained with
  [`list_available_datasets()`](https://evolecolgroup.github.io/pastclim/reference/list_available_datasets.md)).
  This function will not work on custom datasets.

## Value

the metadata (including filename) for that variable in that dataset
