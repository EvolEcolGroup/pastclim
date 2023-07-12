#' Extract local climate for one or more locations for a given time slice.
#'
#' This function extract local climate for a set of locations
#' at the appropriate times (selecting the closest time slice available for the
#' specific date associated with each location).
#'
#' @param x a data.frame with columns `longitude`, ranging
#' -180 to 180, and `latitude`, from -90 to 90, plus optional
#' columns `time_bp` or `time_ce` (depending on the units used) and
#'  `name`. Alternatively, a vector of cell numbers.
#' @param time_bp used if no `time_bp` column is present in `x`: the dates in
#' years before present (negative
#' values represent time before present, i.e. 1950, positive values time in the future)
#' for each location.
#' @param time_ce time in years CE as an alternative to `time_bp`.Only one of
#' `time_bp` or `time_ce` should be used.
#' @param coords a vector of length two giving the names of the "x" and "y"
#' coordinates, as found in `data`. If left to NULL, the function will
#' try to guess the columns based on standard names `c("x", "y")`, `c("X","Y")`,
#'  `c("longitude", "latitude")`, or `c("lon", "lat")`
#' @param bio_variables vector of names of variables to be extracted.
#' @param dataset string defining the dataset to use. If set to "custom",
#' then a single nc file is used from "path_to_nc"
#' @param path_to_nc the path to the custom nc file containing the palaeoclimate
#' reconstructions. All the variables of interest need to be included in
#' this file.
#' @param nn_interpol boolean determining whether nearest neighbour
#' interpolation is used to estimate climate for cells that lack such
#' information (i.e. they are under water or ice). By default, interpolation is only
#' performed from the first ring of nearest neighbours; if climate is not
#' available, NA will be returned for that location. The number of neighbours
#' can be changed with the argument `directions`. `nn_interpol` defaults to TRUE.
#' @param buffer boolean determining whether the variable will be returned
#' as the mean of a buffer around the focal cell. If set to TRUE, it overrides
#' `nn_interpol` (which provides the same estimates as `buffer` but only for
#' locations that are in cells with an NA). The buffer size is determined
#' by the argument `directions`. `buffer` defaults to FALSE.
#' @param directions character or matrix to indicate the directions in which
#' cells are considered connected when using `nn_interpol` or `buffer`. 
#' The following character values are allowed: "rook" or "4" for the 
#' horizontal and vertical neighbours; "bishop" to get the diagonal neighbours;
#' "queen" or "8" to get the vertical, horizontal and diagonal neighbours;
#' or "16" for knight and one-cell queen move neighbours. If directions
#' is a matrix it should have odd dimensions and have logical (or 0, 1) values.
#' @returns a data.frame with the climatic variables of interest.
#' @export

location_slice <-
  function(x,
           time_bp = NULL,
           time_ce = NULL,
           coords = NULL,
           bio_variables,
           dataset,
           path_to_nc = NULL,
           nn_interpol = TRUE,
           buffer = FALSE,
           directions = 8) {

    
    # get the region series for this dataset
    climate_brick <- region_series(bio_variables=bio_variables,
                                   dataset=dataset,
                                   path_to_nc = path_to_nc)
    # now simply wrap around location_slice_from_region_series
    location_slice_from_region_series(x = x,
                                       time_bp = time_bp,
                                       time_ce = time_ce,
                                       coords = coords,
                                       region_series = climate_brick,
                                       nn_interpol = nn_interpol,
                                       buffer = buffer,
                                       directions = directions)

  }


#' Extract local climate for one or more locations for a given time slice.
#'
#' Deprecated version of [location_slice()]
#'
#' @param ... arguments to be passed to [location_slice()]
#' @returns a data.frame with the climatic variables of interest
#'
#' @export

climate_for_locations <- function(...) {
  warning("DEPRECATED: use 'location_slice' instead")
  # if (!is.null(path_to_nc)) {
  #   stop(
  #     "the use of pastclimData is now deprecated",
  #     "use 'set_path_data' instead"
  #   )
  # }
  location_slice(...)
}
