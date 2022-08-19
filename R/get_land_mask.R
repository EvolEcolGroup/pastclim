#' Get the land mask for a dataset.
#'
#' Get the land mask for a dataset at a given timepoint.
#'
#' @param time_bp time slice in years before present (negative)
#' @param dataset string defining dataset to be downloaded (a list of possible
#' values can be obtained with \code{get_available_datasets}). This function
#' will not work on custom datasets.
#'
#' @import terra
#' @export

get_land_mask <- function(time_bp, dataset) {
  climate_slice <- climate_for_time_slice(
    time_bp = time_bp, bio_variables = "biome",
    dataset = dataset
  )
  climate_slice$land_mask <- climate_slice[names(climate_slice)]
  climate_slice$land_mask[climate_slice$land_mask != 28] <- TRUE
  climate_slice$land_mask[climate_slice$land_mask == 28] <- NA
  climate_slice <- terra::subset(climate_slice, "land_mask")
  return(climate_slice)
}
