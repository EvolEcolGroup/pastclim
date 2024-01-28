#' Load the ETOPO global relief
#'
#' This function loads previously downloaded ETOPO 2022 global relief dataset, at
#' 0.5 or 1 arc-minute (i.e. 30 or 60 arc-seconds) resolution. 
#' The function assumes that the file name is `etopo2022_{resolution}m_v1.nc`
#' To save the file in the default path with an appropriate name and file format,
#' simply use [download_etopo()].
#'
#' @param path	character. Path where the dataset is stored. If left NULL, the data
#' will be downloaded from the directory returned by [get_data_path()]
#' @param resolution numeric resolution in arc-minute (one of 0.5, or 1).
#' Defaults to 1 arc-minute.
#' @param version	character or numeric. The ETOPO2022 version number.
#' Only "1" supported at the moment
#' @returns a [`terra::SpatRaster`] of relief
#'
#' @keywords internal

load_etopo <- function(path = NULL, resolution = 1, version = "1") {
  if (is.null(path)) {
    path <- get_data_path()
  } else {
    if (!dir.exists(path)) {
      stop("the provided path does not exist")
    }
  }
  etopo_file_name <- paste0("etopo2022_", resolution, "m_v", version, ".nc")
  etopo_full_path <- file.path(path, etopo_file_name)
  if (!file.exists(etopo_full_path)) {
    stop(etopo_full_path, " does not exist; use download_etopo() to download it")
  }

  etopo_rast <- terra::rast(etopo_full_path)
  time_bp(etopo_rast) <- 0
  return(etopo_rast)
}
