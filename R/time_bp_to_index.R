#' Convert a time BP to indexes in a netcdf file.
#'
#' Internal function
#'
#' @param time_bp vector of times BP
#' @param time_steps time steps for which reconstructions are available
#'
#' @keywords internal

time_bp_to_index <- function(time_bp, time_steps) {
  time_indeces <-
    sapply(time_bp, function(a, b) {
      which.min(abs(a - b))
    }, time_steps)
  return(time_indeces)
}
