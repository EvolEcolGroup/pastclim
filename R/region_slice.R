#' Extract a climate slice for a region
#'
#' This function extracts a slice of one or more climate variables for a given
#' dataset covering a region (or the whole world). The function returns a
#' SpatRaster [terra::SpatRaster] object, with
#' each variable as a layer.
#'
#' @param time_bp the time slice in years before present (negative
#' values represent
#' time before present, positive values time in the future). The slice needs
#' to exist in the dataset. To check which slices are available, you can use
#' \code{get_time_steps}.
#' @param bio_variables vector of names of variables to be extracted
#' @param dataset string defining the dataset to use. If set to "custom",
#' then a single nc file is used from "path_to_nc"
#' @param path_to_nc the path to the custom nc file containing the palaeoclimate
#' reconstructions. All the variables of interest need to be included
#' in this file.
#' @param ext an extent, coded as numeric vector (length=4; 
#' order= xmin, xmax, ymin, ymax) or a [terra::SpatExtent] object. If NULL,
#' the full extent of the reconstruction is given.
#' @param crop a polygon used to crop the reconstructions (e.g. the outline
#' of a continental mass). A \code{sf:sfg} or a [terra::SpatVector] object 
#' is used to define the polygon.
#' @returns a
#' SpatRaster [terra::SpatRaster] object, with
#' each variable as a layer.
#' 
#' @import terra
#' @export

region_slice <-
  function(time_bp,
           bio_variables,
           dataset,
           path_to_nc = NULL,
           ext = NULL,
           crop = NULL) {
    
    this_series <- region_series(
      time_bp = time_bp,
      bio_variables = bio_variables,
      dataset = dataset,
      path_to_nc = path_to_nc,
      ext = ext,
      crop = crop
    )
    return(slice_region_series(x = this_series, time_bp = time_bp))
  }


#' Extract a climate slice for a region
#'
#' Deprecated version of \code{region_slice}
#'
#' @param ... arguments to be passed to \code{region_slice}
#' @returns a
#' SpatRaster \code{terra::SpatRaster} object, with
#' each variable as a layer.
#'
#' @export

climate_for_time_slice <- function(...) {
  warning("DEPRECATED: use 'region_slice' instead")
  # if (!is.null(path_to_nc)) {
  #   stop("the use of pastclimData is now deprecated,",
  #   " use 'set_path_data' instead")
  # }
  region_slice(...)
}
