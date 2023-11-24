#' Find the closest index to a given time in years BP
#'
#' Internal function
#'
#' @param time_bp vector of times BP
#' @param time_steps time steps for which reconstructions are available
#' @returns the indeces for the relevant time steps
#' @keywords internal

time_bp_to_index <- function(time_bp, time_steps) {
  # give warning if some dates are too extreme
  time_steps_ordered <- sort(time_steps)
  range_minmax <- c(
    head(time_steps_ordered, n = 1)[1] -
      (abs(head(time_steps_ordered, n = 2)[1] - head(time_steps_ordered, n = 2)[2]) / 2),
    tail(time_steps_ordered, n = 1)[1] +
      (abs(tail(time_steps_ordered, n = 2)[1] - tail(time_steps_ordered, n = 2)[2]) / 2)
  )
  if (any(time_bp < range_minmax[1]) | any(time_bp > range_minmax[2])) {
    warning(
      "Some dates are out of the range of the available time series.\n",
      "They will be assigned to the most extreme time point available, but this\n",
      "might not make sense. The potentially problematic dates are:\n",
      time_bp[which((time_bp < range_minmax[1]) | (time_bp > range_minmax[2]))]
    )
  }
  # get indeces
  time_indeces <-
    sapply(time_bp, function(a, b) {
      which.min(abs(a - b))
    }, time_steps)
  return(time_indeces)
}
