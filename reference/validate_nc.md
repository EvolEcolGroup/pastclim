# Validate an netcdf file for pastclim

This function validates a netcdf file as a potential dataset for
`pastclim`. The key checks are: a) that the dimensions (longitude,
latitude and time) have been set correctly. b) that all variables have
the appropriate metadata (longname and units)

## Usage

``` r
validate_nc(path_to_nc)
```

## Arguments

- path_to_nc:

  path to the nc file of interest

## Value

TRUE if the file is valid.
