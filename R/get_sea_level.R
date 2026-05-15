#' Get sea level estimate
#'
#' This function returns the estimated sea level from Spratt et al. 2016, using
#' the long PC1. Sea levels are from contemporary sea level (note that the
#' original data are with reference to the sea level during the Holocene ~5k
#' year ago).
#'
#' @param time_bp the time of interest
#' @param dataset the dataset to use, either "spratt2016" or "clark2025"
#' @returns a vector of sea levels in meters from present level
#'
#' @keywords internal


get_sea_level <- function(time_bp, dataset = "spratt2016") {
  dataset <- match.arg(dataset, c("spratt2016", "clark2025"))
  if (dataset == "spratt2016") {
    # check that time is not too old for the dataset
    if (any(time_bp < -798000)) {
      stop("spratt2016 only reached -798,000 years BP")
    }
    sea_level_info <- spratt2016
  } else if (dataset == "clark2025") {
    if (any(time_bp < -4882000)) {
      stop("clark2025 only reached -4,882,000 years BP")
    }
    sea_level_info <- clark2025
  }


  ## TODO this is not safe, we should be getting the closest values
  ## or even better interpolate
  sea_level <- stats::approx(
    x = sea_level_info$time_bp,
    y = sea_level_info$sea_level,
    xout = time_bp
  )$y
  # rescale to have 0 for 0kBP
  sea_level <- sea_level - sea_level_info$sea_level[sea_level_info$time_bp == 0]
  return(sea_level)
}
