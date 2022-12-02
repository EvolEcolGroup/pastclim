#' Get the available datasets.
#'
#' List the datasets available in pastclim. Most functions can also be
#' used on custom datasets by setting `dataset="custom"`
#'
#' @returns a character vector of the available datasets
#' @export

get_available_datasets <- function() {
  return(unique(as.character(getOption("pastclim.dataset_list")$dataset)))
}
