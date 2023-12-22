#' Get the available datasets.
#'
#' List the datasets available in pastclim, which can be passed to functions
#' in `pastclim` as values for the parameter `dataset`. Most functions can also be
#' used on custom datasets by setting `dataset="custom"`
#'
#' This function provides a user-friendly list, summarising the many datasets
#' available from WorldClim. A comprehensive list of all available datasets
#' can be obtained with [list_available_datasets].
#'
#' @returns a character vector of the available datasets
#' @export

get_available_datasets <- function() {
  all_datasets <- unique(as.character(getOption("pastclim.dataset_list")$dataset))
  all_datasets <- all_datasets[!grepl("WorldClim_2.1", all_datasets)]
  print(all_datasets)
  message('for present day reconstructions, use "WorldClim_2.1_RESm", where RES is an available resolution.')
  message('for future predictions, use "WorldClim_2.1_GCM_SSP_RESm", where GCM is the GCM model, SSP is the Shared Societ-economic Pathways scenario.')
  message('use help("WorldClim_2.1") for a list of available options')
}
