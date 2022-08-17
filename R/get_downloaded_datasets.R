#' Get the variables downloaded for each dataset.
#'
#' List the downloaded variable for each dataset.
#'
#' @param path_to_nc path to the netcdf datasets
#'
#' @export

get_downloaded_datasets <- function(path_to_nc = NULL) {
  if (is.null(path_to_nc)) {
    path_to_nc <- get_data_path()
  }
  all_nc_files <- list.files(path_to_nc)
  files_subset <- files_by_dataset[files_by_dataset$file_name %in%
    all_nc_files, ]
  downloaded_vars <- list()
  for (dataset in unique(files_subset$dataset)) {
    downloaded_vars[[dataset]] <- files_subset[
      files_subset$dataset == dataset,
      "variable"
    ]
  }
  downloaded_vars
}

#' Internal functions to check whether we have downloaded a given variable
#' for a dataset
#'
#' @param variable a vector of names of the variables of interest
#' @param dataset dataset of interest
#' @param path_to_nc path to the netcdf datasets
#'
#' @keywords internal

check_var_downloaded <- function(variable, dataset, path_to_nc = NULL) {
  # first check the variable exists for that dataset
  check_available_variable(variable, dataset)

  # test if we have downloaded already
  if (!all(variable %in% get_downloaded_datasets(path_to_nc = path_to_nc)
  [[dataset]])) {
    missing_vars <- variable[!variable %in% get_downloaded_datasets(
      path_to_nc =
        path_to_nc
    )[[dataset]]]
    stop(
      "variable (", paste(missing_vars, collapse = ", "),
      ") not yet downloaded, use `download_dataset()`"
    )
  }
  return(TRUE)
}
