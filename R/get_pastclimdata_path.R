#' Get the path for pastclimdata.
#'
#' This function returns the path for pastclimData where reconstructions
#' are stored.
#'
#' @export

get_pastclimdata_path <- function() {
  path_to_nc <- system.file("extdata", package = "pastclimData")
  if (path_to_nc == "") {
    stop('the parameter path_to_nc was not set, and the package pastclimData',
        'is not installed.\n
         You can install pastclimData with the following command:\n
         devtools::install_github("EvolEcolGroup/pastclimData",ref="master")')
  }
  return(path_to_nc)
}
