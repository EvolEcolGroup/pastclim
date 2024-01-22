#' Read a raster for pastclim
#'
#' This function is a wrapper around [terra::rast()], with additional logic
#' to correctly import time for vrt datasets (time is stored as custom metadata
#' in pastclim-generated vrt files)
#' @param x filename of the raster
#' @param bio_var_orig the variable name as present in the file
#' @param bio_var_pastclim the variable name as used by pastclim (thus allowing us
#' to rename the variable)
#' @returns a [`terra::SpatRaster`]
#'
#' @keywords internal
pastclim_rast <- function (x, bio_var_orig, bio_var_pastclim, var_longname = NULL, var_units = NULL){
  # if we have an nc file
  if (substr(x,nchar(x)-2,nchar(x))!="vrt"){
    var_rast <- terra::rast(x, subds = bio_var_orig)
    time_vector <- time_bp(var_rast)
  } else { #if we have a vrt file
    # check that the variable name is as expected
    vrt_meta <- vrt_get_meta(x)
    if (vrt_meta$description!=bio_var_orig){
      stop("the file ", x, " does not include the expected variable ", bio_var_orig)
    }
    time_vector <- vrt_meta$time_bp
    var_rast <- terra::rast(x)
    time_bp(var_rast) <- time_vector
  }
  # set the varnames and names for the raster
  varnames(var_rast)<-bio_var_pastclim
  names(var_rast)<- paste(bio_var_pastclim, time_vector,sep="_")
  if (!is.null(var_longname)){
    longnames(var_rast) <- var_longname
  }
  if (!is.null(var_units)){
    units(var_rast) <- var_units
  }
  return(var_rast)
}


