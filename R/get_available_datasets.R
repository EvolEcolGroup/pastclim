#' Get the available datasets.
#'
#' List the datasets available in pastclim. Most functions can also be
#' used on custom datasets by setting `dataset="custom"`
#'
#' @export

get_available_datasets <- function() {
  return(unique(as.character(files_by_dataset$dataset)))
}
