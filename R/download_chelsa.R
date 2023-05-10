#' Download the CHELSA modern observations.
#'
#' This function downloads monthly variables from the CHELSA 2.1 dataset.
#' These variables are saved in a format that can be read by 
#' load_chelsa, and easily used for delta downscaling palaeoclimate
#' observations.
#' 
#' Note that variables are named differently from Worldclim. "tas" is the mean
#' temperature ("tavg" in worldclim), with "tasmax" and "tasmin" being equivalent
#' to "tmax" and "tmin".
#' 
#' @param var	character Valid variables names are "tas", "tasmax","tasmin", and
#' "prec".
#' @param path	character. Path where to download the data to. If left NULL, the data
#' will be downloaded from the directory returned by [get_data_path()]
#' @returns TRUE if the requested CHELSA variable was downloaded successfully
#'
#' @keywords internal

download_chelsa <- function(var, res, path=NULL, version="2.1", ...) {

  if (!var %in% c("tas","tasmax","taxmin", "prec")){
    stop ('Valid variables names are "tas", "tasmax","tasmin", and "prec".')
  }
    
  if (is.null(path)){
    path <- get_data_path()
  } else {
    if (!dir.exists(path)){
      stop("the provided path does not exist")
    }
  }
  
  month_values <- sprintf("%02d",1:12)
  chelsa_filenames <- paste("CHELSA",var,month_values,"1981-2010_V.2.1.tif",sep="_")
  chelsa_urls <- paste0("https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/tas/",
                        chelsa_filenames)
  # create the destination directory if needed
  dir.create(file.path(tempdir(),"chelsa",var),showWarnings = FALSE, recursive = TRUE)
  # download the files
  curl::multi_download(chelsa_urls,
                       destfile = file.path(tempdir(),"chelsa",var,chelsa_filenames)
  )
  # combined them into a single raster object
  combined_rast <- terra::rast(file.path(tempdir(),"chelsa",var,chelsa_filenames))
  # save it as netcdf file
  chelsa_nc_name <- paste0("chelsa21_30sec_",var,".nc")
  terra::writeCDF(combined_rast,file.path(path, chelsa_nc_name),
                  compression=9)
}