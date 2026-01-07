# Extract a climate slice for a region

This function extracts a slice of one or more climate variables for a
given dataset covering a region (or the whole world). The function
returns a SpatRaster
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
object, with each variable as a layer.

## Usage

``` r
region_slice(
  time_bp = NULL,
  time_ce = NULL,
  bio_variables,
  dataset,
  path_to_nc = NULL,
  ext = NULL,
  crop = NULL
)
```

## Arguments

- time_bp:

  the time slice in years before present (negative values represent time
  before present, positive values time in the future). The slice needs
  to exist in the dataset. To check which slices are available, you can
  use
  [`get_time_bp_steps()`](https://evolecolgroup.github.io/pastclim/dev/reference/get_time_bp_steps.md).

- time_ce:

  time slice in years CE. For available time slices in years CE, use
  [`get_time_ce_steps()`](https://evolecolgroup.github.io/pastclim/dev/reference/get_time_bp_steps.md).
  Only one of `time_bp` or `time_ce` should be used.

- bio_variables:

  vector of names of variables to be extracted

- dataset:

  string defining the dataset to use. If set to "custom", then a single
  nc file is used from "path_to_nc"

- path_to_nc:

  the path to the custom nc file containing the palaeoclimate
  reconstructions. All the variables of interest need to be included in
  this file.

- ext:

  an extent, coded as numeric vector (length=4; order= xmin, xmax, ymin,
  ymax) or a
  [terra::SpatExtent](https://rspatial.github.io/terra/reference/SpatExtent-class.html)
  object. If NULL, the full extent of the reconstruction is given.

- crop:

  a polygon used to crop the reconstructions (e.g. the outline of a
  continental mass). A
  [`sf::sfg`](https://r-spatial.github.io/sf/reference/st.html) or a
  [terra::SpatVector](https://rspatial.github.io/terra/reference/SpatVector-class.html)
  object is used to define the polygon.

## Value

a SpatRaster
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
object, with each variable as a layer.
