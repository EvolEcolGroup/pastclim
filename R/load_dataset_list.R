#' Load the dataset list
#'
#' This function returns a dataframe with the details for each variable
#' available in every dataset. It defaults to the copy stored within the
#' package, but it checks in case there is an updated version stored as
#' 'dataset_list_included.csv' in
#' `tools::R_user_dir("pastclim","config")`. If the latter is present, the last
#' column, named 'dataset_list_v', provides the version of this table, and the
#' most advanced table is used.
#'
#' @param on_cran boolean to make this function run on ci tests using tempdir
#' @returns the dataset list
#' @keywords internal

load_dataset_list <- function(on_cran = FALSE) {
  if (!on_cran) {
    config_dir <- tools::R_user_dir("pastclim", "config")
  } else {
    config_dir <- tempdir()
  }
  # if there is a file in the config directory, check whether it is more recent
  # than the default table in the package
  if (file.exists(file.path(
    config_dir,
    "dataset_list_included.csv"
  ))) {
    table_in_config <- utils::read.csv(file.path(
      config_dir,
      "dataset_list_included.csv"
    ))
    table_in_config$dataset <- as.factor(table_in_config$dataset)
    # we should check that the new table includes all the columns in the original file
    if (utils::compareVersion(
      table_in_config$dataset_list_v[1],
      dataset_list_included$dataset_list_v[1]
    ) == 1) {
      # need to update
      return(table_in_config)
    }
  }
  return(dataset_list_included)
}
