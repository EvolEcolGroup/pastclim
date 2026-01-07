# Get the ice mask for a dataset.

Get the ice mask for a dataset, either for the whole series or for
specific time points.

## Usage

``` r
get_ice_mask(time_bp = NULL, dataset)
```

## Arguments

- time_bp:

  time slices in years before present (negative values represent time
  before present, positive values time in the future). This parameter
  can be a vector of times (the slices need to exist in the dataset), a
  list with a min and max element setting the range of values, or left
  to NULL to retrieve all time steps. To check which slices are
  available, you can use
  [`get_time_bp_steps()`](https://evolecolgroup.github.io/pastclim/dev/reference/get_time_bp_steps.md).

- dataset:

  string defining dataset to be downloaded (a list of possible values
  can be obtained with
  [`list_available_datasets()`](https://evolecolgroup.github.io/pastclim/dev/reference/list_available_datasets.md)).
  This function will not work on custom datasets.

## Value

a binary
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
with the ice mask as 1s

## Details

Note that not all datasets have ice information.
