#' Compute a raster of distances from the sea for each land pixel.
#'
#' Get the land mask for a dataset at a given time point, and compute distance
#' from the sea for each land pixel.
#'
#' @param time_bp time slice in years before present (negative)
#' @param dataset string defining dataset to be downloaded (a list of possible
#' values can be obtained with [get_available_datasets()]). This function
#' will not work on custom datasets.
#' @returns a [terra::SpatRaster] of distances
#'
#' @import terra
#' @export

distance_from_sea <- function(time_bp, dataset) {
  this_land_mask <- pastclim::get_land_mask(time_bp=time_bp,
                                            dataset=dataset)
  coastlines_polyline <- terra::as.polygons(this_land_mask) # first get polygon
  coastlines_polyline <- terra::as.lines(coastlines_polyline) # then extract line
  
  distances_rast <- terra::distance(this_land_mask$land_mask, 
                                    coastlines_polyline,
                                    unit="km")
  distances_rast <- terra::mask(distances_rast, this_land_mask)
  names(distances_rast) <- "distance_from_sea"
  
  return(distances_rast)
}
