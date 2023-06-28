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
           bio_variables,
           dataset,
           path_to_nc = NULL,
           nn_interpol = TRUE,
           buffer = FALSE,
           directions = 8) {

    time_bp <- check_time_vars(time_bp = time_bp, time_ce = time_ce)
    readd_ce <- FALSE # boolean whether we will need to readd time_ce instead of time_bp
    if (any(!is.null(time_ce), "time_ce" %in% names(x))) {
      readd_ce <- TRUE
    }
        
    
    check_dataset_path(dataset = dataset, path_to_nc = path_to_nc)
    
    # if we are using standard datasets, check whether a variables exists
    if (dataset != "custom") {
      check_var_downloaded(bio_variables, dataset)
    } else { # else check that the variables exist in the custom nc
      check_var_in_nc(bio_variables, path_to_nc)
    }

    # if we have a data.frame
    if (inherits(x, "data.frame")){
      # check that we have coordinates
      if (!all(c("longitude","latitude") %in% names(x))){
        stop("x must have columns latitude and longitude")
      }
      # check how time has been provided
      # first make sure that, if there is a column, only one is provided
      if (all(c("time_bp", "time_ce")%in% names(x))){
        stop("in x, there should only be either a 'time_bp' column, or a 'time_ce' column")
      }
      # check whether we have time both in the df and in the vector
      if (all(any(c("time_bp", "time_ce")%in% names(x)),
              any(!is.null(time_bp),!is.null(time_ce)))){
        stop("times should either be given as a column of x, or as values for time_bp or time_ce,",
             "not both at the same time!")
      }
      # check if it is missing everywhere
      if (all(all(!c("time_bp", "time_ce")%in% names(x)),
              all(is.null(time_bp),is.null(time_ce)))){
        stop("missing times: they should either be given as a column of x, or as values for time_bp or time_ce")
      }
       locations_data <- x
    } else if (inherits(x,"numeric")) {
      locations_data <- data.frame(cell_number = x)
      
    }
    # add time_bp if needed
    if (!is.null(time_bp)){
      locations_data$time_bp <- time_bp
    }
    if ("time_ce" %in% names(locations_data)){
      locations_data$time_bp <- locations_data$time_ce-1950
    }

    #reorder input by time
    orig_id <- order(locations_data$time_bp)
    locations_data <- locations_data[order(locations_data$time_bp), ]
    time_indeces <- NULL
    # store coordinates in their own data.frame to be used for terra operations
    if (inherits(x, "data.frame")){
      coords <- locations_data [,c("longitude","latitude")]
    } else {
      coords <- locations_data [,c("cell_number")]
    }

   
    for (this_var in bio_variables) {
      # get name of file that contains this variable
      if (dataset != "custom") {
        this_file <- get_file_for_dataset(this_var, dataset)$file_name
        this_file <- file.path(get_data_path(), this_file)
        this_var_nc <- get_varname(variable = this_var, dataset = dataset)
      } else {
        this_file <- path_to_nc
        this_var_nc <- this_var
      }
      if (is.null(time_indeces)) {
        times <- get_time_steps(dataset = "custom", path_to_nc = this_file)
        time_indeces <- time_bp_to_index(
          time_bp = locations_data$time_bp, time_steps = times
        )
        locations_data$time_bp_slice <- times[time_indeces]
        unique_time_indeces <- unique(time_indeces)
      }
      
      climate_brick <- terra::rast(this_file, subds = this_var_nc)
      # create column to store variable
      locations_data[this_var] <- NA
      for (j in unique_time_indeces) {
        this_slice <- terra::subset(climate_brick, j)
        this_slice_indeces <- which(time_indeces == j)
        if (!buffer){ # get the specific values for those locations
          this_climate <- terra::extract(
            x = this_slice,
            y = coords[this_slice_indeces, ])
          locations_data[this_slice_indeces, this_var] <- this_climate[
            ,
            ncol(this_climate)
          ]
        } else { # set to NA as we will compute them with a buffer
          locations_data[this_slice_indeces, this_var] <- NA
        }

        if (nn_interpol | buffer) {
          locations_to_move <- this_slice_indeces[this_slice_indeces %in%
            which(is.na(locations_data[, this_var]))]
          if (length(locations_to_move) == 0) {
            next
          }
          for (i in locations_to_move) {
            if (inherits(x, "data.frame")) {
              cell_id <-
                terra::cellFromXY(climate_brick, as.matrix(coords[
                  i,
                ]))
            } else {
              cell_id <- coords[i]
            }
            neighbours_ids <-
              terra::adjacent(climate_brick, cell_id, 
                              directions = directions, pairs = FALSE)
            neighbours_values <-
              terra::extract(
                x = this_slice,
                y = neighbours_ids[1, ]
              )[, 1]
            locations_data[i, this_var] <-
              mean(neighbours_values, na.rm = T)
          }
        }
      }
      locations_data[is.nan(locations_data[, this_var]), this_var] <-
        NA
    }
    locations_data <- locations_data[order(orig_id), ]

    if (readd_ce){
      locations_data$time_ce <- locations_data$time_bp + 1950
      locations_data$time_ce_slice <- locations_data$time_bp_slice + 1950
      locations_data<-locations_data[,!names(locations_data) %in% c("time_bp","time_bp_slice")]
    }
    return(locations_data)
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
