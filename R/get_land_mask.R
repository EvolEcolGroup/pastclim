#' Get the land mask for a dataset.
#'
#' Get the land mask for a dataset at a given timepoint.
#'
#' @param time_bp time slice in years before present (negative)
#' @param dataset string defining dataset to be downloaded (currently only
#' "Beyer2020" or "Krapp2021" are available). Note that this function will
#' not work on an custom dataset.
#' @param path_to_nc the path to the directory containing the downloaded
#' reconstructions. Leave it unset if you are using the companion
#' `pastclimData` to store datasets.
#'
#' @import terra
#' @export

get_land_mask <- function(time_bp, dataset, path_to_nc = NULL) {
  climate_slice <- climate_for_time_slice(
    time_bp = time_bp, bio_variables = "biome",
    dataset = dataset, path_to_nc = path_to_nc
  )
  climate_slice$land_mask <- climate_slice[names(climate_slice)]
  climate_slice$land_mask[climate_slice$land_mask != 28] <- TRUE
  climate_slice$land_mask[climate_slice$land_mask == 28] <- NA
  climate_slice <- terra::subset(climate_slice, "land_mask")
  return(climate_slice)
}
