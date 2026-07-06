# Download part of the ETOPO relief dataset.

This function downloads part of the ETOPO2020 relief
(topography+bathymetry) dataset.

## Usage

``` r
download_etopo_subset(rast_template, ...)
```

## Arguments

- rast_template:

  a
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  providing the extent and resolution to be downloaded. This raster
  needs to have identical vertical and horizontal resolution, and
  standard lat/long projection.

- ...:

  additional parameters to be passed to
  [`marmap::getNOAA.bathy()`](https://rdrr.io/pkg/marmap/man/getNOAA.bathy.html)
  to customise how files are stored. See the manpage for that function
  for details

## Value

a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
with the relief for the chosen region

## Details

Use this function if you only need part of the dataset, or you need a
relatively low resolution. This function fetches the necessary subset on
the fly from the NOAA server. If you plan to use the ETOPO2022 dataset
extensively, it is worthwhile downloading it permanently to your
computer with
[`download_etopo()`](https://evolecolgroup.github.io/pastclim/reference/download_etopo.md),
but beware that it is a large file (\>1Gb). This function uses
[`marmap::getNOAA.bathy()`](https://rdrr.io/pkg/marmap/man/getNOAA.bathy.html)
to download the data, and then converts them into a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
formatted to be compatible with `pastclim`. NOTE: this function does not
save the relief, it returns a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html).
If you plan to reuse this relief multiple times, it would be wise to
save it with
[`terra::writeCDF()`](https://rspatial.github.io/terra/reference/writeCDF.html).
