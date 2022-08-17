#' Convert a time BP to indexes in a netcdf file.
#'
#' Internal function
#'
#' @param time_bp vector of times BP
#' @param path_to_nc path to nc file
#'
#' @keywords internal

time_bp_to_index <- function(time_bp, path_to_nc) {
  climate_nc <- ncdf4::nc_open(path_to_nc)
  time_steps <- (climate_nc$dim$time$vals)
  ncdf4::nc_close(climate_nc)
  time_indeces <-
    sapply(time_bp, function(a, b) {
      which.min(abs(a - b))
    }, time_steps)
  return(time_indeces)
}
