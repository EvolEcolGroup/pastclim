#' Download the ETOPO Global relief model
#'
#' This function downloads the ETOPO2022 global relief model at 30 arcsec 
#' resolution. This is a large file (>1Gb), and is worth downloading only 
#' if you are planning to use it repeatedly. If you only need a subregion, 
#' especially at lower resolution, it is worth using [download_etopo_subset()],
#' which fetches a subset of the dataset on the fly from the NOAA server. 
#' 
#' @param path	character. Path where to download the data to. If left NULL, the data
#' will be downloaded from the directory returned by [get_data_path()]
#' @returns TRUE if the dataset was downloaded successfully
#'
#' @keywords internal

download_etopo <- function(path = NULL){
  
  if (is.null(path)){
    path <- get_data_path()
  } else {
    if (!dir.exists(path)){
      stop("the provided path does not exist")
    }
  }
  
  etopo_url <- "https://www.ngdc.noaa.gov/thredds/fileServer/global/ETOPO2022/30s/30s_bed_elev_netcdf/ETOPO_2022_v1_30s_N90W180_bed.nc"
  # download the files
  curl::multi_download(etopo_url,
                       destfile = file.path(path,"etopo2022_30s_v1.nc")
  )
}