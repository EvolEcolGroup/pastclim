#' Get the variables downloaded for each dataset.
#'
#' List the downloaded variable for each dataset.
#'
#' @param data_path leave it to NULL to use the default datapath
#'
#' @export

get_downloaded_datasets <- function(data_path=NULL) {
  if (is.null(data_path)){
    data_path <- get_data_path()
  }
  all_nc_files <- list.files(data_path)
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
#'
#' @keywords internal

check_var_downloaded <- function(variable, dataset) {
  # first check the variable exists for that dataset
  check_available_variable(variable, dataset)

  # test if we have downloaded already
  if (!all(variable %in% get_downloaded_datasets()
  [[dataset]])) {
    missing_vars <- variable[!variable %in% get_downloaded_datasets()[[dataset]]]
    stop(
      "variable (", paste(missing_vars, collapse = ", "),
      ") not yet downloaded, use `download_dataset()`"
    )
  }
  return(TRUE)
}
