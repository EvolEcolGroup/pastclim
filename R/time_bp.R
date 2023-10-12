#' Extract and set time in years before present for SpatRaster and SpatRasterDataset
#'
#' This functions extracts and sets time in years BP (i.e. from 1950) for a
#' [`terra::SpatRaster`] or  a [`terra::SpatRasterDataset`]. In a [`terra::SpatRaster`] object, time is
#' stored with unit "years", which
#' are years from 0AD. This means that, when a summary of the
#' [`terra::SpatRaster`] is
#' inspected, the times will appear as `time_bp`+1950. The same applies when the
#' function [terra::time()] is used instead of [time_bp()].
#'
#' @param x a [`terra::SpatRaster`]
#' @param value a numeric vector of times in years BP
#' @returns a date in years BP (where negative numbers indicate a date in the past)
#' @rdname time_bp
#' @import methods
#' @export

setGeneric("time_bp", function(x) {
  standardGeneric("time_bp")
})

#' @rdname time_bp
#' @export
setMethod(
  "time_bp", signature(x = "SpatRaster"),
  function(x) {
    if (timeInfo(x)$step != "years") {
      # as of 1.7.18, the bug in terra setting years to negative has ben fixed
      stop(
        "The time units of SpatRaster are not 'years'.\n",
        "It might be a problem with the time units not being properly set in the original nc file.\n",
        "Set time units correctly with time_bp(x)<-c(-10000,-400).\n",
        "NOTE do NOT use terra:time, as that terra measures years from 0AD, not BP"
      )
    }
    time_yr <- terra::time(x)
    return(time_yr - 1950)
  }
)

#' @rdname time_bp
#' @export
setMethod(
  "time_bp", signature(x = "SpatRasterDataset"),
  function(x) {
    if (!is_region_series(x)) {
      stop("this is not a valid region series; it should be a SpatRasterDataset where each dataset (i.e. variable) has the same time steps")
    }
    if (timeInfo(x[[1]])$step != "years") {
      # as of 1.7.18, the bug in terra setting years to negative has been fixed
      stop(
        "The time units of SpatRaster are not 'years'.\n",
        "It might be a problem with the time units not being properly set in the original nc file.\n",
        "Set time units correctly with time_bp(x)<-c(-10000,-400).\n",
        "NOTE do NOT use terra:time, as that terra measures years from 0AD, not BP"
      )
    }
    time_yr <- terra::time(x[[1]])
    return(time_yr - 1950)
  }
)



#' @rdname time_bp
#' @export
setGeneric("time_bp<-", function(x, value) {
  standardGeneric("time_bp<-")
})

#' @rdname time_bp
#' @export
setMethod(
  "time_bp<-", signature(x = "SpatRaster"),
  function(x, value) {
    value_bp <- value + 1950
    time(x, tstep = "years") <- value_bp
    return(x)
  }
)

#' @rdname time_bp
#' @export
setMethod(
  "time_bp<-", signature(x = "SpatRasterDataset"),
  function(x, value) {
    if (!is_region_series(x)) {
      stop("this is not a valid region series; it should be a SpatRasterDataset where each dataset (i.e. variable) has the same time steps")
    }
    # convert yrs BP to yrs AD for terra
    value_bp <- value + 1950
    for (i in 1:length(x)) {
      time(x[i], tstep = "years") <- value_bp
    }
    return(x)
  }
)
