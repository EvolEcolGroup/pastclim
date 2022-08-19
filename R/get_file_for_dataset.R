#' Get the file details for a variable and dataset.
#'
#' Internal getter function
#'
#' @param variable one or more variable names to be downloaded
#' @param dataset string defining dataset to be downloaded (a list of possible
#' values can be obtained with \code{get_available_datasets}). This function
#' will not work on custom datasets.

get_file_for_dataset <- function(variable, dataset) {
  check_available_variable(variable, dataset)
  return(files_by_dataset[files_by_dataset$variable %in% variable &
    files_by_dataset$dataset == dataset, ])
}
