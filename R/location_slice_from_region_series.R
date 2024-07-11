#' Extract local climate for one or more locations for a given time slice.
#'
#' This function extract local climate for a set of locations
#' at the appropriate times (selecting the closest time slice available for the
#' specific date associated with each location).
#'
#' @param x a data.frame with columns x and y coordinates(see `coords` for
#' standard coordinate names, or
#' how to use custom ones), plus optional
#' columns `time_bp` or `time_ce` (depending on the units used) and
#'  `name`. Alternatively, a vector of cell numbers.
#' @param time_bp used if no `time_bp` column is present in `x`: the dates in
#' years before present (negative
#' values represent time before present, i.e. 1950, positive values time in the future)
#' for each location.
#' @param time_ce time in years CE as an alternative to `time_bp`. Only one of
#' `time_bp` or `time_ce` should be used.
#' @param coords a vector of length two giving the names of the "x" and "y"
#' coordinates, as found in `data`. If left to NULL, the function will
#' try to guess the columns based on standard names `c("x", "y")`, `c("X","Y")`,
#'  `c("longitude", "latitude")`, or `c("lon", "lat")`
#' @param region_series a [`terra::SpatRasterDataset`] obtained with [region_series()]
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

location_slice_from_region_series <-
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
    readd_ce <- FALSE # boolean whether we will need to readd time_ce instead of time_bp
    if (any(!is.null(time_ce), "time_ce" %in% names(x))) {
      readd_ce <- TRUE
    }

    # if we have a data.frame
    if (inherits(x, "data.frame")) {
      coords <- check_coords_names(x, coords)

      # check how time has been provided
      # first make sure that, if there is a column, only one is provided
      if (all(c("time_bp", "time_ce") %in% names(x))) {
        stop("in x, there should only be either a 'time_bp' column, or a 'time_ce' column")
      }
      # check whether we have time both in the df and in the vector
      if (all(
        any(c("time_bp", "time_ce") %in% names(x)),
        any(!is.null(time_bp), !is.null(time_ce))
      )) {
        stop(
          "times should either be given as a column of x, or as values for time_bp or time_ce,",
          "not both at the same time!"
        )
      }
      # check if it is missing everywhere
      if (all(
        all(!c("time_bp", "time_ce") %in% names(x)),
        all(is.null(time_bp), is.null(time_ce))
      )) {
        stop("missing times: they should either be given as a column of x, or as values for time_bp or time_ce")
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
    unique_times <- unique(locations_data$time_bp_slice)

    for (i_time in unique_times) {
      this_slice <- slice_region_series(climate_brick,
        time_bp = i_time
      )

      this_slice_indeces <- which(locations_data$time_bp_slice == i_time)
      if (!buffer) { # get the specific values for those locations
        this_climate <- terra::extract(
          x = this_slice,
          y = locations_data[locations_data$time_bp_slice == i_time, coords]
        )
        # sort out the indexing here
        locations_data[locations_data$time_bp_slice == i_time, bio_variables] <-
          this_climate[
            ,
            bio_variables
          ]
      } else { # set to NA as we will compute them with a buffer
        locations_data[this_slice_indeces, ] <- NA
      }

      # factors don't behave nicely when adding new elements, cast to character
      if ("biome" %in% names(locations_data)){
        locations_data$biome <- as.character(locations_data$biome)
      }
      if (nn_interpol | buffer) {
        locations_to_move <- this_slice_indeces[this_slice_indeces %in%
          which(!stats::complete.cases(locations_data))]
        if (length(locations_to_move) == 0) {
          next
        }
        for (i in locations_to_move) {
          if (inherits(x, "data.frame")) {
            cell_id <-
              terra::cellFromXY(this_slice, as.matrix(coords_df[
                i,
              ]))
          } else {
            cell_id <- coords_df[i]
          }
          neighbours_ids <-
            terra::adjacent(this_slice, cell_id,
              directions = directions, pairs = FALSE
            )

          neighbours_values <-
            terra::extract(
              x = this_slice,
              y = neighbours_ids[1, ]
            ) # [, bio_variables]

          neighbours_values_mean <- apply(neighbours_values[,!names(neighbours_values) %in% "biome"], 2,
            mean,
            na.rm = T
          )
          if ("biome" %in% bio_variables) {
            neighbours_values_mean["biome"] <- mode(as.numeric(neighbours_values[, "biome"]))
          }
          locations_data[i, bio_variables] <-
            neighbours_values_mean[bio_variables]
        }
      }
    }
    # is.nan has not method for a data.frame
    is.nan.data.frame <- function(x) {
      do.call(cbind, lapply(x, is.nan))
    }

    locations_data[is.nan(locations_data)] <- NA

    locations_data <- locations_data[order(orig_id), ]

    if (readd_ce) {
      locations_data$time_ce <- locations_data$time_bp + 1950
      locations_data$time_ce_slice <- locations_data$time_bp_slice + 1950
      locations_data <- locations_data[, !names(locations_data) %in% c("time_bp", "time_bp_slice")]
    }
    
    # reintroduce the factor
    if ("biome" %in% bio_variables){
      locations_data$biome <- factor(levels(region_series$biome)[[1]]$category[as.numeric(locations_data$biome)],
                                     levels = levels(region_series$biome)[[1]]$category)
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
