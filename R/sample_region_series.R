#' Sample points from a region time series
#'
#' This function samples points from a region time series. Sampling can either be
#' performed for the same locations at all time steps (if only one value is given
#' for `size`), or for different locations for each time step (if `size` is a
#' vector of length equal to the number of time steps). To sample the same
#' number of points, but different locations, for each time step, provide a vector
#' repeating the same value for each time step.
#'
#' This function wraps [terra::spatSample()] to appropriate sample the
#' [`terra::SpatRaster`]s in the [`terra::SpatRasterDataset`] returned
#' by [region_series()].
#'
#' @param x a [`terra::SpatRasterDataset`] returned
#' by [region_series()]
#' @param size number of points sampled. A single value is used to sample the same
#' locations across all time steps, a vector of values to sample different locations
#' at each time step.
#' @param method one of the sampling methods from [terra::spatSample()]. It
#' defaults to "random"
#' @param replace boolean determining whether we sample with replacement
#' @param na.rm boolean determining whether NAs are removed
#' @returns a data.frame with the sampled cells and their respective values for
#' the climate variables.
#'
#' @export

sample_region_series <- function(x, size, method = "random", replace = FALSE, na.rm = TRUE) {
  if (!is_region_series(x)) {
    stop("x is not a valid object generated by region_series")
  }

  if (length(size) == 1) {
    sample_rs_fixed(x, size, method = method, replace = replace, na.rm = na.rm)
  } else {
    sample_rs_variable(x, size, method = method, replace = replace, na.rm = na.rm)
  }
}

#' Sample the same locations from a region time series
#'
#' Internal function for fixed sampling from [sample_region_series()],
#' used when a single size is given.
#'
#' @param x a [`terra::SpatRasterDataset`] returned
#' by [region_series()]
#' @param size number of points sampled; the same
#' locations across all time steps
#' @param method one of the sampling methods from [terra::spatSample()]. It
#' defaults to "random"
#' @param replace boolean determining whether we sample with replacement
#' @param na.rm boolean determining whether NAs are removed
#' @returns a data.frame with the sampled cells and their respective values for
#' the climate variables.
#'
#' @keywords internal

sample_rs_fixed <- function(x, size, method = "random", replace = FALSE, na.rm = TRUE) {
  # sample the first variable
  # spatSample samples additional points to make sure it has enough points after
  # removing NA. The default exp=5 is not sufficient if size is very small.
  if ((size * 5) < 1000) {
    exp <- ceiling(1000 / size)
  } else {
    exp <- 5
  }
  var_values <- terra::spatSample(x[1], size,
    method = method,
    replace = replace, na.rm = na.rm,
    cells = TRUE, xy = TRUE, exp = exp
  )
  # get the details for the sampled cells
  sampled_cells <- var_values[, c("cell", "x", "y")]
  sampled_values <- sampled_cells[rep(seq_len(nrow(sampled_cells)),
    times = length(time_bp(x[1]))
  ), ]
  sampled_values$time_bp <- rep(time_bp(x[1]), each = nrow(sampled_cells))
  # let's reuse these vales

  for (this_var in names(x)) {
    if (this_var != names(x)[1]) {
      # extract values for this variable
      var_values <- terra::extract(x[this_var], sampled_cells$cell)
    } else {
      # reuse the values obtained from spatSample
      var_values <- var_values[, -c(1:3)]
    }
    colnames(var_values) <- time_bp(x[1])
    var_values <- utils::stack(var_values)
    sampled_values[this_var] <- var_values[, 1]
  }
  return(sampled_values)
}

#' Sample the different number of points from a region time series
#'
#' Internal function for sampling different number of points for each
#' timestep of a region series from [sample_region_series()],
#' used when size is a vector of values.
#'
#' @param x a [`terra::SpatRasterDataset`] returned
#' by [region_series()]
#' @param size a vector of the number of points sampled for each time step
#' @param method one of the sampling methods from [terra::spatSample()]. It
#' defaults to "random"
#' @param replace boolean determining whether we sample with replacement
#' @param na.rm boolean determining whether NAs are removed
#' @returns a data.frame with the sampled cells and their respective values for
#' the climate variables.
#'
#' @keywords internal

sample_rs_variable <- function(x, size, method = "random", replace = FALSE, na.rm = TRUE) {
  if (sum(size) == 0) {
    stop("at least one element of sample size should be larger than zero")
  }
  if (length(size) != length(time_bp(x[1]))) {
    stop("size should be the same length as the number of time steps in x")
  }
  # create list to store samples for each time step
  sample_list <- list()
  t_steps <- time_bp(x[1])
  for (i in seq_len(length(size))) {
    if (size[i] > 0) {
      x_step <- slice_region_series(x, t_steps[i])
      # spatSample samples additional points to make sure it has enough points after
      # removing NA. The default exp=5 is not sufficient if size is very small.
      if ((size[i] * 5) < 1000) {
        exp <- ceiling(1000 / size[i])
      } else {
        exp <- 5 # the terra default
      }
      values <- terra::spatSample(x_step, size[i],
        method = method,
        replace = replace, na.rm = na.rm,
        cells = TRUE, xy = TRUE, exp = exp
      )
      values$time_bp <- t_steps[i]
      # write into output
      sample_list[[as.character(t_steps[i])]] <- values
    }
  }
  # combine them into a single matrix
  sampled_climate <- do.call(rbind, sample_list)
  return(sampled_climate)
}
