#' Download a relief dataset.
#'
#' This function downloads a relief (topography+bathymetry) dataset from the
#' ETOPO2022 dataset.
#' 
#' This function uses [marmap::getNOAA.bathy()] to download the data, and
#' then converts them into a [`terra::SpatRaster`] formatted to be compatible
#' with `pastclim`
#'
#' @param rast_template a [`terra::SpatRaster`] providing the extent and
#' resolution to be downloaded. This raster needs to have identical vertical
#' and horizontal resolution, and standard lat/long projection.
#' @param ... additional parameters to be passed to [marmap::getNOAA.bathy()]
#' to customise how files are stored. See the manpage for that function for
#' details
#' @returns a [`terra::SpatRaster`] with the relief for the chosen region
#'
#' @keywords internal

download_relief <- function(rast_template, ...) {

  if(!requireNamespace("marmap", quietly=TRUE)){
    message("This function requires the 'marmap' package; install it with:\n",
            "install.packages('marmap')")
    return(invisible())
  }

    # check that this works, I think there might be issues with decimal places
  if (!all.equal(terra::res(rast_template)[1],terra::res(rast_template)[2])){
    stop("rast_template should have identical vertical and horizontal resolution")
  }

  relief_bathy<- marmap::getNOAA.bathy(lon1 = terra::ext(rast_template)[1],
                lon2 = terra::ext(rast_template)[2],
                lat1 = terra::ext(rast_template)[3],
                lat2 = terra::ext(rast_template)[4],
                # note that resolution in marmap is in minutes, and in degrees for terra
                resolution = terra::res(rast_template)[1]*60, ...)
  relief_rast <- bathy_to_spatraster(relief_bathy)
  # ideally check if there are any differences (due to rounding problems or corners),
  # and then resample the relief to match the template exactly
  if (!all(terra::ext(relief_rast)==terra::ext(rast_template),
           terra::ncol(relief_rast)==terra::ncol(rast_template),
           terra::nrow(relief_rast)==terra::nrow(rast_template))){
    relief_rast <- terra::resample(relief_rast,rast_template)
  }
  longnames(relief_rast)<-"relief from ETOPO2022"
  varnames(relief_rast)<-"relief"
  names(relief_rast)<-"relief"
  units(relief_rast)<-"m"
  return(relief_rast)
}
