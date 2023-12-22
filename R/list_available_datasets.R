#' List all the available datasets.
#'
#' List the datasets available in pastclim. The list is comprehensive,
#' and includes all combinations of models and future scenarios for WorldClim.
#' For a more user-friendly list, use [get_available_datasets()]. Most functions can also be
#' used on custom datasets by setting `dataset="custom"`
#'
#' @returns a character vector of the available datasets
#' @export

list_available_datasets <- function() {
  return(unique(as.character(getOption("pastclim.dataset_list")$dataset)))
}
