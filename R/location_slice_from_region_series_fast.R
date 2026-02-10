#' Extract local climate for one or more locations for a given time slice.
#'
#' This function extract local climate for a set of locations at the appropriate
#' times (selecting the closest time slice available for the specific date
#' associated with each location).
#'
#' @param x a data.frame with columns x and y coordinates(see `coords` for
#'   standard coordinate names, or how to use custom ones), plus optional
#'   columns `time_bp` or `time_ce` (depending on the units used) and `name`.
#'   Alternatively, a vector of cell numbers.
#' @param time_bp used if no `time_bp` column is present in `x`: the dates in
#'   years before present (negative values represent time before present, i.e.
#'   1950, positive values time in the future) for each location.
#' @param time_ce time in years CE as an alternative to `time_bp`. Only one of
#'   `time_bp` or `time_ce` should be used.
#' @param coords a vector of length two giving the names of the "x" and "y"
#'   coordinates, as found in `data`. If left to NULL, the function will try to
#'   guess the columns based on standard names `c("x", "y")`, `c("X","Y")`,
#'   `c("longitude", "latitude")`, or `c("lon", "lat")`
#' @param region_series a [`terra::SpatRasterDataset`] obtained with
#'   [region_series()]
#' @param nn_interpol boolean determining whether nearest neighbour
#'   interpolation is used to estimate climate for cells that lack such
#'   information (i.e. they are under water or ice). By default, interpolation
#'   is only performed from the first ring of nearest neighbours; if climate is
#'   not available, NA will be returned for that location. The number of
#'   neighbours can be changed with the argument `directions`. `nn_interpol`
#'   defaults to TRUE.
#' @param buffer boolean determining whether the variable will be returned as
#'   the mean of a buffer around the focal cell. If set to TRUE, it overrides
#'   `nn_interpol` (which provides the same estimates as `buffer` but only for
#'   locations that are in cells with an NA). The buffer size is determined by
#'   the argument `directions`. `buffer` defaults to FALSE.
#' @param directions character or matrix to indicate the directions in which
#'   cells are considered connected when using `nn_interpol` or `buffer`. The
#'   following character values are allowed: "rook" or "4" for the horizontal
#'   and vertical neighbours; "bishop" to get the diagonal neighbours; "queen"
#'   or "8" to get the vertical, horizontal and diagonal neighbours; or "16" for
#'   knight and one-cell queen move neighbours. If directions is a matrix it
#'   should have odd dimensions and have logical (or 0, 1) values.
#' @returns a data.frame with the climatic variables of interest.
#' @export

