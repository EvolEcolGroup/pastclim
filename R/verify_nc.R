#' Validate an netcdf file for pastclim
#' 
#' This function validates a netcdf file as a potential dataset for `pastlim`.
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
  if (!file.exists(path_to_nc)){
    stop("The provided path_to_nc is not valid.")
  }
  # check dimension names
  nc_in<-ncdf4::nc_open(path_to_nc)
  if (!any(all(c("longitude","latitude","time") %in% names(nc_in$dim)),
           all(c("lon","lat","time") %in% names(nc_in$dim)))
      ){
    ncdf4::nc_close(nc_in)
    stop("the dimension names should be: longitude, latitude and time")
  }
  # check that variable time has the correct units (not obligatory, but give
  # a warning)
  if (nc_in$dim$time$units!="years since 1950-01-01 00:00:00.0"){
    if (nc_in$dim$time$units=="years since present"){
      ncdf4::nc_close(nc_in)
      stop("The time units are 'years since present'.\n",
           "terra interprets 'present' as 1970, which differs from the more\n",
           "usual 1950. Ideally define explicitely the reference date,e.g.:\n",
           "years since 1950-01-01 00:00:00.0")
    }
    warning("The time units are not 'years since 1950-01-01 00:00:00.0.\n",
            "This is not fatal, but can in some instances lead to problems.")
  }
  
  # check that each dimension has a longname (units could be
  # empty for categorical variables or variables that are unitless)
  for (i in names(nc_in$var)){
    if (nchar(nc_in$var[[i]]$longname)==0){
      ncdf4::nc_close(nc_in)
      stop("for ",i," the longname is not given")
    }
  }
  
  # at some point, check that we have units that can be converted to pretty labels
  
  ncdf4::nc_close(nc_in)
  return(TRUE)
}
