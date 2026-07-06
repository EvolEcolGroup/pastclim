# Check that we have a valid pair of coordinate names

This internal function checks that coords (as passed to functions) is a
valid set of names, or, if NULL, that we have standard variable names in
data

## Usage

``` r
check_coords_names(data, coords)
```

## Arguments

- data:

  a data.frame containing the locations.

- coords:

  a vector of length two giving the names of the "x" and "y"
  coordinates, of points is a data.frame and does not use standard
  names.

## Value

A vector of length 2 with the valid names, in the correct order
