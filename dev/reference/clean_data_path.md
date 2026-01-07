# Clean the data path

This function deletes old reconstructions that have been superseded in
the data_path. It assumes that the only files in data_path are part of
`pastclim` (i.e. there are no custom datasets stored in that directory).

## Usage

``` r
clean_data_path(ask = TRUE)
```

## Arguments

- ask:

  boolean on whether the user should be asked before deleting

## Value

TRUE if files are deleted successfully
