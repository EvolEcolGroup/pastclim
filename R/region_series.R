#' Extract a time series of climate variables for a region
#'
#' This function extracts a time series of one or more climate variables for
#' a given
#' dataset covering a region (or the whole world). The function returns a
#' SpatRasterDataset \code{terra::sds} object, with
#' each variable as a sub-dataset.
#'
#' @param time_bp time slices in years before present (negative values represent
#' time before present, positive values time in the future). This parameter can
#' be a vector of times (the slices need
#' to exist in the dataset), a list with a min and max element setting the
#' range of values, or left to NULL to retrieve all time steps.
#' To check which slices are available, you can use
#' \code{get_time_steps}.
#' @param bio_variables vector of names of variables to be extracted
#' @param dataset string defining the dataset to use. If set to "custom",
#' then a single nc file is used from "path_to_nc"
#' @param path_to_nc the path to the custom nc file containing the paleoclimate
#' reconstructions. All the variables of interest need to be included in
#' this file.
#' @param ext an extent, coded as a \code{terra::SpatExtent} object. If NULL,
#' the full extent of the reconstruction is given.
#' @param crop a polygon used to crop the reconstructions (e.g. the outline
#' of a continental mass). A \code{terra::SpatVector} object is used to
#' define the polygon
#'
#' @import terra
#' @export

region_series <-
  function(time_bp = NULL,
           bio_variables,
           dataset,
           path_to_nc = NULL,
           ext = NULL,
           crop = NULL) {
    
    check_dataset_path(dataset = dataset, path_to_nc = path_to_nc)

    if (!is.null(ext)){
      if(!inherits(ext,"SpatExtent")){
        stop ("extent should be a terra::SpatExtent object created terra::ext")
      }
    }
    if (!is.null(crop)){
      if(!inherits(crop,"SpatVector")){
        stop ("extent should be a terra::SpatVector object created terra::vect")
      }
    }
    
    # check whether the variables exist for this dataset
    if (dataset != "custom") { # if we are using standard datasets
      check_var_downloaded(bio_variables, dataset)
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
        # as we have the file name, we can us the same code for custom and
        # standard datasets.
        times <- get_time_steps(dataset = "custom", path_to_nc = this_file)
        time_index <- time_bp_series(time_bp = time_bp,
                                     time_steps = times)
      }
      var_brick <- terra::rast(this_file, subds = this_var_nc)
      # subset extent
      if (!is.null(ext)){
        var_brick <- terra::crop(var_brick, ext)
      }
      # subset to crop
      if (!is.null(crop)){
        terra::crs(crop) <- terra::crs(var_brick)
        var_brick <- terra::mask(var_brick, crop)
        var_brick <- terra::crop(var_brick, crop)
      }
      
      if (!is.null(time_bp)){
        climate_spatrasters[[this_var]] <- terra::subset(var_brick,
                                       subset = time_index)
      } else {
        climate_spatrasters[[this_var]] <- var_brick
      }
      varnames(climate_spatrasters[[this_var]]) <- this_var
      names(climate_spatrasters[[this_var]]) <- paste(this_var,
        time(climate_spatrasters[[this_var]]),
        sep = "_"
      )
    }
    climate_sds <- terra::sds(climate_spatrasters)
    names(climate_sds) <- bio_variables
    return(terra::sds(climate_spatrasters))
  }
