#' Validate an netcdf file for pastclim
#'
#' This function validates a netcdf file as a potential dataset for `pastclim`.
#' The key checks are:
#' a) that the dimensions (longitude, latitude and time) have been set correctly.
#' b) that all variables have the appropriate metadata (longname and units)
#'
#' @param path_to_nc path to the nc file of interest
#' @returns TRUE if the file is valid.
#'
#' @export

validate_nc <- function(path_to_nc) {
  # check that file exists
  if (!file.exists(path_to_nc)) {
    stop("The provided path_to_nc is not valid.")
  }
  # check dimension names
  nc_in <- ncdf4::nc_open(path_to_nc)
  if (!any(
    all(c("longitude", "latitude", "time") %in% names(nc_in$dim)),
    all(c("lon", "lat", "time") %in% names(nc_in$dim))
  )
  ) {
    ncdf4::nc_close(nc_in)
    stop("the dimension names should be: longitude, latitude and time")
  }
  # check that time has the correct units of 'years since XXXX'
  if (identical(grep(pattern = "^years since", nc_in$dim$time$units), integer(0))) {
    ncdf4::nc_close(nc_in)
    stop(
      "the time units should start with 'years since', but this file has\n",
      "'", nc_in$dim$time$units, "'"
    )
  }
  if (nc_in$dim$time$units == "years since present") {
    ncdf4::nc_close(nc_in)
    stop(
      "the time units are 'years since present'.\n",
      "terra interprets 'present' as 1970, which differs from the more\n",
      "usual 1950 used for radiocarbon dates. To avoid errors, define\n",
      "explicitely the reference date, e.g. 'years since 1950'"
    )
  }


  # check that each variable has a longname (units could be
  # empty for categorical variables or variables that are unitless)
  for (i in names(nc_in$var)) {
    if (nchar(nc_in$var[[i]]$longname) == 0) {
      ncdf4::nc_close(nc_in)
      stop("for ", i, " the longname is not given")
    }
  }

  # at some point, check that we have units that can be converted to pretty labels

  ncdf4::nc_close(nc_in)
  return(TRUE)
}
