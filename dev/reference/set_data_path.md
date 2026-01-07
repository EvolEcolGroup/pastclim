# Set the data path where climate reconstructions will be stored

This function sets the path where climate reconstructions will be
stored. This information is stored in a file names "pastclim_data.txt",
which is found in the directory returned by
`tools::R_user_dir("pastclim","config")` (i.e. the default configuration
directory for the package as set in R \>= 4.0).

## Usage

``` r
set_data_path(
  path_to_nc = NULL,
  ask = TRUE,
  write_config = TRUE,
  copy_example = TRUE,
  on_CRAN = FALSE
)
```

## Arguments

- path_to_nc:

  the path to the file that contains the downloaded reconstructions. If
  left unset, the default location returned by
  `tools::R_user_dir("pastclim","data")` will be used

- ask:

  boolean on whether the user should be asked to confirm their choices

- write_config:

  boolean on whether the path should be saved in a config file

- copy_example:

  boolean on whether the example dataset should be saved in the
  data_path

- on_CRAN:

  boolean; users should NOT need this parameters. It is used to set up a
  data path in the temporary directory for examples and tests to run on
  CRAN.

## Value

TRUE if the path was set correctly
