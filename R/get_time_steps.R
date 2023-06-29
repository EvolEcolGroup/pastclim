#' Get time steps for a given dataset
#'
#' Get the time steps (in time_bp or time_ce) available in a given dataset.
#'
#' @param dataset string defining dataset to be downloaded (a list of possible
#' values can be obtained with [list_available_datasets()]). If set to
#' "custom", then a single nc file is used from "path_to_nc"
#' @param path_to_nc the path to the custom nc file containing the palaeoclimate
#' reconstructions. All the variables of interest need to be included in
#' this file.
#' @returns a vector of time steps (in time_bp, or time_ce)
#'
#' @export

get_time_bp_steps <- function(dataset, path_to_nc = NULL) {
  check_dataset_path(dataset = dataset, path_to_nc = path_to_nc)

  if (is.null(path_to_nc)) {
    # we get the first available file to get info for the dataset
    possible_vars <- get_vars_for_dataset(dataset, monthly = TRUE)
    this_file <- get_file_for_dataset(possible_vars[1], dataset)$file_name
    path_to_nc <- file.path(get_data_path(), this_file)
  }

  climate_nc <- terra::rast(path_to_nc, subds=1)
  return(time_bp(climate_nc))
}

#' @rdname get_time_bp_steps
#' @export
get_time_ce_steps <- function(dataset, path_to_nc = NULL) {
  get_time_bp_steps(dataset = dataset, 
                    path_to_nc = path_to_nc)+1950
}


#' @rdname get_time_bp_steps
#' @export
get_time_steps <- function(dataset, path_to_nc = NULL) {
  warning("this function is deprecated, use `get_time_bp_steps()` instead")
  get_time_bp_steps(dataset = dataset, 
                    path_to_nc = path_to_nc)
}


