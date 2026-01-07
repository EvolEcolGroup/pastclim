# Convert years BP from pastclim to lubridate date, or vice versa

These functions convert between years BP as used by pastclim (negative
numbers going into the past, positive into the future) and standard
`POSIXct` date objects.

## Usage

``` r
ybp2date(x)

date2ybp(x)
```

## Arguments

- x:

  a time in years BP using the `pastclim` convention of negative numbers
  indicating years into the past, or a `POSIXct` date object

## Value

a `POSIXct` date object, or a vector

## Examples

``` r
ybp2date(-10000)
#> [1] "-8050-01-01 UTC"
ybp2date(0)
#> [1] "1950-01-01 UTC"
# back and forth
date2ybp(ybp2date(-10000))
#> [1] -10000
```
