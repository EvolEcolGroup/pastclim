# Interpolate x to match mask y

Fill in x to match cells available in y, using inverse distance weighted
interpolation. Interpolation is fitted using
[`gstat::gstat()`](https://r-spatial.github.io/gstat/reference/gstat.html);
the default parameters for
[`gstat::gstat()`](https://r-spatial.github.io/gstat/reference/gstat.html)
are "nmax=7" and "idp=.5", but can be changed by providing arguments to
this function (which will be passed to
[`gstat::gstat()`](https://r-spatial.github.io/gstat/reference/gstat.html)).
See
[`gstat::gstat()`](https://r-spatial.github.io/gstat/reference/gstat.html)
for details on the available parameters and their meaning.

## Usage

``` r
idw_interp(x, y, nmax = 7, set = list(idp = 0.5), ...)
```

## Arguments

- x:

  the
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  of the variable of interest

- y:

  the
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  the reference mask defining which cells should have values

- nmax:

  the number of nearest observations that should be used for a kriging
  prediction or simulation, where nearest is defined in terms of the
  space of the spatial locations (see
  [`gstat::gstat()`](https://r-spatial.github.io/gstat/reference/gstat.html)
  for details)

- set:

  named list with optional parameters to be passed to gstat (only set
  commands of gstat are allowed, and not all of them may be relevant;
  see the gstat manual for gstat stand-alone, URL and more details in
  the
  [`gstat::gstat()`](https://r-spatial.github.io/gstat/reference/gstat.html)
  help page)

- ...:

  further parameters to be passed to
  [`gstat::gstat()`](https://r-spatial.github.io/gstat/reference/gstat.html)

## Value

a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
of the interpolated version of *x*
