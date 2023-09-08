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
#' @returns TRUE if the dataset was updated
#' @export

update_dataset_list <- function(on_cran=FALSE) {
  curl::curl_download("https://raw.githubusercontent.com/EvolEcolGroup/pastclim/dataset_list/dataset_list_included.csv",
                      destfile = file.path(tempdir(), "dataset_list_included.csv"),
                      quiet = FALSE)
  new_table_github <- utils::read.csv(file.path(tempdir(), "dataset_list_included.csv"))
  # if the github version is more recent, copy it into config
  if (utils::compareVersion(new_table_github$dataset_list_v[1], 
                            getOption("pastclim.dataset_list")$dataset_list_v[1])==1){
    # set the config directory (we use the tempdir if we are on CRAN)
    if (!on_cran){
      config_dir <- tools::R_user_dir("pastclim", "config")
    } else {
      config_dir <- tempdir()
    }
    file.copy(utils::read.csv(file.path(tempdir(), "dataset_list_included.csv")),
              to= file.path(config_dir,"dataset_list_included.csv"))
    load_dataset_list()
    message("The dataset list was updated.")
    return(TRUE)
  } else {
    message("The dataset list currently installed is already the latest version.")
    return(FALSE)
  }
  
}
