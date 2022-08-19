#' Set the data path where climate reconstructions will be stored
#'
#' This function sets the path where climate reconstructions will be stored.
#' This
#' information is stored in a file names "pastclim_data.txt", which is found
#' in the directory returned by `tools::R_user_dir("pastclim","config")` (i.e.
#' the default configuration directory for the package as set in R >= 4.0).
#'
#' @param path_to_nc the path to the file that contains the downloaded
#' resonstructions. If left unset, the default location returned by
#' `tools::R_user_dir("pastclim","data")` will be used
#'
#' @export

set_data_path <- function(path_to_nc = NULL) {
  # if we don't have a config directory, create one
  if (!dir.exists(tools::R_user_dir("pastclim", "config"))) {
    dir.create(tools::R_user_dir("pastclim", "config"), recursive = TRUE)
  }
  # use the default location
  if (is.null(path_to_nc)) {
    cat(tools::R_user_dir("pastclim", "data"), "\n",
      file = file.path(
        tools::R_user_dir("pastclim", "config"),
        "pastclim_data.txt"
      )
    )
    # and now create it if it does not exist yet
    if (!dir.exists(tools::R_user_dir("pastclim", "data"))) {
      dir.create(tools::R_user_dir("pastclim", "data"), recursive = TRUE)
    }
    # update option
    options(pastclim.data_path = tools::R_user_dir("pastclim", "data"))
  } else {
    # check that it exists
    if (dir.exists(path_to_nc)) {
      cat(path_to_nc, "\n", file = file.path(
        tools::R_user_dir("pastclim", "config"),
        "pastclim_data.txt"
      ))
    } else {
      stop(path_to_nc, " does not exist!")
    }
    # update option
    options(pastclim.data_path = path_to_nc)
  }
  # move the example data into the new data path
  copy_example_data()
}


#' Get the data path where climate reconstructions are stored
#'
#' This function returns the path where climate reconstructions will be stored.
#' This information is stored in a file names "pastclim_data.txt", which
#' is found in the directory returned by 
#' `tools::R_user_dir("pastclim","config")` (i.e.
#' the default configuration directory for the package as set in R >= 4.0).
#'
#' If this function is run before any path was set, it calls `set_data_path`,
#' which defaults to storing data in the directory returned by
#' `tools::R_user_dir("pastclim","data")`
#'
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
#' @keywords internal

copy_example_data <- function() {
  if (!file.exists(file.path(get_data_path(), "example_climate_nc"))) {
    file.copy(
      from = system.file("/extdata/example_climate.nc",
        package = "pastclim"
      ),
      to = file.path(get_data_path(), "example_climate.nc")
    )
  }
}
