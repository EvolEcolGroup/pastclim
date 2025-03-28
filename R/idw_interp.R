#' Interpolate x to match mask y
#'
#' Fill in x to match cells available in y, using inverse distance weighted
#' interpolation. Interpolation is fitted using [gstat::gstat()];
#' the default parameters for [gstat::gstat()] are "nmax=7" and "idp=.5", but
#' can be changed by providing arguments to this function (which will be passed
#' to [gstat::gstat()]). See [gstat::gstat()] for details on the available
#' parameters and their meaning.
#'
#' @param x the [`terra::SpatRaster`] of the variable of interest
#' @param y the [`terra::SpatRaster`] the reference mask defining which
#' cells should have values
#' @param nmax the number of nearest observations that should be used for a
#'  kriging prediction or simulation, where nearest is defined in terms
#'  of the space of the spatial locations (see [gstat::gstat()] for details)
#' @param set named list with optional parameters to be passed to gstat
#' (only set commands of gstat are allowed, and not all of them may be
#' relevant; see the gstat manual for gstat stand-alone, URL and more details
#' in the [gstat::gstat()] help page)
#' @param ... further parameters to be passed to [gstat::gstat()]
#' @returns a [`terra::SpatRaster`] of the interpolated version of *x*
#'
#' @keywords internal

idw_interp <- function(x, y, nmax = 7, set = list(idp = .5), ...) {
  # first mask x with y (i.e. remove parts of y not found in the mask y)
  x <- terra::mask(x, y)
  x_bin <- make_binary_mask(x)
  y_bin <- make_binary_mask(y)
  # x gap (pixels for which we don't have a x values)
  x_gap <- y_bin - x_bin
  x_gap[x_gap == 0] <- NA
  x_df <- terra::as.data.frame(x, xy = TRUE, na.rm = TRUE)
  x_gap_df <- terra::as.data.frame(x_gap, xy = TRUE, na.rm = TRUE)
  # if there is not gap between the values and the mask, just return the values
  if (nrow(x_gap_df) == 0) {
    return(x)
  }
  names(x_df)[3] <- "this_var"
  names(x_gap_df)[3] <- "this_var"
  # nolint start
  # interpolate those gaps with idw (time consuming...)
  # it might make sense to parallelise this as shown here:
  # https://gis.stackexchange.com/questions/237672/how-to-achieve-parallel-kriging-in-r-to-speed-up-the-process
  # or even better, there is a powerful cpp version here:
  # https://geobrinkmann.com/post/iwd/
  # add ... to the function to be able to take additional params to gstat
  # nolint end
  idw_obj <- gstat::gstat(
    formula = this_var ~ 1, locations = ~ x + y,
    data = x_df, nmax = nmax,
    set = set, ...
  )
  idw_pred <- predict(idw_obj,
    newdata = x_gap_df,
    debug.level = 0
  )[, -4] # remove the last column
  x_gap_vals <- terra::rast(idw_pred, type = "xyz", crs = crs(x))
  x_gap_vals <- terra::extend(x_gap_vals, x)
  # now extend x to include the x_gap_vals
  x_extended <- sum(x, x_gap_vals, na.rm = TRUE)
  return(x_extended)
}
