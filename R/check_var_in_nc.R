#' Check whether variables exist in a netcdf file
#'
#' Internal function to test a custom nc file.
#'
#' @param bio_variables vector of names of variables to be extracted
#' @param path_to_nc the path to the custom nc file containing the paleoclimate
#' reconstructions.
#' 
#' @keywords internal

check_var_in_nc <- function(bio_variables, path_to_nc) {
  # test that file exists
  if (!file.exists(path_to_nc)) {
    stop("file ", path_to_nc, " does not exist")
  }
  nc_in <- ncdf4::nc_open(path_to_nc)
  nc_in_dims <- names(nc_in$dim)
  nc_in_vars <- names(nc_in$var)
  ncdf4::nc_close(nc_in)
  # test that we have a time dimension
  if (!"time" %in% nc_in_dims) {
    stop("the file does not include a time dimension")
  }
  # test that all vars are present in the netcdf file
  if (!all(bio_variables %in% nc_in_vars)) {
    stop(
      "variable (", paste(bio_variables[!bio_variables %in% nc_in_vars],
        collapse = ", "
      ),
      ") not present in the file"
    )
  }
}
