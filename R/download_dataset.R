#' Download paeloclimate reconstructions.
#'
#' This function downloads paleoclimate reconstructions
#'
#' @param dataset string defining dataset to be downloaded (currently only
#' "Beyer" is available)
#' @param bio_variables one or more variable names to be downloaded. If left
#' to NULL, all variables available for this dataset will be downloaded
#' @param path_to_nc directory where the files will be saved. If not set, the
#' data will be downloaded into the storage package pastclimData; an error
#' will be returned if this package is not installed.
#'
#' @export

download_dataset <- function(dataset, bio_variables = NULL, path_to_nc = NULL) {
  if (is.null(path_to_nc)) {
    path_to_nc <- system.file("extdata", package = "pastclimData")
    if (path_to_nc == "") {
      stop("the parameter path was not set, and the package pastclimData",
      "is not installed.")
    }
  }

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
    if (!file.exists(file.path(path_to_nc, file_details$file_name))) {
      curl::curl_download(file_details$download_path,
        destfile = file.path(path_to_nc, file_details$file_name),
        quiet = FALSE
      )
    }
  }
}
