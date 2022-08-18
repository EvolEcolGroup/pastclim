#' Extract a time series of climate variables for a region
#'
#' This function extracts a time series of one or more climate variables for a given
#' dataset covering a region (or the whole world). The function returns a
#' SpatRasterDataset \code{terra::sds} object, with
#' each variable as a sub-dataset.
#'
#' @param time_bp time slices in years before present (negative). The slices needs
#' to exist in the dataset. To check which slices are available, you can use
#' \code{get_time_steps}.
#' @param bio_variables vector of names of variables to be extracted
#' @param dataset string defining the dataset to use. If set to "custom",
#' then a single nc file is used from "path_to_nc"
#' @param path_to_nc the path to the custom nc file containing the paleoclimate
#' reconstructions. All the variables of interest need to be included in this file.
#' 
#' location_slice
#' location_series
#' region_slice
#' region_series
#' slice_region_series
#'
#' @import terra
#' @export

region_series <-
  function(time_bp,
           bio_variables,
           dataset,
           path_to_nc = NULL) {
    
    check_dataset_path(dataset = dataset, path_to_nc = path_to_nc)
    
    # check whether the variables exist for this dataset
    if (dataset != "custom") { # if we are using standard datasets
      check_var_downloaded(bio_variables, dataset, get_data_path())
    } else { # else check that the variables exist in the custom nc
      check_var_in_nc(bio_variables, path_to_nc)
    }

    time_index <- NULL
    climate_spatrasters <- list()

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
        time_index <- time_bp_to_index(
          time_bp = time_bp, path_to_nc =
            this_file
        )
      }
      var_brick <- terra::rast(this_file, subds = this_var_nc)
      climate_spatrasters[[this_var]] <- terra::subset(var_brick, subset = time_index)
      # if (is.null(climate_spatraster)) {
      #   climate_spatraster <- var_slice
      # } else {
      #   terra::add(climate_spatraster) <- var_slice
      # }
    }
    climate_sds<-terra::sds(climate_spatrasters)
    names(climate_sds)<-bio_variables
    #names(climate_spatraster) <- varnames(climate_spatraster) <- bio_variables
    return(terra::sds(climate_spatrasters))
  }


