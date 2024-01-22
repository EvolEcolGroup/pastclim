#' Generate file names to download the chelsa present dataset
#'
#' This function creates a vector of paths needed to download the CHELSA present
#' dataset. Possible names are "paleoclim_1.0_10m", "paleoclim_1.0_5m",
#' "paleoclim_1.0_2.5m"
#' @param dataset the name of the dataset of interest (currently unused)
#' @param bio_var the variable of interest
#' @param version the version of the dataset (currently unused)
#' @returns a vector of times, one per band
#'
#' @keywords internal
filenames_paleoclim <- function(dataset, bio_var, version=NULL){
  
  resolution <- strsplit(dataset,"_")[[1]][3]
  # if resolution is 2.5, we need to change it to 2_5
  resolution <- gsub(".", "_", resolution, fixed = TRUE)
  time_period_codes <- c("LH", "MH") #, "EH", "YDS", "BA", "HS1", "LIG"
  # compose download paths
  paste0("http://sdmtoolbox.org/paleoclim.org/data/",
         time_period_codes,"/",time_period_codes,"_v1_",resolution,".zip")
}

# http://sdmtoolbox.org/paleoclim.org/data/LH/LH_v1_10m.zip
# http://sdmtoolbox.org/paleoclim.org/data/MH/MH_v1_10m.zip