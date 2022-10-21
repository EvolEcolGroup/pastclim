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