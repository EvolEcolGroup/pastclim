#' Extract a time series of bioclimatic variables for one or more locations.
#'
#' This function extract a time series of local climate for
#'  a set of locations. Note that this function does not apply any interpolation
#'  (as opposed to [location_slice()]). If you have a coastal location that just
#'  falls into the water for the reconstructions, you will have to amend the coordinates
#'  to put it more firmly on land.
#'
#' @param x a data.frame with columns `longitude`, ranging
#' -180 to 180, and `latitude`, from -90 to 90 (and an optional `name`),
#' or a vector of cell numbers.
#' @param time_bp time slices in years before present (negative values represent
#' time before present, positive values time in the future). This parameter can
#' be a vector of times (the slices need
#' to exist in the dataset), a list with a min and max element setting the
#' range of values, or left to NULL to retrieve all time steps.
#' To check which slices are available, you can use
#' [get_time_steps()].
#' @param time_ce time slice in years CE (see `time_bp` for options, but note
#' that [get_time_steps()] gives times in bp, not ce!). Only one of
#' `time_bp` or `time_ce` should be used.
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
#' can be changed with the argument `directions`. `nn_interpol` defaults to FALSE
#' (this is DIFFERENT from [location_slice()].
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
#' @returns a data.frame with the climatic variables of interest
#' @export

location_series <-
  function(x,
           time_bp = NULL,
           time_ce = NULL,
           bio_variables,
           dataset,
           path_to_nc = NULL,
           nn_interpol = FALSE,
           buffer = FALSE,
           directions = 8) {

    time_bp <- check_time_vars(time_bp = time_bp, time_ce = time_ce)
    
    check_dataset_path(dataset = dataset, path_to_nc = path_to_nc)

    # if we are using standard datasets, check whether a variables exists
    # and get the times
    if (dataset != "custom") {
      check_var_downloaded(bio_variables, dataset)
      times <- get_time_steps(dataset = dataset, path_to_nc = path_to_nc)
    } else { # else check that the variables exist in the custom nc
      check_var_in_nc(bio_variables, path_to_nc)
      times <- get_time_steps(dataset = "custom", path_to_nc = path_to_nc)
    }
    time_bp_i <- time_bp_to_i_series(time_bp = time_bp,
                                     time_steps = times)
    if (is.null(time_bp_i)){
      time_bp <- times
    } else {
      time_bp <- times[time_bp_i]
    }

    # check coordinates data frame
    if (inherits(x, "data.frame")) {
      if (!all(c("longitude","latitude") %in% names(x))){
        stop ("x should be a dataframe with columns latitude and longitude")
      }
      # if names does not exist, add it
      if (!"name" %in% names(x)){
        x$name<-as.character(1:nrow(x))
      }
      x <- x[,match(c("name","longitude", "latitude"), names(x))]
      n_loc <- nrow(x)
      # now repeat it for each time step
      x<- x[rep(1:nrow(x),length(time_bp)),]

    }else if (inherits(x, "numeric")){
      n_loc <- length(x)
      x<- rep(x, length(time_bp))
    } else {
      stop ("x should be either a data.frame or a numeric vector")
    }
    
    # now copy over the times to match the coordinates
    time_bp <- rep(time_bp, each=n_loc)
    # and now feed the info to location_slice
    location_ts <- location_slice(x=x, time_bp = time_bp, bio_variables = bio_variables,
                                  dataset= dataset, path_to_nc=path_to_nc,
                                  nn_interpol = nn_interpol, buffer = buffer,
                                  directions = directions)
    return(location_ts[,!names(location_ts) %in% "time_bp_slice"])
  }



#' Extract a time series of bioclimatic variables for one or more locations.
#'
#' Deprecated version of [location_series()]
#'
#' @param ... arguments to be passed to [location_series()]
#' @returns a data.frame with the climatic variables of interest
#'
#' @export

time_series_for_locations <- function(...) {
  warning("DEPRECATED: use 'location_series' instead")
  # if (!is.null(path_to_nc)) {
  #   stop(
  #     "the use of pastclimData is now deprecated",
  #     "use 'set_path_data' instead"
  #   )
  # }
  location_series(...)
}


