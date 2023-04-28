#' Compute a raster of distances from the sea for each land pixel.
#'
#' Get the land mask for a dataset at a given time point, and compute distance
#' from the sea for each land pixel.
#'
#' @param time_bp time slice in years before present (negative)
#' @param dataset string defining the dataset to use (a list of possible
#' values can be obtained with [get_available_datasets()]). This function
#' will not work on custom datasets.
#' @returns a [`terra::SpatRaster`] of distances from the coastline in km
#'
#' @import terra
#' @export

distance_from_sea <- function(time_bp=NULL, dataset) {
  times <- get_time_steps(dataset = dataset)
  # if we don't give times, just use all available
  if (is.null(time_bp)){
    time_bp <- times
  }
  # we use this to correctly convert time_bp
  time_index <- time_bp_to_i_series(time_bp = time_bp,
                                    time_steps = times)
  distances_list <- list()
  for (i in 1:length(time_index)){
    this_time <- times[time_index[i]]
    this_land_mask <- get_land_mask(time_bp=this_time,
                                    dataset=dataset)
    coastlines_with_ice <- region_slice(time_bp=this_time,
                                        bio_variables="biome",
                                        dataset=dataset)
    coastlines_with_ice[coastlines_with_ice> -1]<-1
    coastlines_polyline <- terra::as.polygons(coastlines_with_ice) # first get polygon
    coastlines_polyline <- terra::as.lines(coastlines_polyline) # then extract line
    
    distances_rast <- terra::distance(this_land_mask[[1]], 
                                      coastlines_polyline,
                                      unit="km")
    distances_rast <- terra::mask(distances_rast, this_land_mask)
    #browser()
    names(distances_rast) <- paste("distance_from_sea",time_bp(distances_rast),sep="_")
    if (i==1){
      distances_all <- distances_rast
    } else {
      distances_all <- c(distances_all, distances_rast)
    }
  }
  varnames(distances_all) <- "distance_from_sea"
  return(distances_all)
}