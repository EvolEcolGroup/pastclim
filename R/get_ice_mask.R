#' Get the ice mask for a dataset.
#'
#' Get the ice mask for a dataset, either for the whole series or for specific
#' time points.
#'
#' @param time_bp time slices in years before present (negative values represent
#' time before present, positive values time in the future). This parameter can
#' be a vector of times (the slices need
#' to exist in the dataset), a list with a min and max element setting the
#' range of values, or left to NULL to retrieve all time steps.
#' To check which slices are available, you can use
#' [get_time_bp_steps()].
#' @param dataset string defining dataset to be downloaded (a list of possible
#' values can be obtained with [list_available_datasets()]). This function
#' will not work on custom datasets.
#' @returns a binary [`terra::SpatRaster`] with the ice mask as 1s
#'
#' @import terra
#' @export

get_ice_mask <- function(time_bp = NULL, dataset) {
  if (!dataset %in% list_available_datasets()) {
    stop(
      "this function only works on the defaults datasets in pastclim\n",
      "you can get a list with `list_available_datasets()`"
    )
  }
  if (dataset %in% c("Example", "Beyer2020", "Krapp2021")) {
    climate_series <- region_series(
      time_bp = time_bp, bio_variables = "biome",
      dataset = dataset
    )
    ice_mask <- climate_series["biome"]
    ice_mask[ice_mask != 28] <- NA
    ice_mask[ice_mask == 28] <- 1
    names(ice_mask) <- paste("ice_mask", time_bp(ice_mask), sep = "_")
    varnames(ice_mask) <- "ice_mask"
    return(ice_mask)
  } else {
    stop("ice masks are not available for this dataset")
  }
}
