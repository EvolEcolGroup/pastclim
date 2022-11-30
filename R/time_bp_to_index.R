#' Find the closest index to a given time in years BP
#'
#' Internal function
#'
#' @param time_bp vector of times BP
#' @param time_steps time steps for which reconstructions are available
#' @returns the indeces for the relevant time steps
#' @keywords internal

time_bp_to_index <- function(time_bp, time_steps) {
  time_indeces <-
    sapply(time_bp, function(a, b) {
      which.min(abs(a - b))
    }, time_steps)
  return(time_indeces)
}
