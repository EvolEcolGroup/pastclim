#' Extract a slice for a time series of climate variables for a region
#'
#' This function extracts a time slice from time series of one or more climate
#' variables for a given dataset covering a region (or the whole world).
#'
#' @param x time series generated with \code{region_series}
#' @param time_bp time slices in years before present (i.e. 1950, negative integers
#' for values in the past). The slices
#' need to exist in the dataset. To check which slices are available, you
#' can use \code{terra::time(x[[1]])} (note that you have to use
#' the `time` function on the first element of the 'sds' object, i.e. on one
#' of the 'SpatRaster' objects)
#'
#' @export

slice_region_series <- function(x, time_bp) {
  if (length(time_bp) != 1) {
    stop("time_bp should be a single time step")
  }
  # check that time_bp is part of the series
  if (!time_bp %in% time(x[[1]])) {
    stop("time_bp is not a time slice within the region series x")
  }
  # get index
  time_index <- which(time(x[[1]]) == time_bp)
  # now slice it and convert it to a Spatraster
  for (i in 1:length(x)) {
    if (i == 1) {
      climate_spatraster <- subset(x[[i]], time_index)
    } else {
      terra::add(climate_spatraster) <- subset(x[[i]], time_index)
    }
  }
  names(climate_spatraster) <- varnames(climate_spatraster) #<- names(x)
  return(climate_spatraster)
}
