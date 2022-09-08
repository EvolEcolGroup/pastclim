#' Extract a time series of bioclimatic variables for one or more locations.
#'
#' This function extract a time series of local climate for
#'  a set of locations
#'
#' @param x a 2 column data.frame (with columns `longitude`, ranging
#' -180 to 180, and `latitude`, from -90 to 90), or a vector of cell numbers.
#' @param time_bp time slices in years before present (negative values represent
#' time before present, positive values time in the future). This parameter can
#' be a vector of times (the slices need
#' to exist in the dataset), a list with a min and max element setting the
#' range of values, or left to NULL to retrieve all time steps.
#' To check which slices are available, you can use
#' \code{get_time_steps}.
#' @param bio_variables vector of names of variables to be extracted.
#' @param dataset string defining the dataset to use. If set to "custom",
#' then a single nc file is used from "path_to_nc"
#' @param path_to_nc the path to the custom nc file containing the paleoclimate
#' reconstructions. All the variables of interest need to be included in
#' this file.
#'
#' @export

location_series <-
  function(x,
           time_bp = NULL,
           bio_variables,
           dataset,
           path_to_nc = NULL) {
    
    check_dataset_path(dataset = dataset, path_to_nc = path_to_nc)

    # if we are using standard datasets, check whether a variables exists
    if (dataset != "custom") {
      check_var_downloaded(bio_variables, dataset)
    } else { # else check that the variables exist in the custom nc
      check_var_in_nc(bio_variables, path_to_nc)
    }

    # reorder the inputs by time
    if (inherits(x, "data.frame")) {
      locations_data <- x
    } else if (inherits(x, "matrix"))  {
        locations_data <- as.data.frame(x) 
    } else {
      locations_data <- data.frame(cell_number = x)
    }
    
    time_series_df <- locations_data
    time_series_df$id <- seq_len(nrow(time_series_df))
    time_index <- NULL
    for (this_var in bio_variables) {
      # get name of file that contains this variable
      if (dataset != "custom") {
        this_file <- get_file_for_dataset(this_var, dataset)$file_name
        this_file <- file.path(get_data_path(), this_file)
        this_var_nc <- get_varname(variable = this_var, dataset = dataset)
      } else {
        this_file <- file.path(path_to_nc)
        this_var_nc <- this_var
      }
      
      # figure out the time indeces the first time we run this
      if (is.null(time_index)) {
        # as we have the file name, we can us the same code for custom and
        # standard datasets.
        times <- get_time_steps(dataset = "custom", path_to_nc = this_file)
        time_index <- time_bp_series(time_bp = time_bp,
                                     time_steps = times)
      }
      
      climate_brick_temp <- terra::rast(this_file, subds = this_var_nc)
      if (!is.null(time_bp)){
        climate_brick <- terra::subset(climate_brick_temp,
                                                         subset = time_index)
      } else {
        climate_brick <- climate_brick_temp
      }      
      # add time var if it doesn't exist yet
      if (!("time" %in% names(time_series_df))) {
        n_time_steps <- length(time(climate_brick))
        n_locations <- nrow(time_series_df)
        time_series_df <- time_series_df[rep(
          seq_len(nrow(time_series_df)),
          n_time_steps
        ), ]
        time_series_df$time <- rep(time(climate_brick), each = n_locations)
      }
      this_var_ts <- terra::extract(climate_brick, x)
      names(this_var_ts)[-1] <- terra::time(climate_brick)
      time_series_df[this_var] <- utils::stack(this_var_ts, select = -ID)$values
    }
    return(time_series_df)
  }



#' Extract a time series of bioclimatic variables for one or more locations.
#'
#' Deprecated version of \code{location_series}
#'
#' @param ... arguments to be passed to \code{series}
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


