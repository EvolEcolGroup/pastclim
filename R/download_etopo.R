#' Download the ETOPO Global relief model
#'
#' This function downloads the ETOPO2022 global relief model at 30 or 60 arcsecs 
#' resolution. This is a large file (>1Gb), and is worth downloading only 
#' if you are planning to use it repeatedly. 
#' 
#' @param path	character. Path where to download the data to. If left NULL, the data
#' will be downloaded from the directory returned by [get_data_path()], and automatically
#' named "etopo2022_{resolution}s_v1.nc"
#' @param resolution numeric resolution in arcsecs (one of 30, or 60).
#' Defaults to 60 arcsecs.
#' @returns a dataframe produced by [curl::multi_download()] with information about
#' the download (including error codes)
#'
#' @keywords internal

download_etopo <- function(path = NULL, resolution=60){
  
  if (is.null(path)){
    path <- get_data_path()
  } else {
    if (!dir.exists(path)){
      stop("the provided path does not exist")
    }
  }
  
  if (resolution==30){
    etopo_url <- "https://www.ngdc.noaa.gov/thredds/fileServer/global/ETOPO2022/30s/30s_bed_elev_netcdf/ETOPO_2022_v1_30s_N90W180_bed.nc"
  } else if (resolution==60){
    etopo_url <- "https://www.ngdc.noaa.gov/thredds/fileServer/global/ETOPO2022/60s/60s_bed_elev_netcdf/ETOPO_2022_v1_60s_N90W180_bed.nc"
  } else {
    stop("resolution should be one of 30 or 60 arcsecs")
  }

  # download the files
  res <- curl::multi_download(etopo_url,
                       destfile = file.path(path,paste0("etopo2022_",resolution,"s_v1.nc"))
  )
  if(!res$success){
    warning("the download failed!")
  } else{
    message("the download was successul; access the relief data with `load_etopo()`")
  }
  res
}
