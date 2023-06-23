#' Get the available datasets.
#'
#' List the datasets available in pastclim. Most functions can also be
#' used on custom datasets by setting `dataset="custom"`
#'
#' @returns a character vector of the available datasets
#' @export

get_available_datasets <- function() {
  all_datasets <- unique(as.character(getOption("pastclim.dataset_list")$dataset))
  all_datasets <- all_datasets[!grepl("WorldClim_2.1",all_datasets)]
  all_datasets <- c(all_datasets,"WorldClim_2.1_RESm", "WorldClim_2.1_GCM_SSP_RESm")
  print(all_datasets)
  message('for "WorldClim_2.1_RESm", RES is an available resolution.')
  message('for "WorldClim_2.1_GCM_SSP_RESm", GCM is the GCM model, SSP is the CO2 scenario.')
  message('use help("WorldClim_2.1") for a list of available options')
}
