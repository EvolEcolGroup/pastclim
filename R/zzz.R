.onLoad <- function(libname, pkgname) {
  op <- options()
  op.pastclim <- list(
    pastclim.data_path = get_data_path()
  )
  toset <- !(names(op.pastclim) %in% names(op))
  if (any(toset)) options(op.pastclim[toset])

  # check that gdal was compiled with netcdf support
  d <- gdal(drivers=TRUE)
  if (!"netCDF" %in% terra::gdal(drivers=TRUE)$name){
    stop("the R library terra currently installed relies on a version of gdal that does not support reading netcdf files.",
         "You will need to reinstall terra, possibly from source, if there isn't
         a version with netcdf support on CRAN.")
  }

  invisible()
}
