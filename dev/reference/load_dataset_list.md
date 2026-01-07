# Load the dataset list

This function returns a dataframe with the details for each variable
available in every dataset. It defaults to the copy stored within the
package, but it checks in case there is an updated version stored as
'dataset_list_included.csv' in `tools::R_user_dir("pastclim","config")`.
If the latter is present, the last column, named 'dataset_list_v',
provides the version of this table, and the most advanced table is used.

## Usage

``` r
load_dataset_list(on_cran = FALSE)
```

## Arguments

- on_cran:

  boolean to make this function run on ci tests using tempdir

## Value

the dataset list
