#' Download a WorldClim modern observations.
#'
#' This function downloads annual and monthly variables from the Worldclim 2.1 dataset.
#' These variables are saved in a format that can be read by 
#' \code{load_worldclim}, and easily used for delta downscaling paleoclimate
#' observations
#' 
#' This function uses \code{geodata::worldclim_global} to download the data, and
#' then converts them into a \code{terra::SpatRaster} in a format compatible
#' with `pastclim`
#'
#' @param var	character Valid variables names are "tmin", "tmax", "tavg", 
#' "prec", "wind", "vapr", and "bio".
#' @param res	numeric Valid resolutions are 10, 5, 2.5, 
#' and 0.5 (minutes of a degree)
#' @param path	character. Path where to download the data to, If left NULL, the data
#' will be downloaded from the directory returned by \code{get_data_path()}
#' @param version	character or numeric. WorldClim version number. Only "2.1" supported at the moment
#' @param ... additional arguments passed to download.file
#' @returns a \code{terra::SpatRaster} with the requested worldclim variable
#'
#' @keywords internal

download_worldclim <- function(var, res, path=NULL, version="2.1", ...) {

  if(!requireNamespace("geodata", quietly=TRUE)){
    message("This function requires the 'geodata' package; install it with:\n",
            "install.packages('marmap')")
    return(invisible())
  }
  if (is.null(path)){
    path <- get_data_path()
  } else {
    if (!dir.exists(path)){
      stop("the provided path does not exist")
    }
  }
  #browser()
  wc_file_name <- paste0("wc",version,"_",res,"m_",var,".nc")
  wc_full_path<-file.path(path,wc_file_name)
  if (file.exists(wc_full_path)){
    message(wc_full_path," already exists")
    return(FALSE)
  }
  
  wc_rast<-geodata::worldclim_global(var=var, res=res, path=tempdir(), version="2.1")
  terra::writeCDF(wc_rast,file.path(path, wc_file_name),
                  compression=9)
  return(TRUE)
}
