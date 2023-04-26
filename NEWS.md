# pastclim 1.2.4
* Updates on how time is handled to stay in sync with changes in `terra`.

# pastclim 1.2.3
* Added lai to Krapp2021 (the variable is now also present in the original OSF
  repository for that dataset).
* Change column names in data.frame returned by location_series to match
  location_slice
* Allow for interpolation of nearest neighbours in location_series, and allow
  for a buffer on estimates returned by the location_* functions.

# pastclim 1.2.2
* Update of Krapp2021 files to make them compatible with how terra now handles
  time. Users will have to re-download datasets. Old files can be removed with
  'clean_data_path()'

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
  by R>=4.0.0. This removes the need of re-downloading the data when upgrading R.

* Add monthly variables to Beyer2020 and Krapp2021.

# pastclim 1.0.1

* Fix bug when information was extracted for just one location.

# pastclim 1.0.0

* Initial public release
