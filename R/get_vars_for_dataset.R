#' Get a list of variables for a given dataset.
#'
#' This function lists the variables available for a given dataset. Note that
#' the spelling and use of capitals in names might differ from the original
#' publications, as `pastclim` harmonises the names of variables across
#' different reconstructions.
#'
#' @param dataset string defining dataset to for which variables are given.
#' It can take the value "Beyer2020", "Krapp2021" or "Example"
#'
#' @export

get_vars_for_dataset <- function(dataset) {
  check_available_dataset(dataset)
  return(files_by_dataset$variable[files_by_dataset$dataset == dataset])
}

#' Check if var is available for this dataset.
#'
#' Internal getter function
#'
#' @param variable a vector of names of the variables of interest
#' @param dataset dataset of interest
#'
#' @keywords internal

check_available_variable <- function(variable, dataset) {
  # check that the variable is available for this dataset
  if (!all(variable %in% get_vars_for_dataset(dataset))) {
    missing_variables <- variable[!variable %in% get_vars_for_dataset(dataset)]
    stop(
      paste(missing_variables, collapse = ", "), " not available for ", dataset,
      "; available variables are ",
      paste(get_vars_for_dataset(dataset), collapse = ", ")
    )
  } else {
    return(TRUE)
  }
}

#' Get a the varname for this variable
#'
#' Internal function to get the varname for this variable
#'
#' @param variable string defining the variable name
#' @param dataset string defining dataset to be downloaded
#'

get_varname <- function(variable, dataset) {
  return(files_by_dataset$ncvar[files_by_dataset$variable == variable &
                                  files_by_dataset$dataset == dataset])
}
