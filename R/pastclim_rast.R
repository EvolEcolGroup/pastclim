#' Read a raster for pastclim
#'
#' This function is a wrapper around [terra::rast()], with additional logic
#' to correctly import time for vrt datasets (time is stored as custom metadata
#' in pastclim-generated vrt files)
#' @param x filename of the raster
#' @param bio_var the variable name of interest
#' @returns a [`terra::SpatRaster`]
#'
#' @keywords internal
pastclim_rast <- function (x, bio_var){
  # retrieve time axis for virtual file
  if (substr(x,nchar(x)-2,nchar(x))=="vrt"){
    var_rast <- terra::rast(x, lyrs = bio_var)
    time_bp(var_rast) <- unique(vrt_get_times(x))
  } else {
    var_rast <- terra::rast(x, subds = bio_var)
  }
  return(TRUE)
}


