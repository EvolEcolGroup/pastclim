#' Get the available datasets.
#'
#' List the available datasets
#'
#' @export

get_available_datasets <- function() {
  return(unique(as.character(files_by_dataset$dataset)))
}
