#' Get the land mask for a dataset.
#'
#' Get the land mask for a dataset, either for the whole series or for specific
#' time points.
#' 
#' @param time_bp time slices in years before present (negative values represent
#' time before present, positive values time in the future). This parameter can
#' be a vector of times (the slices need
#' to exist in the dataset), a list with a min and max element setting the
#' range of values, or left to NULL to retrieve all time steps.
#' To check which slices are available, you can use
#' [get_time_bp_steps()].
#' @param time_ce time in years CE as an alternative to `time_bp`.Only one of
#' `time_bp` or `time_ce` should be used. For available time slices in years CE, use
#' [get_time_ce_steps()].
#' @param dataset string defining dataset to be downloaded (a list of possible
#' values can be obtained with [list_available_datasets()]). This function
#' will not work on custom datasets.
#' @returns a binary [`terra::SpatRaster`] with the land mask as 1s
#'
#' @import terra
#' @export

get_land_mask <- function(time_bp = NULL, time_ce = NULL, dataset) {
  time_bp <- check_time_vars(time_bp=time_bp, time_ce= time_ce)
  if (!dataset %in% list_available_datasets()){
    stop("this function only works on the defaults datasets in pastclim\n",
         "you can get a list with `list_available_datasets()`")
  }
  
  if (dataset %in% c("Example","Beyer2020","Krapp2021")){
    climate_series <- region_series(
      time_bp = time_bp, bio_variables = "biome",
      dataset = dataset
    )
    land_mask <- climate_series["biome"]
    land_mask[land_mask !=28] <- 1
    land_mask[land_mask ==28] <- NA
    
  } else if(grepl("WorldClim", dataset)){
    climate_series <- region_series(
      time_bp = time_bp, 
      bio_variables = get_vars_for_dataset(dataset)[1],
      dataset = dataset
    )
    land_mask <- climate_series[[1]]
    land_mask[!is.na(land_mask)]<-1
  } else {
    stop("no method yet for this dataset")
  }
  
  if (is.null(time_ce)){
    names(land_mask) <- paste("land_mask", time_bp(land_mask), sep="_")
  } else {
    names(land_mask) <- paste("land_mask", time(land_mask), sep="_")
  }
  varnames(land_mask)<-"land_mask"
  return(land_mask)
}
