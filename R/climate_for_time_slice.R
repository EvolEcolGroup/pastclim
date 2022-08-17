#' Extract a raster brick for a given time slice
#'
#' This function extracts a raster brick for a given time slice.
#'
#' @param time_bp time slice in years before present (negative)
#' @param bio_variables vector of names of variables to be extracted
#' @param dataset string defining the dataset to use
#' @param path_to_nc the path to the directory containing the downloaded
#' reconstructions. Leave it unset if you are using the companion `pastclimData`
#' to store datasets.
#'
#' @import terra
#' @export

climate_for_time_slice <-
  function(time_bp,
           bio_variables,
           dataset,
           path_to_nc = NULL) {

    # if we are using standard datasets, check whether a variables exists
    if (dataset != "custom") {
      check_var_downloaded(bio_variables, dataset, path_to_nc)
    } else { # else check that the variables exist in the custom nc
      check_var_in_nc(bio_variables, path_to_nc)
    }

    # if path_to_nc is not set, use pastclimData
    if (is.null(path_to_nc)) {
      path_to_nc <- get_data_path()
    }

    time_index <- NULL
    climate_spatraster <- NULL

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
      if (is.null(time_index)) {
        time_index <- time_bp_to_index(
          time_bp = time_bp, path_to_nc =
            this_file
        )
      }
      var_brick <- terra::rast(this_file, subds = this_var_nc)
      var_slice <- terra::subset(var_brick, subset = time_index)
      if (is.null(climate_spatraster)) {
        climate_spatraster <- var_slice
      } else {
        terra::add(climate_spatraster) <- var_slice
      }
    }
    names(climate_spatraster) <- varnames(climate_spatraster) <- bio_variables
    return(climate_spatraster)
  }
