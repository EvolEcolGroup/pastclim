#' Get the variables downloaded for each dataset.
#'
#' List the downloaded variable for each dataset.
#'
#' @param data_path leave it to NULL to use the default datapath
#' @returns a list of variable names per dataset.
#'
#' @export

get_downloaded_datasets <- function(data_path = NULL) {
  if (is.null(data_path)) {
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