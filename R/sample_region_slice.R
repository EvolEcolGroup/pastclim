#' Sample points from a region time slice
#'
#' This function samples points from a region time slice (i.e. a time point).
#'
#' This function wraps [terra::spatSample()] to appropriate sample the
#' [`terra::SpatRaster`] returned
#' by [region_slice()]. You can also use [terra::spatSample()] directly
#' on a slice (which is a standard [`terra::SpatRaster`]).
#'
#' @param x a [`terra::SpatRaster`] returned
#' by [region_slice()]
#' @param size number of points sampled.
#' @param method one of the sampling methods from [terra::spatSample()]. It
#' defaults to "random"
#' @param replace boolean determining whether we sample with replacement
#' @param na.rm boolean determining whether NAs are removed
#' @returns a data.frame with the sampled cells and their respective values for
#' the climate variables.

#' @export

sample_region_slice <- function(x, size, method = "random", replace = FALSE, na.rm = TRUE) {
  if (length(size) != 1) {
    stop("size should be a single value")
  }
  # spatSample samples additional points to make sure it has enough points after
  # removing NA. The default exp=5 is not sufficient if size is very small.
  if ((size * 5) < 1000) {
    exp <- ceiling(1000 / size)
  } else {
    exp <- 5
  }
  terra::spatSample(x, size,
    method = method, replace = replace, na.rm = na.rm,
    cells = TRUE, xy = TRUE, exp = exp
  )
}
