#' Load the ETOPO global relief
#'
#' This function loads previously downloaded ETOPO 2022 global relief dataset, at
#' 30 arcsec resolution. To save the variables in a compatible
#' format, use [download_etopo()].
#' 
#' The function assumes that the file name is *etopo2022_30s_v1.nc*
#'
#' @param path	character. Path where the dataset is stored. If left NULL, the data
#' will be downloaded from the directory returned by [get_data_path()]
#' @param version	character or numeric. The ETOPO2022 version number. 
#' Only "1" supported at the moment
#'
#' @keywords internal

load_etopo <- function(path=NULL, version="1") {

  if (is.null(path)){
    path <- get_data_path()
  } else {
    if (!dir.exists(path)){
      stop("the provided path does not exist")
    }
  }
  etopo_file_name <- paste0("etopo2022_30s_",version,".nc")
  etopo_full_path<-file.path(path,etopo_file_name)
  if (!file.exists(etopo_full_path)){
    stop(etopo_full_path," does not exist; use download_etopo() to download it")
  }
  
  etopo_rast <- terra::rast(etopo_full_path)
  time_bp(etopo_rast) <- 0
  return(etopo_rast)
}
