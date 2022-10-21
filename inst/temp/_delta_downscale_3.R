#' Compute a delta raster.
#'
#' This function generates a delta (difference) raster, computed as the difference between
#' model estimates (`x`) and some observations (`high_res_obs`). `x` is a 
#' \code{terra::SpatRaster} of the variable we want to downscale, and it 
#' can contain multiple time steps. `ref_time` sets the time slice for which
#' the delta should be computed. 
#' 
#' If `obs` has a higher
#' resolution than `x`, the latter is interpolated using a bilinear algorithm.
#' For areas that are present in some time slices, but not in the observations
#' (e.g. due to sea level change), the delta map is extended to cover the maximum
#' cumulative land mask (over all time steps) using idw.
#'
#' @param x a \code{terra::SpatRaster} for the variable of interest, with all
#' time steps of interest
#' @param ref_time the time of the slice that is used to compute the delta
#' @param obs the observations
#'
#' @export

delta_compute <- function(x, ref_time, obs) {
  ref_index <- which(time(x)==ref_time)
  if(length(ref_index)!=1){
    stop("ref_time should be a time in x")
  }
  x_modern<-x[[ref_index]]
  if (terra::ext(obs)!=terra::ext(x_modern)){
    stop("x_modern and high_res_obs don't have the same extent")
  }
  # disaggregate the x_modern SpatRaster to the resolution of
  # the high res with "bilinear" interpolation
  x_modern_high<-disagg(x_modern, fact = terra::res( x_modern)/terra::res(obs),
         method="bilinear")
  # compute anomalies against the modern
  delta <- x_modern_high - obs
  # mask for maximum land extent
  max_land <- max(x,na.rm=TRUE)
  max_land <- disagg(max_land, fact = terra::res( x)/terra::res(obs),
                     method="near")
  delta_interp <- idw_interp(delta,max_land)
  return(delta_interp)
}


delta_downscale <- function(x, delta_rast,  x_landmask_high=NULL) {
  # check that extent and resolutions are compatible
  if (terra::ext(delta_rast)!=terra::ext(x)){
    stop("x and delta_rast don't have the same extent")
  }
  
  # downscale x with bilinear
  x_high <- disagg(x, fact = terra::res( x)/terra::res(delta_rast),
                        method="bilinear")
  # apply the delta_rast to x
  x_high <- x_high + delta_rast
  
  ##TODO
  ## Now loop over each layer of x_high, and run idw_gap
  
  if(!is.null(x_landmask_high)){
    #refine the landmask in x_high
    
    
    # fill in any gaps that resulted from this step with idw
  }

  
}

#' Create a land mask
#'
#' Create a land mask for a given time step
#'
#' @param topo_rast a \code{terra::SpatRaster} with topography
#' @param sea_level a vector of sea levels for each time step of interest
#'
#' @keywords internal

make_land_mask <- function(topo_rast, sea_level) {

  
}

#' Create a binary mask
#'
#' Create a binary mask where NAs are 0 and values are 1
#'
#' @param x a \code{terra::SpatRaster}
#'
#' @keywords internal

make_binary_mask <- function (x){
  x[!is.na(x)]<-1
  x[is.na(x)]<-0
  return(x)
}

#' Interpolate x to match mask y
#'
#' Fill in x to match cells in y, using iwd interpolation
#'
#' @param x the \code{terra::SpatRaster} of the variable of interest
#' @param x the \code{terra::SpatRaster} giving the land mask
#' 
#' @keywords internal

idw_interp <- function(x, y, ...){
  # first mask x with y
  x<-terra::mask(x,y)
  x_bin <- make_binary_mask(x)
  y_bin <- make_binary_mask(y)
  # delta gap (pixels for which we don't have a delta values)
  x_gap <- y_bin - x_bin
  x_gap[x_gap==0]<-NA
  x_df <- terra::as.data.frame(x,xy=TRUE,na.rm=TRUE)
  x_gap_df <- terra::as.data.frame(x_gap, xy=TRUE, na.rm=TRUE)
  names(x_df)[3] <-"this_var"
  names(x_gap_df)[3] <-"this_var"
  # interpolate those gaps with idw (time consuming...)
  # add ... to the function to be able to take additional params to gstat
  idw_obj <- gstat::gstat(formula = this_var~1, locations = ~x+y, data = x_df, nmax=7,
                          set=list(idp = .5))
  idw_pred <- predict(idw_obj, newdata = x_gap_df)[,-4] # remove the last column
  x_gap_vals <- terra::rast(idw_pred,type="xyz")
  x_gap_vals <- terra::extend(x_gap_vals, x)
  browser()
  x_extended <- terra::merge(x, x_gap_vals)
  return(x_extended)
}
