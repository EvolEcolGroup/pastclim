#' Convert a time BP to indexes for a series
#'
#' Internal function
#'
#' @param time_bp vector of times BP
#' @param time_steps time steps for which reconstructions are available
#' @returns the indeces for the relevant time steps
#'
#' @keywords internal

time_bp_to_i_series <- function(time_bp, time_steps) {
  # if this is a vector, just use the values
  if (is.numeric(time_bp)) {
    time_index <- match(time_bp, time_steps)
    if (any(is.na(time_index))) {
      stop("time_bp should only include time steps available in the dataset")
    }
    # if this is a list
  } else if (inherits(time_bp, "list")) {
    if (!all(names(time_bp) == c("min", "max"))) {
      stop("time_bp should be a list with min and max elements")
    }
    if (time_bp$min > time_bp$max) {
      stop("in time_bp, min should be less than max")
    }
    time_bp <- time_steps[time_steps >= time_bp$min & time_steps <= time_bp$max]
    time_index <- match(time_bp, time_steps)
    # finally give an error if this is not null
  } else if (is.null(time_bp)) {
    time_index <- NULL
  } else {
    stop("time_bp can only be NULL, a numeric vector, or a list with min and max values")
  }
  return(time_index)
}
