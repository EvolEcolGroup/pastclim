#' Get the metadata for a variable in a given dataset.
#'
#' Internal getter function
#'
#' @param variable one or more variable names to be downloaded
#' @param dataset string defining dataset to be downloaded (a list of possible
#' values can be obtained with [list_available_datasets()]). This function
#' will not work on custom datasets.
#' @returns the metadata (including filename) for that variable in that dataset
#' @keywords internal

get_var_meta <- function(variable, dataset) {
  check_available_variable(variable, dataset)
  return(getOption("pastclim.dataset_list")[getOption("pastclim.dataset_list")$variable %in% variable &
    getOption("pastclim.dataset_list")$dataset == dataset, ])
}
