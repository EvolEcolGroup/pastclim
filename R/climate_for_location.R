#' Extract local climate for one or more locations.
#'
#' This function extract local climate from Beyer et al for a set of locations
#' at the appropriate times
#'
#' @param x a 2 column matrix (with columns `longitude`, ranging
#' -180 to 180, and `latitude`, from -90 to 90), or a vector of cell numbers.
#' @param time_bp vector of ages, in years before present (negative).
#' @param bio_variables vector of names of variables to be extracted.
#' @param dataset string defining the dataset to use (one of Beyer2020,
#' Krapp2021 or custom).
#' @param path_to_nc the path to the directory containing the downloaded
#' reconstructions.
#' Leave it unset if you are using the companion `pastclimData` to store
#' datasets.
#' @param nn_interpol boolean determining whether nearest neighbour
#' interpolation is used to estimate climate for cells that lack such
#' information (i.e. they are under water or ice). Interpolation is only
#' performed from the first ring of nearest neighbours; if climate is not
#' available, NA will be returned for that location. Defaults to TRUE.
#'
#' @export

climate_for_locations <-
  function(x,
           time_bp,
           bio_variables,
           dataset,
           path_to_nc = NULL,
           nn_interpol = TRUE) {

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
      x <- x[order(time_bp), ]
      locations_data <- x
    } else {
      x <- data.frame(x[order(time_bp)])
      locations_data <- data.frame(cell_number = x[, 1])
    }
    orig_id <- order(time_bp)
    time_bp <- sort(time_bp)
    locations_data$time_bp <- time_bp
    time_indeces <- NULL

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
      if (is.null(time_indeces)) {
        time_indeces <- time_bp_to_index(
          time_bp = time_bp, path_to_nc =
            this_file
        )
        unique_time_indeces <- unique(time_indeces)
      }
      climate_brick <- terra::rast(this_file, subds = this_var_nc)
      # create column to store variable

      locations_data[this_var] <- NA
      for (j in unique_time_indeces) {
        this_slice <- terra::subset(climate_brick, j)
        this_slice_indeces <- which(time_indeces == j)
        this_climate <- terra::extract(
          x = this_slice,
          y = x[this_slice_indeces, ]
        )
        locations_data[this_slice_indeces, this_var] <- this_climate[
          ,
          ncol(this_climate)
        ]
        if (nn_interpol) {
          locations_to_move <- this_slice_indeces[this_slice_indeces %in%
            which(is.na(locations_data[, this_var]))]
          if (length(locations_to_move) == 0) {
            next
          }
          for (i in locations_to_move) {
            if (inherits(x, "data.frame")) {
              cell_id <-
                terra::cellFromXY(climate_brick, as.matrix(locations_data[
                  i,
                  1:2
                ]))
            } else {
              cell_id <- x[i]
            }
            neighbours_ids <-
              terra::adjacent(climate_brick, cell_id, 8, pairs = FALSE)
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

    return(locations_data)
  }
