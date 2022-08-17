#' Get time steps for a given dataset
#'
#' Get the time steps available in a given dataset.
#'
#' @param dataset string defining dataset to be downloaded (currently only
#' "Beyer2020", "Krapp2021" and "Example" are available). Leave it unset 
#' if using `path_to_nc`
#' @param path_to_nc the path to the directory containing the downloaded
#' reconstructions. Leave it unset if you are using the companion
#' `pastclimData` to store datasets.
#'
#' @export

get_time_steps <- function(dataset = NULL, path_to_nc = NULL) {
  if (all(is.null(dataset),is.null(path_to_nc))){
    stop("Either dataset or path_to_nc needs to be given")
  } else if (!any(is.null(dataset),is.null(path_to_nc))) {
    stop("Only dataset or path_to_nc can be given")
  }

  if (is.null(path_to_nc)) {
    path_to_nc <- get_pastclimdata_path()
  }
  # we get the first available file to get info for the dataset
  if (!is.null(dataset)) {
    possible_vars <- get_vars_for_dataset(dataset)
    this_file <- get_file_for_dataset(possible_vars[1], dataset)$file_name
    this_file <- file.path(path_to_nc, this_file)
  } else {
    
  }

  climate_nc <- ncdf4::nc_open(this_file)
  time_steps <- (climate_nc$dim$time$vals)
  ncdf4::nc_close(climate_nc)
  mis_time_steps <- time_steps[time_steps > (mis_boundaries[mis_boundaries$mis
                                                      == mis, "start"] * 1000) &
    time_steps <= (mis_boundaries[mis_boundaries$mis == mis, "end"] * 1000)]
  return(mis_time_steps)
}
