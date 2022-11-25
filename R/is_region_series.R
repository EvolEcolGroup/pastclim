#' Check the object is a valid region series
#'
#' A region series is a \code{terra::SpatRasterDataset} for which each
#' subdataset is a variable, and all variables have the same number of 
#' time steps.
#' 
#' The standard test only checks that each SpatRaster has the same number of
#' layers. The more thorough test (obtainedwith strict=TRUE) actually checks
#' that all time steps are identical by comparing the result of 
#' \code{terra::time} applied to each variable
#'
#' @param x a \code{terra::SpatRasterDataset} representing a time series of
#' regional reconstructions obtained from \code{region_series}.
#' @param strict a boolean defining whether to preform a thorough test (see
#' description above for details).
#'
#' @export

is_region_series <- function (x, strict = FALSE) {
  if (!inherits(x,"SpatRasterDataset")){
    stop("x should be a SpatRasterDataset")
  }
  if (!strict){
    return (length(unique(terra::nlyr(x)))==1)
  } else {
    all_times<-list()
    for (i in terra::varnames(x)){
      all_times[[i]] <- time_bp(x[i])
    }
    return(length(unique(all_times))==1)
  }
}
