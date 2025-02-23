#' Get time steps for a given MIS
#'
#' Get the time steps available in a given dataset for a MIS.
#'
#' @param mis string giving the mis; it must use the same spelling as used in
#' [mis_boundaries]
#' @param dataset string defining dataset to be downloaded (a list of possible
#' values can be obtained with [list_available_datasets()]). If set to
#' "custom", then a single nc file is used from "path_to_nc"
#' @param path_to_nc the path to the custom nc file containing the palaeoclimate
#' reconstructions. All the variables of interest need to be included in
#' this file.
#' @returns a vector of time steps
#'
#' @export

get_mis_time_steps <- function(mis, dataset, path_to_nc = NULL) {
  if (!mis %in% mis_boundaries$mis) {
    stop("'mis' should be one of ", paste(mis_boundaries$mis, collapse = ","))
  }

  time_steps <- get_time_bp_steps(dataset = dataset, path_to_nc = path_to_nc)
  mis_time_steps <- time_steps[
    time_steps > (mis_boundaries[mis_boundaries$mis == mis, "start"] * 1000) &
      time_steps <= (mis_boundaries[mis_boundaries$mis == mis, "end"] * 1000)
  ]
  return(mis_time_steps)
}
