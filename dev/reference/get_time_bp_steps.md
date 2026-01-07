# Get time steps for a given dataset

Get the time steps (in time_bp or time_ce) available in a given dataset.

## Usage

``` r
get_time_bp_steps(dataset, path_to_nc = NULL)

get_time_ce_steps(dataset, path_to_nc = NULL)

get_time_steps(dataset, path_to_nc = NULL)
```

## Arguments

- dataset:

  string defining dataset to be downloaded (a list of possible values
  can be obtained with
  [`list_available_datasets()`](https://evolecolgroup.github.io/pastclim/dev/reference/list_available_datasets.md)).
  If set to "custom", then a single nc file is used from "path_to_nc"

- path_to_nc:

  the path to the custom nc file containing the palaeoclimate
  reconstructions. All the variables of interest need to be included in
  this file.

## Value

a vector of time steps (in time_bp, or time_ce)
