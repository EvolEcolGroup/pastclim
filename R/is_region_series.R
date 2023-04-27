#' Check the object is a valid region series
#'
#' A region series is a [`terra::SpatRasterDataset`] for which each
#' sub-dataset is a variable, and all variables have the same number of 
#' time steps.
#' 
#' The standard test only checks that each SpatRaster has the same number of
#' layers. The more thorough test (obtained with strict=TRUE) actually checks
#' that all time steps are identical by comparing the result of 
#' [terra::time()] applied to each variable
#'
#' @param x a [`terra::SpatRasterDataset`] representing a time series of
#' regional reconstructions obtained from [region_series()].
#' @param strict a boolean defining whether to preform a thorough test (see
#' description above for details).
#' @returns TRUE if the object is a region series
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
      # TODO we should check that each variable has years as its units
    }
    return(length(unique(all_times))==1)
  }
}
