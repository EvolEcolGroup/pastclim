# Download palaeoclimate reconstructions.

This function downloads palaeoclimate reconstructions. Files will be
stored in the data path of `pastclim`, which can be inspected with
[`get_data_path()`](https://evolecolgroup.github.io/pastclim/dev/reference/get_data_path.md)
and changed with
[`set_data_path()`](https://evolecolgroup.github.io/pastclim/dev/reference/set_data_path.md)

## Usage

``` r
download_dataset(dataset, bio_variables = NULL, annual = TRUE, monthly = FALSE)
```

## Arguments

- dataset:

  string defining dataset to be downloaded (a list of possible values
  can be obtained with
  [`list_available_datasets()`](https://evolecolgroup.github.io/pastclim/dev/reference/list_available_datasets.md)).
  This function will not work on custom datasets.

- bio_variables:

  one or more variable names to be downloaded. If left to NULL, all
  variables available for this dataset will be downloaded (the
  parameters `annual` and `monthly`, see below, define which types)

- annual:

  boolean to download annual variables

- monthly:

  boolean to download monthly variables

## Value

TRUE if the dataset(s) was downloaded correctly.
