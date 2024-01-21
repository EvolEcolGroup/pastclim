#' Extract a time series of climate variables for a region
#'
#' This function extracts a time series of one or more climate variables for
#' a given
#' dataset covering a region (or the whole world). The function returns a
#' [`terra::SpatRasterDataset`] object, with
#' each variable as a sub-dataset.
#'
#' @param time_bp time slices in years before present (negative values represent
#' time before present, positive values time in the future). This parameter can
#' be a vector of times (the slices need
#' to exist in the dataset), a list with a min and max element setting the
#' range of values, or left to NULL to retrieve all time steps.
#' To check which slices are available, you can use
#' [get_time_bp_steps()].
#' @param time_ce time slices in years CE (see `time_bp` for options).
#' For available time slices in years CE, use [get_time_ce_steps()].
#' Only one of `time_bp` or `time_ce` should be used.
#' @param bio_variables vector of names of variables to be extracted
#' @param dataset string defining the dataset to use. If set to "custom",
#' then a single nc file is used from "path_to_nc"
#' @param path_to_nc the path to the custom nc file containing the palaeoclimate
#' reconstructions. All the variables of interest need to be included in
#' this file.
#' @param ext an extent, coded as numeric vector (length=4;
#' order= xmin, xmax, ymin, ymax) or a [terra::SpatExtent] object. If NULL,
#' the full extent of the reconstruction is given.
#' @param crop a polygon used to crop the reconstructions (e.g. the outline
#' of a continental mass). A [`sf::sfg`][sf::st] or a [terra::SpatVector] object
#' is used to define the polygon.
#' @returns a
#' [`terra::SpatRasterDataset`] object, with
#' each variable as a sub-dataset.
#'
#' @import terra
#' @export

region_series <-
  function(time_bp = NULL,
           time_ce = NULL,
           bio_variables,
           dataset,
           path_to_nc = NULL,
           ext = NULL,
           crop = NULL) {
    time_bp <- check_time_vars(time_bp = time_bp, time_ce = time_ce)

    check_dataset_path(dataset = dataset, path_to_nc = path_to_nc)
    if (dataset == "Barreto2023") {
      message("This is a large dataset, it might take a while...")
    }

    if (!is.null(ext)) {
      if (!any(
        inherits(ext, "SpatExtent"),
        all(inherits(ext, "numeric"), length(ext) == 4)
      )) {
        stop("ext should be a numeric vector of length 4 or a terra::SpatExtent object created terra::ext")
      }
      if (inherits(ext, "numeric")) {
        ext <- terra::ext(ext)
      }
    }
    if (!is.null(crop)) {
      if (!any(
        inherits(crop, "SpatVector"),
        inherits(crop, "sfg")
      )) {
        stop("crop should be a sf::sfg or a terra::SpatVector object created with terra::vect")
      }
      if (inherits(crop, "sfg")) {
        crop <- terra::vect(crop)
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
        times <- get_time_bp_steps(dataset = "custom", path_to_nc = this_file)
        time_index <- time_bp_to_i_series(
          time_bp = time_bp,
          time_steps = times
        )
      }
      # retrieve time axis for virtual file
      if (substr(this_file,nchar(this_file)-2,nchar(this_file))=="vrt"){
        var_brick <- terra::rast(this_file, lyrs = this_var_nc)
        time_bp(var_brick) <- unique(vrt_get_times(this_file))
      } else {
        var_brick <- terra::rast(this_file, subds = this_var_nc)
      }
      # subset to time steps
      if (!is.null(time_bp)) {
        var_brick <- terra::subset(var_brick, subset = time_index)
      }

      # subset extent
      if (!is.null(ext)) {
        var_brick <- terra::crop(var_brick, ext)
      }
      # subset to crop
      if (!is.null(crop)) {
        terra::crs(crop) <- terra::crs(var_brick)
        var_brick <- terra::mask(var_brick, crop)
        var_brick <- terra::crop(var_brick, crop)
      }

      climate_spatrasters[[this_var]] <- var_brick

      varnames(climate_spatrasters[[this_var]]) <- this_var
      names(climate_spatrasters[[this_var]]) <- paste(this_var,
        time_bp(climate_spatrasters[[this_var]]),
        sep = "_"
      )
    }
    climate_sds <- terra::sds(climate_spatrasters)
    return(climate_sds)
  }
