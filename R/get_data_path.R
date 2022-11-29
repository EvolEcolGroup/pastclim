#' Get the data path where climate reconstructions are stored
#'
#' This function returns the path where climate reconstructions are stored.
#' 
#' The path is stored in an option for `pastclim` named `data_path`. If
#' a configuration file was saved when using \code{set_data_path}, the path
#' is retrieved from a file named "pastclim_data.txt", which
#' is found in the directory returned by 
#' `tools::R_user_dir("pastclim","config")` (i.e.
#' the default configuration directory for the package as set in R >= 4.0).
#'
#' @param silent boolean on whether a message is returned when data_path is 
#' not set (i.e. equal to NULL)
#' @returns the data path
#' @export

get_data_path <- function(silent=FALSE) {
  # if the package already initiliased
  if (!is.null(getOption("pastclim.data_path"))) {
    return(getOption("pastclim.data_path"))
  } else {  # get the info from the config file
    # if the path was not set yet, return a message
    if (!file.exists(file.path(
      tools::R_user_dir("pastclim", "config"),
      "pastclim_data.txt"
    ))) {
      if (!silent) {
        message("A default data_path was not set for pastclim;\n",
                "use `set_data_path()` to set it.")
      }
      return(NULL)
    }
    path_to_nc <- utils::read.table(file.path(
      tools::R_user_dir("pastclim", "config"),
      "pastclim_data.txt"
    ))[1, 1]
    if (!dir.exists(path_to_nc)){
      stop("The path ",path_to_nc," from the config file does not exist!\n",
            "You can reset the path with `set_data_path`.")
    }
    return(path_to_nc)
  }
}
