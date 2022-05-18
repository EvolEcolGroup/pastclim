#' Get time steps for a given MIS
#'
#' Get the time steps available in a given dataset for a MIS.
#'
#' @param mis string giving the mis; it must use the same spelling as used in
#' /code{mis_boundaries}
#' @param dataset string defining dataset to be downloaded (currently only
#' "Beyer2020" or "Krapp2021" are available)
#' @param path_to_nc the path to the directory containing the downloaded
#' reconstructions. Leave it unset if you are using the companion
#' `pastclimData` to store datasets.
#'
#' @export

get_mis_time_steps <- function(mis, dataset, path_to_nc = NULL) {
  if (!mis %in% mis_boundaries$mis) {
    stop("'mis' should be one of ", paste(mis_boundaries$mis, collapse = ","))
  }

  if (is.null(path_to_nc)) {
    path_to_nc <- get_pastclimdata_path()
  }
  # we get the first available file to get info for the dataset
  possible_vars <- get_vars_for_dataset(dataset)
  this_file <- get_file_for_dataset(possible_vars[1], dataset)$file_name
  this_file <- file.path(path_to_nc, this_file)

  climate_nc <- ncdf4::nc_open(this_file)
  time_steps <- (climate_nc$dim$time$vals)
  ncdf4::nc_close(climate_nc)
  mis_time_steps <- time_steps[time_steps > (mis_boundaries[mis_boundaries$mis
                                                      == mis, "start"] * 1000) &
    time_steps <= (mis_boundaries[mis_boundaries$mis == mis, "end"] * 1000)]
  return(mis_time_steps)
}
