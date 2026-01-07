# Load the ETOPO global relief

This function loads previously downloaded ETOPO 2022 global relief
dataset, at 0.5 or 1 arc-minute (i.e. 30 or 60 arc-seconds) resolution.
The function assumes that the file name is
`etopo2022_{resolution}m_v1.nc` To save the file in the default path
with an appropriate name and file format, simply use
[`download_etopo()`](https://evolecolgroup.github.io/pastclim/dev/reference/download_etopo.md).

## Usage

``` r
load_etopo(path = NULL, resolution = 1, version = "1")
```

## Arguments

- path:

  character. Path where the dataset is stored. If left NULL, the data
  will be downloaded from the directory returned by
  [`get_data_path()`](https://evolecolgroup.github.io/pastclim/dev/reference/get_data_path.md)

- resolution:

  numeric resolution in arc-minute (one of 0.5, or 1). Defaults to 1
  arc-minute.

- version:

  character or numeric. The ETOPO2022 version number. Only "1" supported
  at the moment

## Value

a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
of relief
