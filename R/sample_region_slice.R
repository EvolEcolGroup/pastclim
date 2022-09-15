#' Sample points from a region time slice
#'
#' This function samples points from a region time slice (i.e. a timepoint).
#' 
#' This function wraps \code{terra::spatSample} to appropriate sample the
#' \code{terra::spatRaster} returned
#' by \code{region_slice}. You can also use \code{terra::spatSample} directly
#' on a slice (which is a standard \code{terra::spatRaster}).
#'
#' @param x a \code{terra::spatRaster} returned
#' by \code{region_slice}
#' @param size number of points sampled.
#' @param method one of the sampling methods from \code{terra::spatSample}. It
#' defaults to "random"
#' @param replace boolean determining whether we sample with replacement
#' @param na.rm boolean determining whether NAs are removed
#'
#' @export

sample_region_slice<-function(x, size, method="random", replace=FALSE, na.rm=TRUE)
{
  if (length(size)!=1)
  {
    stop("size should be a single value")
  }
  terra::spatSample(x, size, method=method, replace=replace, na.rm=na.rm,
                    cells = TRUE, xy = TRUE)
} 
