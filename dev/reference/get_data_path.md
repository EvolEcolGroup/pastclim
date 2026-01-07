# Get the data path where climate reconstructions are stored

This function returns the path where climate reconstructions are stored.

## Usage

``` r
get_data_path(silent = FALSE)
```

## Arguments

- silent:

  boolean on whether a message is returned when data_path is not set
  (i.e. equal to NULL)

## Value

the data path

## Details

The path is stored in an option for `pastclim` named `data_path`. If a
configuration file was saved when using
[`set_data_path()`](https://evolecolgroup.github.io/pastclim/dev/reference/set_data_path.md),
the path is retrieved from a file named "pastclim_data.txt", which is
found in the directory returned by
`tools::R_user_dir("pastclim","config")` (i.e. the default configuration
directory for the package as set in R \>= 4.0).
