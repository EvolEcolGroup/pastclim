#' Check if dataset is available.
#'
#' Internal getter function
#'
#' @param dataset string defining dataset
#' @param include_custom boolean whether a 'custom' dataset is allowed
#' @returns TRUE if the dataset is available
#' @keywords internal


check_available_dataset <- function(dataset, include_custom = FALSE) {
  available_datasets <- get_available_datasets()
  if (include_custom) {
    available_datasets <- c(available_datasets, "custom")
  }
  if (!dataset %in% available_datasets) {
    stop("'dataset' must be one of ", paste(available_datasets,
      collapse = ", "
    ))
  } else {
    return(TRUE)
  }
}
