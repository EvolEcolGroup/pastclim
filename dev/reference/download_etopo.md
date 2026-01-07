# Download the ETOPO Global relief model

This function downloads the ETOPO2022 global relief model at 0.5 or 1
arc-minute (i.e. 30 or 60 arc-seconds) resolution. This is a large file
(\>1Gb).

## Usage

``` r
download_etopo(path = NULL, resolution = 1, force = FALSE)
```

## Arguments

- path:

  character. Path where to download the data to. If left NULL, the data
  will be downloaded from the directory returned by
  [`get_data_path()`](https://evolecolgroup.github.io/pastclim/dev/reference/get_data_path.md),
  and automatically named `etopo2022_{resolution}s_v1.nc`

- resolution:

  numeric resolution in arc-minute (one of 0.5, or 1). Defaults to 1
  arc-minute.

- force:

  logical. If TRUE, the file will be downloaded even if it already
  exists.

## Value

a dataframe produced by
[`curl::multi_download()`](https://jeroen.r-universe.dev/curl/reference/multi_download.html)
with information about the download (including error codes)
