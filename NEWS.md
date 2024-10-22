# pastclim dev
* Add delta downscaling functions
* Fix chelsa paths to match new URLs

# pastclim 2.1.0
* Add all CHELSA present and future datasets (including the use of virtual rasters to avoid downloading all data)
* Add paleoclim at multiple resolutions
* Add CHELSA-TraCE21k (including the use of virtual rasters to avoid downloading all data)
* Re-implement the import for WorldClim datasets to avoid repackaging the data (it should lead to faster downloads, but it will force a re-download if the dataset was already present).
* Add functions for Koeppen Geiger's classification from monthly means.

# pastclim 2.0.0
* Allow time to be defined as CE besides BP. NOTE that this adds a parameter
  to a number of functions. If those functions were used without explicitly
  naming parameters, old code might give an error as the order of parameters
  has now changed).
* Add Barreto et al 2023 (based on PALEO-PGEM, covering the last 5 M years)
* Add all the WorldClim data (present, and future projections with multiple models
  and emission scenarios).
* Add the HYDE 3.3 database providing information on agriculture and population sizes
  for the last 10k years.
* Change the units of Krapp et al 2021 to match those of other datasets. Also, fix
  data duplication of some variables which has now also been fixed on the OSF repository
  for that dataset.
* Improve `get_ice_mask()`, `get_land_mask()`, and `distance_from_sea()` to work
  on series rather than just on slices.
* Speed up `region_*()` functions when subsetting the extent/cropping.

# pastclim 1.2.4
* Updates on how time is handled to stay in sync with changes in `terra`.

# pastclim 1.2.3
* Added *lai* to *Krapp2021* (the variable is now also present in the original OSF
  repository for that dataset).
* Change column names in `data.frame` returned by `location_series()` to match
  `location_slice()`
* Allow for interpolation of nearest neighbours in `location_series()`, and allow
  for a buffer on estimates returned by the `location_*()` functions.

# pastclim 1.2.2
* Update of *Krapp2021* files to make them compatible with how `terra` now handles
  time. Users will have to re-download datasets. Old files can be removed with
  `clean_data_path()`

# pastclim 1.2.1
* Small updates for CRAN submission.

# pastclim 1.2.0

* Provide additional information about variables and their units, and create
  pretty labels for plots.
  
* Names of locations are now stored automatically in the outputs.

* Update how time is handled to work with `terra` 1.6-41 (which now imports
  units from netcdf files).

# pastclim 1.1.0

* Expand functionality to handle time series for regions; rename functions  to
  extract data for regions and locations to make them consistent. Old code will
  still work, but will raise a warning that the functions are deprecated.

* Remove the need for `pastclimData`, we now put any data in the user dir returned
  by `R>=4.0.0`. This removes the need of re-downloading the data when upgrading `R`.

* Add monthly variables to *Beyer2020* and *Krapp2021*.

# pastclim 1.0.1

* Fix bug when information was extracted for just one location.

# pastclim 1.0.0

* Initial public release
