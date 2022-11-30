.onLoad <- function(libname, pkgname) {
  # store the data path as an option for easy retrieval
  op <- options()
  op.pastclim <- list(
    pastclim.data_path = get_data_path(silent=TRUE)
  )
  toset <- !(names(op.pastclim) %in% names(op))
  if (any(toset)) options(op.pastclim[toset])

  # check that gdal was compiled with netcdf support
  d <- gdal(drivers=TRUE)
  if (!"netCDF" %in% terra::gdal(drivers=TRUE)$name){
    stop("The installed version of terra lacks support for reading netcdf files.\n",
         "pastclim needs netcdf support: you will need to reinstall terra,\n",
         "possibly from source, if there isn't a version with netcdf support\n",
         "on CRAN. Alternatively, try the latest development version from R-universe:\n",
         "install.packages('terra', repos='https://rspatial.r-universe.dev')")
  }

  invisible()
}
