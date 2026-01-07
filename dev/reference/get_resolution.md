# Get resolution of a given dataset

Get the resolution of a given dataset.

## Usage

``` r
get_resolution(dataset, path_to_nc = NULL)
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

a vector of resolution in the x and y axes
