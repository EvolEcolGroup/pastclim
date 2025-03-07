#' Create a binary mask
#'
#' Create a binary mask from a raster: NAs are converted to 0s, and
#' any other value to 1.
#'
#' @param x a [`terra::SpatRaster`]
#' @returns a [`terra::SpatRaster`] with 0s and 1s
#'
#' @keywords internal

make_binary_mask <- function(x) {
  x <- as.numeric(x)
  x[!is.na(x)] <- 1
  x[is.na(x)] <- 0
  return(x)
}
