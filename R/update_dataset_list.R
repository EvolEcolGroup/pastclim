#' Update the dataset list
#'
#' If a newer dataset list (which includes all the information about the files
#' storing the data for pastclim), download it and start using it as
#' 'dataset_list_included.csv' in 
#' `tools::R_user_dir("pastclim","config")`. If the latter is present, the last
#' column, named 'dataset_list_v', provides the version of this table, and the
#' most advanced table is used.
#'
#' @param on_cran boolean to make this function run on ci tests using tempdir
#' @returns the dataset list
#' @keywords internal

update_dataset_list <- function(on_cran=FALSE) {
  warning("this function is incomplete and non-functional yet")
  if (!on_cran){
    config_dir <- tools::R_user_dir("pastclim", "config")
  } else {
    config_dir <- tempdir()
  }
  # this is incomplete
  
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
    if (utils::compareVersion(table_in_config$dataset_list_v[1], 
                          dataset_list_included$dataset_list_v[1])==1){
      # need to update
      return(table_in_config)
    }
  }
  return(dataset_list_included)
}
