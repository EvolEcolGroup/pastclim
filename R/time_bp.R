#' Extract time in years before present from SpatRaster
#'
#' A wrapper around \code{terra::time}, which converts time into years before
#' present
#'
#' @param x a \code{terra::SpatRaster}
#' @returns a date in years BP (where negative numbers indicate a date in the past)
#' @export


time_bp <- function(x){
  if (!inherits(x,"SpatRaster")){
    stop("x is not a SpatRaster")
  }
  if (timeInfo(x)$step != "years") {
    # this should be escalated to an error once terra can properly set times in years (it's in dev)
    warning("the time units of SpatRaster are not 'years'",
         " it might be a problem with the time units not being properly set in the original nc file")
  }
  time_yr<-terra::time(x)
  return(time_yr-1950)
}
