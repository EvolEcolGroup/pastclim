#' Load a variable from WorldClim modern observations.
#'
#' This function loads previously downloaded annual and monthly variables 
#' from the WorldClim 2.1 dataset. To save the variables in a compatible
#' format, use [download_worldclim()].
#' 
#' The function assumes that the file name is in the format "wc*version*_*res*m_*var*.nc".
#' For example, average temperature downloaded at 10 minutes resolution will be
#' "*wc21_10m_tavg.nc*".
#'
#' @param var	character Valid variables names are "tmin", "tmax", "tavg", 
#' "prec", "wind", "vapr", and "bio".
#' @param res	numeric Valid resolutions are 10, 5, 2.5, 
#' and 0.5 (minutes of a degree)
#' @param path	character. Path where the dataset is stored. If left NULL, the data
#' will be downloaded from the directory returned by [get_data_path()]
#' @param version	character or numeric. WorldClim version number. Only "2.1" supported at the moment
#' @returns a [`terra::SpatRaster`] with the requested WorldClim variable
#'
#' @keywords internal

load_worldclim <- function(var, res, path=NULL, version="2.1", ...) {

  if (is.null(path)){
    path <- get_data_path()
  } else {
    if (!dir.exists(path)){
      stop("the provided path does not exist")
    }
  }
  wc_file_name <- paste0("wc",version,"_",res,"m_",var,".nc")
  wc_full_path<-file.path(path,wc_file_name)
  if (!file.exists(wc_full_path)){
    stop(wc_full_path," does not exist; use download_wordclim() to download it")
  }
  
  worldclim_rast <- terra::rast(wc_full_path)
  # turn this into a valide region_slice
  time_bp(worldclim_rast)<- rep(0,terra::nlyr(worldclim_rast))
  return(worldclim_rast)
}