location_slice_from_region_series <- # nolint
  function(x,
           time_bp = NULL,
           time_ce = NULL,
           coords = NULL,
           region_series,
           nn_interpol = TRUE,
           buffer = FALSE,
           directions = 8) {
    # get the region series for this dataset
    climate_brick <- region_series
    bio_variables <- names(region_series)

    time_bp <- check_time_vars(time_bp = time_bp, time_ce = time_ce)
    # boolean whether we will need to read time_ce instead of time_bp
    read_ce <- FALSE
    if (any(!is.null(time_ce), "time_ce" %in% names(x))) {
      read_ce <- TRUE
    }

    # if we have a data.frame
    if (inherits(x, "data.frame")) {
      coords <- check_coords_names(x, coords)

      # check how time has been provided
      # first make sure that, if there is a column, only one is provided
      if (all(c("time_bp", "time_ce") %in% names(x))) {
        stop(
          "in x, there should only be either a 'time_bp' column, or ",
          "a 'time_ce' column"
        )
      }
      # check whether we have time both in the df and in the vector
      if (all(
        any(c("time_bp", "time_ce") %in% names(x)),
        any(!is.null(time_bp), !is.null(time_ce))
      )) {
        stop(
          "times should either be given as a column of x, or as values ",
          "for time_bp or time_ce,",
          "not both at the same time!"
        )
      }
      # check if it is missing everywhere
      if (all(
        all(!c("time_bp", "time_ce") %in% names(x)),
        all(is.null(time_bp), is.null(time_ce))
      )) {
        stop(
          "missing times: they should either be given as a column of x, ",
          "or as values for time_bp or time_ce"
        )
      }
      locations_data <- x
    } else if (inherits(x, "numeric")) {
      locations_data <- data.frame(cell_number = x)
    }
    # add time_bp if needed
    if (!is.null(time_bp)) {
      locations_data$time_bp <- time_bp
    }
    if ("time_ce" %in% names(locations_data)) {
      locations_data$time_bp <- locations_data$time_ce - 1950
    }

    # reorder input by time
    orig_id <- order(locations_data$time_bp)
    locations_data <- locations_data[order(locations_data$time_bp), ]
    time_indeces <- NULL
    # store coordinates in their own data.frame to be used for terra operations
    if (inherits(x, "data.frame")) {
      coords_df <- locations_data[, coords]
    } else {
      coords_df <- locations_data[, c("cell_number")]
    }

    # now sort out the time slices corresponding to each location
    times <- time_bp(climate_brick)
    time_indeces <- time_bp_to_index(
      time_bp = locations_data$time_bp, time_steps = times
    )
    locations_data$time_bp_slice <- times[time_indeces]

    # if we are not using a buffer, we try to get all the values from
    # specific locations directly
    if (!buffer) {
      locations_climate <- terra::extract(climate_brick,
        y = locations_data[coords],
        layer = time_indeces
      )
      # for each bio_variable (the list element), extract the value column from
      # the data.frame and assign to locations_data
      for (var in bio_variables) {
        locations_data[[var]] <- locations_climate[[var]]$value
      }
    } else {
      # if we are using a buffer, set to NA as we will compute them later
      for (var in bio_variables) {
        locations_data[[var]] <- NA
      }
    }

    # if we interpolate or use a buffer, we have to find the incomplete cases
    if (nn_interpol || buffer) {
      loc_id_to_move <- which(!stats::complete.cases(locations_data))
      # only do something if we have some locations for which we have no data
      if (length(loc_id_to_move) != 0) {
        # for each id, get the appropriate list of neighbours
        rast_id_to_move <- terra::cellFromXY(
          climate_brick[[1]],
          as.matrix(coords_df[loc_id_to_move, ])
        )
        neighbours_list <- terra::adjacent(
          climate_brick[[1]],
          rast_id_to_move,
          directions = directions,
          pairs = FALSE
        )
        # convert from matrix (one row per location) to data.frame where first
        # column is focal location, second column is id of each neighbour
        neighbours_list <- data.frame(
          focal_id = rep(as.numeric(rownames(neighbours_list)),
            each = ncol(neighbours_list)
          ),
          neighbour_id = as.vector(t(neighbours_list)),
          layer = rep(time_indeces[loc_id_to_move],
            each = ncol(neighbours_list)
          ),
          unique_id = rep(seq_len(nrow(neighbours_list)),
            each = ncol(neighbours_list)
          )
        )
        # there is a BUG terra does not seem to cope with using layer when
        # extracting from sds if y is cellID, y has to be a data.frame
        neighbours_coords <- as.data.frame(terra::xyFromCell(
          climate_brick[[1]],
          neighbours_list$neighbour_id
        ))
        # extract the climate for all neighbours
        neighbours_values <-
          terra::extract(
            x = climate_brick,
            y = neighbours_coords,
            layer = neighbours_list$layer
          )

        # for each variable, compute the mean across neighbours
        # and replace the values in locations_data
        for (i_var in bio_variables) {
          if (i_var == "biome") {
            # for factors, compute the mode across neighbours
            neighbours_mode <- tapply(
              neighbours_values[[i_var]]$value,
              neighbours_list$unique_id,
              mode
            )
            locations_data[loc_id_to_move, i_var] <-
              neighbours_mode
          } else {
            neighbours_mean <- tapply(
              neighbours_values[[i_var]]$value,
              neighbours_list$unique_id,
              mean,
              na.rm = TRUE
            )
            locations_data[loc_id_to_move, i_var] <-
              neighbours_mean
          }
        }
      }
    }


    # is.nan has no method for a data.frame
    # nolint start
    is.nan.data.frame <- function(x) {
      do.call(cbind, lapply(x, is.nan))
    }
    # nolint end

    locations_data[is.nan(locations_data)] <- NA

    locations_data <- locations_data[order(orig_id), ]

    if (read_ce) {
      locations_data$time_ce <- locations_data$time_bp + 1950
      locations_data$time_ce_slice <- locations_data$time_bp_slice + 1950
      locations_data <- locations_data[
        ,
        !names(locations_data) %in%
          c("time_bp", "time_bp_slice")
      ]
    }

    # reintroduce the factor
    if ("biome" %in% bio_variables) {
      biome_levels <- levels(region_series$biome)[[1]]$category
      # get the levels from the numeric values
      biome_numeric <- match(locations_data$biome, levels(region_series$biome)[[1]]$id)
      locations_data$biome <- factor(biome_levels[biome_numeric],
        levels = biome_levels
      )
    }
    return(locations_data)
  }


#' Mode
#'
#' Find the mode of vector x (note that, if multiple values have the same
#' frequency, this function simply picks the first occurring one)
#'
#' @param x a vector
#' @returns the mode
#'
#' @keywords internal

mode <- function(x) {
  x <- x[!is.na(x)]
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}
