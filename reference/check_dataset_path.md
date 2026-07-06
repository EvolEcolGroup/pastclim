# Check dataset and path_to_nc params

Check that the dataset and path_to_nc parameters are valid.
Specifically, if `path_to_nc` should only be set if `dataset` is
`custom` (and conversely, `custom` datasets require a `path_to_nc`).

## Usage

``` r
check_dataset_path(dataset, path_to_nc)
```

## Arguments

- dataset:

  string defining the dataset to use. If set to "custom", then a single
  nc file is used from "path_to_nc".

- path_to_nc:

  the path to the custom nc file containing the palaeoclimate
  reconstructions. All the variables of interest need to be included in
  this file.

## Value

TRUE if both dataset and path are valid.
