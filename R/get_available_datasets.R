#' Get the available datasets.
#'
#' List the available datasets
#'
#' @export

get_available_datasets <- function() {
  return(unique(files_by_dataset$dataset))
}


#' Check if dataset is available.
#'
#' Internal getter function
#'
#' @param dataset string defining dataset
#'
#' @keywords internal


check_available_dataset <- function(dataset) {
  if (!dataset %in% get_available_datasets()) {
    stop("'dataset' must be one of ", paste(get_available_datasets(),
                                            collapse = ", "))
  } else {
    return(TRUE)
  }
}
