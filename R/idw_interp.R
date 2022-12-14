#' Interpolate x to match mask y
#'
#' Fill in x to match cells available in y, using iwd (inverse-weighted
#' distance) interpolation. Interpolation is fitted using \code{gstat::gstat};
#' the default parameters for \code{gstat::gstat} are nmax=7 and idp = .5, but
#' can be changed by providing arguments to this function (which will be passed
#' to \code{gstat::gstat}). See \code{gstat::gstat} for details on the available
#' parameters and their meaning.
#'
#' @param x the \code{terra::SpatRaster} of the variable of interest
#' @param y the \code{terra::SpatRaster} the reference mask defining which
#' cells should have values
#' @param nmax the number of nearest observations that should be used for a
#'  kriging prediction or simulation, where nearest is defined in terms
#'  of the space of the spatial locations (see \code{gstat::gstat} for details)
#' @param set named list with optional parameters to be passed to gstat 
#' (only set commands of gstat are allowed, and not all of them may be
#' relevant; see the gstat manual for gstat stand-alone, URL and more details
#' in the \code{gstat::gstat} help page)
#' @param ... further parameters to be passed to \code{gstat::gstat}
#' 
#' @keywords internal

idw_interp <- function(x, y, nmax=7, set=list(idp = .5), ...){
  # first mask x with y (i.e. remove parts of y not found in the mask y)
  x<-terra::mask(x,y)
  x_bin <- make_binary_mask(x)
  y_bin <- make_binary_mask(y)
  # delta gap (pixels for which we don't have a delta values)
  x_gap <- y_bin - x_bin
  x_gap[x_gap==0]<-NA
  x_df <- terra::as.data.frame(x,xy=TRUE,na.rm=TRUE)
  x_gap_df <- terra::as.data.frame(x_gap, xy=TRUE, na.rm=TRUE)
  # if there is not gap between the values and the mask, just return the values
  if (nrow(x_gap_df)==0){
    return(x)
  }
  names(x_df)[3] <-"this_var"
  names(x_gap_df)[3] <-"this_var"
  # interpolate those gaps with idw (time consuming...)
  # add ... to the function to be able to take additional params to gstat
  idw_obj <- gstat::gstat(formula = this_var~1, locations = ~x+y, 
                          data = x_df, nmax=nmax,
                          set=set, ...)
  idw_pred <- predict(idw_obj, newdata = x_gap_df,
                      debug.level=0)[,-4] # remove the last column
  x_gap_vals <- terra::rast(idw_pred,type="xyz",crs=crs(x))
  x_gap_vals <- terra::extend(x_gap_vals, x)
  # now extend x to include the x_gap_vals
  x_extended <- sum(x,x_gap_vals,na.rm=TRUE)
  return(x_extended)
}
