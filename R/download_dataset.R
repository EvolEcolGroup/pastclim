#' Download palaeoclimatereconstructions.
#'
#' This function downloads palaeoclimate reconstructions. Files will be stored
#' in the data path of `pastclim`, which can be inspected with
#' \code{get_data_path} and changed with \code{set_data_path}
#'
#' @param dataset string defining dataset to be downloaded (a list of possible
#' values can be obtained with \code{get_available_datasets}). This function
#' will not work on custom datasets.
#' @param bio_variables one or more variable names to be downloaded. If left
#' to NULL, all variables available for this dataset will be downloaded
#' @returns TRUE if the dataset(s) was downloaded correctly.
#'
#' @export

download_dataset <- function(dataset, bio_variables = NULL) {

  # check the dataset exists
  available_datasets <- unique(files_by_dataset$dataset)
  if (!dataset %in% available_datasets) {
    stop(
      "'dataset' must be one of ",
      paste(available_datasets, collapse = ", ")
    )
  }

  # check that the variable is available for this dataset
  available_variables <-
    files_by_dataset$variable[files_by_dataset$dataset == dataset]
  # if variable is null, donwload all possible variables
  if (is.null(bio_variables)) {
    bio_variables <- available_variables
  }

  if (!all(bio_variables %in% available_variables)) {
    stop(
      paste0(
        bio_variables[!bio_variables %in% available_datasets],
        " not available for ",
        dataset,
        "; available variables are ",
        paste(available_variables, collapse = ", ")
      )
    )
  }

  # add biome to list of variables (we need it for generate landmask)
  if (!"biome" %in% bio_variables) {
    bio_variables <- c(bio_variables, "biome")
  }


  # download the dataset
  for (this_var in bio_variables) {
    file_details <- get_file_for_dataset(this_var, dataset)
    # only download the file if it is needed
    if (!file.exists(file.path(get_data_path(), file_details$file_name))) {
      curl::curl_download(file_details$download_path,
        destfile = file.path(get_data_path(), file_details$file_name),
        quiet = FALSE
      )
    }
  }
  return(TRUE)
}
