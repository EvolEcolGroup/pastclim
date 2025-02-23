#' Generate file names to download the chelsa present dataset
#'
#' This function creates a vector of paths needed to download the CHELSA present
#' dataset. Possible names are "paleoclim_1.0_10m", "paleoclim_1.0_5m",
#' "paleoclim_1.0_2.5m"
#' @param dataset the name of the dataset of interest (currently unused)
#' @param bio_var the variable of interest
#' @returns a vector of times, one per band
#'
#' @keywords internal
filenames_paleoclim <- function(dataset, bio_var) {
  resolution <- strsplit(dataset, "_")[[1]][3]
  # if resolution is 2.5, we need to change it to 2_5
  resolution <- gsub(".", "_", resolution, fixed = TRUE)
  time_period_codes <- c("LH", "MH", "EH", "YDS", "BA", "HS1", "LIG")
  # compose download paths
  pastclim_urls <- paste0(
    "http://sdmtoolbox.org/paleoclim.org/data/",
    time_period_codes, "/", time_period_codes, "_v1_", resolution, ".zip"
  )
  # add present
  pastclim_urls <- c(paste0(
    "http://sdmtoolbox.org/paleoclim.org/data/chelsa_cur/CHELSA_cur_V1_2B_r",
    resolution, ".zip"
  ), pastclim_urls)
  # add LGM
  lgm_url <- paste0(
    "http://sdmtoolbox.org/paleoclim.org/data/chelsa_LGM/chelsa_LGM_v1_2B_r",
    resolution, ".zip"
  )

  # add LGM at the correct position
  pastclim_urls <- append(pastclim_urls, lgm_url, after = 7)

  return(pastclim_urls)
}

# http://sdmtoolbox.org/paleoclim.org/data/LH/LH_v1_10m.zip
# http://sdmtoolbox.org/paleoclim.org/data/MH/MH_v1_10m.zip
