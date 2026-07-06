# Extract and set time in years before present for SpatRaster and SpatRasterDataset

This functions extracts and sets time in years BP (i.e. from 1950) for a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
or a
[`terra::SpatRasterDataset`](https://rspatial.github.io/terra/reference/SpatRaster-class.html).
In a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
object, time is stored with unit "years", which are years from 0AD. This
means that, when a summary of the
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
is inspected, the times will appear as `time_bp`+1950. The same applies
when the function
[`terra::time()`](https://rspatial.github.io/terra/reference/time.html)
is used instead of `time_bp()`.

## Usage

``` r
time_bp(x)

# S4 method for class 'SpatRaster'
time_bp(x)

# S4 method for class 'SpatRasterDataset'
time_bp(x)

time_bp(x) <- value

# S4 method for class 'SpatRaster'
time_bp(x) <- value

# S4 method for class 'SpatRasterDataset'
time_bp(x) <- value
```

## Arguments

- x:

  a
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)

- value:

  a numeric vector of times in years BP

## Value

a date in years BP (where negative numbers indicate a date in the past)
