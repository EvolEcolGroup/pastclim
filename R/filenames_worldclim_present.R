#' Generate file names to download the WorldClim present dataset
#'
#' This function creates a vector of paths needed to download the WorldClim
#' present dataset
#' @param dataset the name of the dataset of interest
#' @param bio_var the variable of interest
#' @returns a vector of times, one per band
#'
#' @keywords internal
filenames_worldclim_present <- function(dataset, bio_var) {
  # get resolution from the dataset name and convert it to the original
  res_conversion <- data.frame(
    our_res = c("10m", "5m", "2.5m", "0.5m"),
    wc_res = c("10m", "5m", "2.5m", "30s")
  )
  wc_res <- res_conversion$wc_res[
    res_conversion$our_res == unlist(strsplit(dataset, "_"))[3]
  ]

  # function to grab the number from the raster layer
  if (grepl("bio", bio_var)) {
    postfix <- "bio.zip"
  } else if (grepl("temperature_min", bio_var)) {
    postfix <- "tmin.zip"
  } else if (grepl("temperature_max", bio_var)) {
    postfix <- "tmax.zip"
  } else if (grepl("temperature_", bio_var)) {
    postfix <- "tavg.zip"
  } else if (grepl("precipitation_", bio_var)) {
    postfix <- "prec.zip"
  } else if (grepl("altitude", bio_var)) {
    postfix <- "elev.zip"
  }

  base_url <- "https://geodata.ucdavis.edu/climate/worldclim/2_1/base/wc2.1"
  full_url <- paste(base_url, wc_res, postfix, sep = "_")
  full_url
}
