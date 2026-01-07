# Read a raster for pastclim

This function is a wrapper around
[`terra::rast()`](https://rspatial.github.io/terra/reference/rast.html),
with additional logic to correctly import time for vrt datasets (time is
stored as custom metadata in pastclim-generated vrt files)

## Usage

``` r
pastclim_rast(
  x,
  bio_var_orig,
  bio_var_pastclim,
  var_longname = NULL,
  var_units = NULL
)
```

## Arguments

- x:

  filename of the raster

- bio_var_orig:

  the variable name as present in the file

- bio_var_pastclim:

  the variable name as used by pastclim (thus allowing us to rename the
  variable)

## Value

a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
