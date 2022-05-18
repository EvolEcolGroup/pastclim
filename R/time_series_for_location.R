#' Extract a time series of bioclimatic variables for one or more locations.
#'
#' This function extract a time series of local climate for
#'  a set of locations
#'
#' @param x a 2 column matrix (with columns `longitude`, ranging
#' -180 to 180, and `latitude`, from -90 to 90), or a vector of cell numbers.
#' @param bio_variables vector of names of variables to be extracted.
#' @param dataset string defining the dataset to use.
#' @param path_to_nc the path to the directory containing the downloaded
#' reconstructions. Leave it unset if you are using the companion
#' `pastclimData` to store datasets.
#'
#' @export

time_series_for_locations <-
  function(x,
           bio_variables,
           dataset,
           path_to_nc = NULL) {

    # if we are using standard datasets, check whether a variables exists
    if (dataset != "custom") {
      check_var_downloaded(bio_variables, dataset, path_to_nc)
    } else { # else check that the variables exist in the custom nc
      check_var_in_nc(bio_variables, path_to_nc)
    }

    if (is.null(path_to_nc)) {
      path_to_nc <- get_pastclimdata_path()
    }

    # reorder the inputs by time
    if (inherits(x, "data.frame")) {
      locations_data <- x
    } else {
      locations_data <- data.frame(cell_number = x)
    }
    time_series_df <- locations_data
    time_series_df$id <- seq_len(nrow(time_series_df))
    for (this_var in bio_variables) {
      # get name of file that contains this variable
      if (dataset != "custom") {
        this_file <- get_file_for_dataset(this_var, dataset)$file_name
        this_file <- file.path(path_to_nc, this_file)
        this_var_nc <- get_varname(variable = this_var, dataset = dataset)
      } else {
        this_file <- file.path(path_to_nc)
        this_var_nc <- this_var
      }
      climate_brick <- terra::rast(this_file, subds = this_var_nc)
      # add time var if it doesn't exist yet
      if (!("time" %in% names(time_series_df))) {
        n_time_steps <- length(time(climate_brick))
        n_locations <- nrow(time_series_df)
        time_series_df <- time_series_df[rep(seq_len(nrow(time_series_df)),
                                             n_time_steps), ]
        time_series_df$time <- rep(time(climate_brick), each = n_locations)
      }
      this_var_ts <- terra::extract(climate_brick, x)
      names(this_var_ts)[-1] <- terra::time(climate_brick)
      time_series_df[this_var] <- utils::stack(this_var_ts, select = -ID)$values
    }
    return(time_series_df)
  }
