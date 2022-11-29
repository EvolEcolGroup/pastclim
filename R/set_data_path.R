#' Set the data path where climate reconstructions will be stored
#'
#' This function sets the path where climate reconstructions will be stored.
#' This
#' information is stored in a file names "pastclim_data.txt", which is found
#' in the directory returned by `tools::R_user_dir("pastclim","config")` (i.e.
#' the default configuration directory for the package as set in R >= 4.0).
#'
#' @param path_to_nc the path to the file that contains the downloaded
#' reconstructions. If left unset, the default location returned by
#' `tools::R_user_dir("pastclim","data")` will be used
#' @return TRUE if the path was set correctly
#'
#' @export

set_data_path <- function(path_to_nc = NULL) {
  # if we don't have a config directory, create one
  if (!dir.exists(tools::R_user_dir("pastclim", "config"))) {
    dir.create(tools::R_user_dir("pastclim", "config"), recursive = TRUE)
  }
  # if use the default location for data
  if (is.null(path_to_nc)) {
    path_to_nc <- tools::R_user_dir("pastclim", "data")
    # create it if it does not exist yet
    if (!dir.exists(path_to_nc)) {
      dir.create(path_to_nc, recursive = TRUE)
    }
  } else { # if custom path, stop if it does not exist
    if (!dir.exists(path_to_nc)){
      stop(path_to_nc, " does not exist!")
    }
  }
  
  utils::write.table(path_to_nc,
              row.names = FALSE,
              col.names = FALSE, 
              file = file.path(
                tools::R_user_dir("pastclim", "config"),
                "pastclim_data.txt"
              )
  )
  
  # update option
  options(pastclim.data_path = path_to_nc)
  # move the example data into the new data path
  copy_example_data()
  return (TRUE)
}


#' Get the data path where climate reconstructions are stored
#'
#' This function returns the path where climate reconstructions will be stored.
#' When `pastclim` is installed, the data path defaults to the directory
#' returned by `tools::R_user_dir("pastclim","data")` (i.e. the data directory
#' for the package in R>=4.0). The data path can be changed with 
#' \code{set_data_path}. Once changed, `pastclim` will remember the new data
#' path in the future.
#' 
#' The data path is stored in a file named "pastclim_data.txt", which
#' is found in the directory returned by 
#' `tools::R_user_dir("pastclim","config")` (i.e.
#' the default configuration directory for the package as set in R >= 4.0).
#'
#' @returns the data path
#' @export

get_data_path <- function() {
  # if the package already initiliased
  if (!is.null(getOption("pastclim.data_path"))) {
    return(getOption("pastclim.data_path"))
  } else { # get the info from the config file
    # if data path was never set before, we set it to its default location
    if (!file.exists(file.path(
      tools::R_user_dir("pastclim", "config"),
      "pastclim_data.txt"
    ))) {
      set_data_path()
    }
    path_to_nc <- utils::read.table(file.path(
      tools::R_user_dir("pastclim", "config"),
      "pastclim_data.txt"
    ))[1, 1]
    return(path_to_nc)
  }
}

#' Internal function to copy the example dataset when a new data path is set
#'
#' Copy example dataset
#' 
#' @returns TRUE if the data were copied successfully
#'
#' @keywords internal

copy_example_data <- function() {
  if (!file.exists(file.path(get_data_path(), "example_climate_v2.nc"))) {
    file.copy(
      from = system.file("/extdata/example_climate_v2.nc",
        package = "pastclim"
      ),
      to = file.path(get_data_path(), "example_climate_v2.nc")
    )
  }
  return(TRUE)
}
