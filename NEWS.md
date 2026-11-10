# pastclim (development version)
* pastclim now requires terra >= 1.8-93: with earlier versions, extracting
  categorical variables (e.g. `biome`) with `layer` in `location_slice()`
  and `location_series()` returns incorrect results.
* improve the speed of `location_series()`.
* fix for missing time step in CHELSA-TraCE21k (-1300 BP is missing for min
  and max temperature
* fix path for Barreto2023 dataset (Figshare does not allow any longer to
  download with a simple curl, so we have moved the data to Zenodo)
* add SE for bio variables for Barreto et al 2023
* Add Clark2025 as a possible sea level dataset.
* Fix `location_slice()` interpolating valid locations when other columns of `x` contained NAs.
* Fix `location_slice_from_region_series()` with a vector of cell numbers.
* Fix `sample_region_series()` for region series with a single time step.
* Fix `koeppen_geiger()` failing when only one cell (or a block with a single land cell) had data, and pass `broad` and `class_names` through for region series.
* Fix `delta_downscale()` without a high resolution landmask, and interpolate gaps in all time steps rather than only the first.
* Fix `update_dataset_list()`, which failed to install and use a newer dataset list.
* Fix the names of monthly variables downloaded for WorldClim future datasets.
* Fix the check for incomplete WorldClim present archives, and stop with a clear error when PaleoClim downloads fail.
* `get_time_bp_steps()` and `get_resolution()` now use the current (possibly updated) dataset list.
* Other minor fixes to input checks and error messages.

# pastclim 2.2.0
* Add functions to perform delta downscale of climate data.
* Fix CHELSA paths to match new URLs.

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
