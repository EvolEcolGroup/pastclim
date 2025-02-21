#' Generate file names to download the WorldClim present dataset
#'
#' This function creates a vector of paths needed to download the WorldClim
#' present dataset
#' @param dataset the name of the dataset of interest
#' @param bio_var the variable of interest
#' @returns a vector of times, one per band
#'
#' @keywords internal
filenames_worldclim_future <- function(dataset, bio_var) {
  wc_res <- strsplit(dataset, "_")[[1]][5]
  # if resolution is 0.5m, we need to change it to 30s
  if (wc_res == "0.5m") {
    wc_res <- "30s"
  }

  time_steps <- c("2021-2040", "2041-2060", "2061-2080", "2081-2100")
  wc_gcm <- strsplit(dataset, "_")[[1]][3]
  wc_scenario <- strsplit(dataset, "_")[[1]][4]

  # set appropriate postfix and prefix based on variable names
  if (grepl("bio", bio_var)) {
    postfix <- "bioc"
  } else if (grepl("temperature_min_", bio_var)) {
    postfix <- "tmin"
  } else if (grepl("temperature_max_", bio_var)) {
    postfix <- "tmax"
  } else if (grepl("precipitation_", bio_var)) {
    postfix <- "prec"
  } else {
    stop("variable ", bio_var, " not valid")
  }
  # nolint start
  #  else if (grepl("altitude", bio_var)) {
  #    # TODO this requires dispatching to a custom function
  #    # that takes the elevation
  #    # form the present, and then creates a special altitude file
  #    postfix <- "elev"
  #  }
  # nolint end

  base_url <- "https://geodata.ucdavis.edu/cmip6"
  base_url <- paste(base_url, wc_res, wc_gcm, wc_scenario, sep = "/")
  base_file <- paste("wc2.1", wc_res, postfix, wc_gcm, wc_scenario, sep = "_")
  base_url <- paste(base_url, base_file, sep = "/")
  full_url <- paste0(base_url, "_", time_steps, ".tif")
}

# some combinations are not valid
# FIO-eSM-2-0 does not have ssp370
# GFDL-ESM4 does not have ssp245 and ssp585
# HadGEM3-GC31-LL does not have ssp370
