#' Get sea level estimate
#'
#' This function returns the estimated sea level from Spratt et al. 2016, using
#' the long PC1. Sea levels are from contemporary sea level (note that the original
#' data are with reference to the sea level during the Holocene ~5k year ago).
#'
#' @param time_bp the time of interest
#' @returns a vector of sea levels in meters from present level
#'
#' @keywords internal


get_sea_level <- function (time_bp){
  # get sea level from Spratt 2016
  sea_level_info <- utils::read.table(system.file("extdata/sea_level_spratt2016.txt",
                                                  package="pastclim"), header=TRUE)
  time_calkaBP <- -time_bp/1000
  if (any(time_calkaBP<0)){
    stop("this function only supports times in the past")
  }
  if (any(time_calkaBP>798)){
    stop("the dataset of sea level reconstructions stops at 798ky BP")
  }
  ## TODO this is not safe, we should be getting the closest values
  ## or even better interpolate
  sea_level <- stats::approx(x=sea_level_info$age_calkaBP,
                      y= sea_level_info$SeaLev_longPC1,
                      xout=time_calkaBP)$y
  sea_level <- sea_level - sea_level_info$SeaLev_longPC1[1] # rescale to have 0 for 0kBP
  return(sea_level)
}
