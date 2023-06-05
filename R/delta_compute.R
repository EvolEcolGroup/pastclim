#' Compute a delta raster.
#'
#' This function generates a delta (difference) raster, computed as the difference between
#' model estimates (`x`) and some observations (`high_res_obs`). `x` is a 
#' [`terra::SpatRaster`] of the variable we want to downscale, and it 
#' can contain multiple time steps. `ref_time` sets the time slice for which
#' the delta should be computed. 
#' 
#' If `obs` has a higher
#' resolution than `x`, the latter is interpolated using a bilinear algorithm.
#' For areas that are present in some time slices, but not in the observations
#' (e.g. due to sea level change), the delta map is extended to cover the maximum
#' cumulative land mask (over all time steps) using inverse distance weighted
#' interpolation.
#'
#' @param x a [`terra::SpatRaster`] for the variable of interest, with all
#' time steps of interest
#' @param ref_time the time (BP) of the slice that is used to compute the delta
#' @param obs the observations
#' @returns a [`terra::SpatRaster`] of the delta
#' @keywords internal

delta_compute <- function(x, ref_time, obs) {
  message("This function is still under development; do not use it for real analysis")
  ref_index <- which(time_bp(x)==ref_time)
  if(length(ref_index)!=1){
    stop("ref_time should be a time in x")
  }
  x_modern<-x[[ref_index]]
  if (terra::nlyr(obs)>1){
    stop("obs should only contain one layer of observations")
  }
  if (terra::ext(obs)!=terra::ext(x_modern)){
    stop("x_modern and high_res_obs don't have the same extent")
  }
  # disaggregate the x_modern SpatRaster to the resolution of
  # the high res with "bilinear" interpolation
  x_modern_high<-disagg(x_modern, fact = round(terra::res( x_modern)/terra::res(obs)),
                        method="bilinear")
  # compute anomalies against the modern
  delta <- obs - x_modern_high
  # mask for maximum land extent
  max_land <- max(x,na.rm=TRUE)
  max_land <- disagg(max_land, fact = round(terra::res( x)/terra::res(obs)),
                     method="near")
  delta_interp <- idw_interp(delta,max_land)
  return(delta_interp)
}
