#' Downscale using the delta method
#'
#' The delta method computes the difference between an observed raster and the
#' equivalent predictions from a model for a given time step, and then applies
#' that difference (delta) to all other time steps. You will first need to
#' create the delta raster with [pastclim::delta_compute()], and thus use it
#' as an argument for this function.
#'
#' It is possible to also provide a high resolution landmask to this function.
#' For cells which are not included in the original simulation (e.g. because
#' the landmask was discretised at lower resolution), an inverse
#' distance weighted algorithm (as implemented in [gstat::gstat()]) is used
#' to interpolate the missing values. See the manpage for [gstat::gstat()]
#' for more parameters that can change the behaviour of the iwd interpolation.
#'
#' @param x a [`terra::SpatRaster`] for the variable of interest, with all
#' time steps of interest
#' @param delta_rast a [`terra::SpatRaster`] generated by
#' \code{pastclim::delta_compute}
#' @param x_landmask_high a [`terra::SpatRaster`] with the same number of layers
#' as x. If left NULL, the original landmask of x is used.
#' @param range_limits range to which the downscaled reconstructions
#' are forced to be within (usually based on the observed values). Ignored if
#' left to NULL.
#' @param nmax the number of nearest observations that should be used for a
#'  kriging prediction or simulation, where nearest is defined in terms
#'  of the space of the spatial locations (see [gstat::gstat()] for details)
#' @param set named list with optional parameters to be passed to gstat
#' (only set commands of gstat are allowed, and not all of them may be
#' relevant; see the gstat manual for gstat stand-alone, URL and more details
#' in the [gstat::gstat()] help page)
#' @param ... further parameters to be passed to [gstat::gstat()]
#' @returns a [`terra::SpatRaster`] of the downscaled variable, where each
#' layers is a time step.
#' @export


delta_downscale <- function(x, delta_rast, x_landmask_high = NULL,
                            range_limits = NULL,
                            nmax = 7, set = list(idp = .5), ...) {
  # sort out the extents
  # the extent of the delta rast wins as we sorted it out in delta_compute
  x <- resample(x, delta_rast)
  x_landmask_high <- resample(x_landmask_high, delta_rast)

  # check that extent and resolutions are compatible
  if (terra::ext(delta_rast) != terra::ext(x)) {
    stop("x and delta_rast don't have the same extent")
  }
  if (!is.null(x_landmask_high)) {
    if (!all(
      (terra::ncol(delta_rast) == terra::ncol(x_landmask_high)),
      (terra::nrow(delta_rast) == terra::nrow(x_landmask_high))
    )) {
      stop(
        "delta_rast and x_landmask_high should have the same number of rows\n",
        "and columns"
      )
    }
  }

  # downscale x with bilinear if needed
  disagg_fact <- round(terra::res(delta_rast) / terra::res(x))
  if (!all(disagg_fact == 1)) {
    x_high <- disagg(x,
      fact = round(terra::res(x) / terra::res(delta_rast)),
      method = "bilinear"
    )
  } else {
    x_high <- x
  }

  # apply the delta_rast to x
  x_high <- x_high + delta_rast

  ## Now loop over each layer of x_high, and run idw_gap to match the high
  ## resolution mask

  if (!is.null(x_landmask_high)) {
    # refine the landmask in x_high
    x_high <- mask(x_high, x_landmask_high)
    # fill in any gaps that resulted from this step with idw
    for (i in seq_along(terra::nlyr(x_high))) {
      x_high[[i]] <- idw_interp(x_high[[i]], x_landmask_high[[i]],
        nmax = nmax, set = set, ...
      )
    }
  }
  if (!is.null(range_limits)) {
    x_high[x_high < range_limits[1]] <- range_limits[1]
    x_high[x_high > range_limits[2]] <- range_limits[2]
  }
  return(x_high)
}
