# Coefficient of variation (expressed as percentage)

R function to compute the coefficient of variation (expressed as a
percentage). If there is only a single value, stats::sd = NA. However,
one could argue that cv =0; and NA may break the code that receives it.
The function returns 0 if the mean is close to zero.

## Usage

``` r
.cv(x)
```

## Arguments

- x:

  a vector of values

## Value

the cv
