#' Get the land mask for a dataset.
#'
#' Get the land mask for a dataset at a given time point.
#'
#' @param time_bp time slice in years before present (negative)
#' @param dataset string defining dataset to be downloaded (a list of possible
#' values can be obtained with [get_available_datasets()]). This function
#' will not work on custom datasets.
#' @returns a binary [`terra::SpatRaster`] with the land mask as 1s
#'
#' @import terra
#' @export

get_land_mask <- function(time_bp, dataset) {
  climate_slice <- region_slice(
    time_bp = time_bp, bio_variables = "biome",
    dataset = dataset
  )
  climate_slice$land_mask <- climate_slice[names(climate_slice)]
  climate_slice$land_mask[climate_slice$land_mask != 28] <- TRUE
  climate_slice$land_mask[climate_slice$land_mask == 28] <- NA
  climate_slice <- terra::subset(climate_slice, "land_mask")
  return(climate_slice)
}
