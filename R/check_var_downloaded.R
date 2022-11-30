#' Internal functions to check whether we have downloaded a given variable
#' for a dataset
#'
#' @param variable a vector of names of the variables of interest
#' @param dataset dataset of interest
#' @returns TRUE if the variable has been downloaded.
#'
#' @keywords internal

check_var_downloaded <- function(variable, dataset) {
  # first check the variable exists for that dataset
  check_available_variable(variable, dataset)

  # test if we have downloaded already
  if (!all(variable %in% get_downloaded_datasets()
  [[dataset]])) {
    missing_vars <- variable[!variable %in%
      get_downloaded_datasets()[[dataset]]]
    stop(
      "variable (", paste(missing_vars, collapse = ", "),
      ") not yet downloaded, use `download_dataset()`"
    )
  }
  return(TRUE)
}
