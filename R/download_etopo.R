#' Download the ETOPO Global relief model
#'
#' This function downloads the ETOPO2022 global relief model at
#' 0.5 or 1 arc-minute (i.e. 30 or 60 arc-seconds) resolution.
#' This is a large file (>1Gb).
#'
#' @param path	character. Path where to download the data to. If left NULL, the data
#' will be downloaded from the directory returned by [get_data_path()], and automatically
#' named `etopo2022_{resolution}s_v1.nc`
#' @param resolution numeric resolution in arc-minute (one of 0.5, or 1).
#' Defaults to 1 arc-minute.
#' @returns a dataframe produced by [curl::multi_download()] with information about
#' the download (including error codes)
#'
#' @keywords internal

download_etopo <- function(path = NULL, resolution = 1) {
  if (is.null(path)) {
    path <- get_data_path()
  } else {
    if (!dir.exists(path)) {
      stop("the provided path does not exist")
    }
  }

  if (resolution == 0.5) {
    etopo_url <- "https://www.ngdc.noaa.gov/thredds/fileServer/global/ETOPO2022/30s/30s_bed_elev_netcdf/ETOPO_2022_v1_30s_N90W180_bed.nc"
  } else if (resolution == 1) {
    etopo_url <- "https://www.ngdc.noaa.gov/thredds/fileServer/global/ETOPO2022/60s/60s_bed_elev_netcdf/ETOPO_2022_v1_60s_N90W180_bed.nc"
  } else {
    stop("resolution should be one of '0.5' or '1' arc-minutes")
  }

  # download the files
  etopo_filename <- file.path(path, paste0("etopo2022_", resolution, "m_v1.nc"))
  res <- curl::multi_download(etopo_url,
    destfile = etopo_filename
  )
  if (!res$success) {
    warning("the download failed!")
    # if a truncated file was left behind, remove it
    if (file.exists(etopo_filename)){
      file.remove(etopo_filename)
    }
  } else {
    message("the download was successul; access the relief data with `load_etopo()`")
  }
  res
}