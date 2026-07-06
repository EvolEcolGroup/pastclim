# Get time steps for a given MIS

Get the time steps available in a given dataset for a MIS.

## Usage

``` r
get_mis_time_steps(mis, dataset, path_to_nc = NULL)
```

## Arguments

- mis:

  string giving the mis; it must use the same spelling as used in
  [mis_boundaries](https://evolecolgroup.github.io/pastclim/reference/mis_boundaries.md)

- dataset:

  string defining dataset to be downloaded (a list of possible values
  can be obtained with
  [`list_available_datasets()`](https://evolecolgroup.github.io/pastclim/reference/list_available_datasets.md)).
  If set to "custom", then a single nc file is used from "path_to_nc"

- path_to_nc:

  the path to the custom nc file containing the palaeoclimate
  reconstructions. All the variables of interest need to be included in
  this file.

## Value

a vector of time steps
