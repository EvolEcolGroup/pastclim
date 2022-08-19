#' Get time steps for a given dataset
#'
#' Get the time steps available in a given dataset.
#'
#' @param dataset string defining dataset to be downloaded (a list of possible
#' values can be obtained with \code{get_available_datasets}). If set to "custom",
#' then a single nc file is used from "path_to_nc"
#' @param path_to_nc the path to the custom nc file containing the paleoclimate
#' reconstructions. All the variables of interest need to be included in this file.
#'
#' @export

get_time_steps <- function(dataset, path_to_nc = NULL) {
  check_dataset_path(dataset = dataset, path_to_nc = path_to_nc)

  if (is.null(path_to_nc)) {
    # we get the first available file to get info for the dataset
    possible_vars <- get_vars_for_dataset(dataset)
    this_file <- get_file_for_dataset(possible_vars[1], dataset)$file_name
    path_to_nc <- file.path(get_data_path(), this_file)
  }

  climate_nc <- ncdf4::nc_open(path_to_nc)
  time_steps <- (climate_nc$dim$time$vals)
  ncdf4::nc_close(climate_nc)
  return(time_steps)
}
