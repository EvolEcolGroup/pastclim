# Update the dataset list

If a newer dataset list (which includes all the information about the
files storing the data for pastclim), download it and start using it as
'dataset_list_included.csv' in `tools::R_user_dir("pastclim","config")`.
If the latter is present, the last column, named 'dataset_list_v',
provides the version of this table, and the most advanced table is used.

## Usage

``` r
update_dataset_list(on_cran = FALSE)
```

## Arguments

- on_cran:

  boolean to make this function run on ci tests using tempdir

## Value

TRUE if the dataset was updated
