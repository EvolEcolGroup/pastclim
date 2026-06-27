# Reconstruct biomes based on the Köppen Geiger's classification

Function to reconstruct biomes following the Köppen Geiger's
classification, as implemented in Beck et al (2018). This function is a
translation of the Matlab function "KoeppenGeiger" provided in that
publication. See Table 1 in beck et al (2018) for the rules implemented
in this function.

## Usage

``` r
koeppen_geiger(prec, tavg, broad = FALSE, class_names = TRUE, ...)

# S4 method for class 'matrix,matrix'
koeppen_geiger(prec, tavg, broad = FALSE, class_names = TRUE)

# S4 method for class 'SpatRaster,SpatRaster'
koeppen_geiger(
  prec,
  tavg,
  broad = FALSE,
  class_names = TRUE,
  filename = "",
  ...
)

# S4 method for class 'SpatRasterDataset,SpatRasterDataset'
koeppen_geiger(
  prec,
  tavg,
  broad = FALSE,
  class_names = TRUE,
  filename = "",
  ...
)
```

## Arguments

- prec:

  monthly precipitation, either as a matrix (with 12 columns) or as a
  SpatRaster with 12 layers

- tavg:

  monthly average temperatures, either as a matrix (with 12 columns) or
  as a SpatRaster with 12 layers

- broad:

  boolean whether to return broad level classification

- class_names:

  boolean whether to return the names of classes (in addition to codes)

- ...:

  additional variables for specific methods

- filename:

  filename to save the raster (optional).

## Value

a data.frame with the Köppen Geiger classification

## Details

Beck, H.E., McVicar, T.R., Vergopolan, N. et al. High-resolution (1 km)
Köppen-Geiger maps for 1901–2099 based on constrained CMIP6 projections.
Sci Data 10, 724 (2023). https://doi.org/10.1038/s41597-023-02549-6

## Examples

``` r
prec <- matrix(
  c(
    66, 51, 53, 53, 33, 34.2, 70.9, 58, 54, 104.3, 81.2, 82.8, 113.3,
    97.4, 89, 109.7, 89, 93.4, 99.8, 92.6, 85.3, 102.3, 84, 81.6, 108.6,
    88.4, 82.7, 140.1, 120.4, 111.6, 120.4, 113.9, 96.7, 90, 77.4, 79.1
  ),
  ncol = 12, byrow = TRUE
)
tavg <- matrix(
  c(
    -0.2, 1.7, 2.9, 0.3, 4.2, 5, 4, 9, 9.2, 7.3, 12.6, 12.7, 12.1,
    17.2, 17, 15.5, 20.5, 20.3, 17.9, 22.8, 22.9, 17.4, 22.3, 22.4, 13.2,
    18.2, 18.6, 8.8, 13, 13.6, 3.5, 6.4, 7.5, 0.3, 2.1, 3.4
  ),
  ncol = 12, byrow = TRUE
)
koeppen_geiger(prec, tavg, broad = TRUE)
#>   id broad
#> 1 27     4
#> 2 14     3
#> 3 15     3
```
