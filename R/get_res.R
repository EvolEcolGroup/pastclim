#' Get resolution of a given dataset
#'
#' Get the resolution of a given dataset.
#'
#' @param dataset string defining dataset to be downloaded (a list of possible
#' values can be obtained with [list_available_datasets()]). If set to
#' "custom", then a single nc file is used from "path_to_nc"
#' @param path_to_nc the path to the custom nc file containing the palaeoclimate
#' reconstructions. All the variables of interest need to be included in
#' this file.
#' @returns a vector of resolution in the x and y axes
#'
#' @export

get_resolution <- function(dataset, path_to_nc = NULL) {
  check_dataset_path(dataset = dataset, path_to_nc = path_to_nc)

  if (is.null(path_to_nc)) {
    possible_files <- dataset_list_included$file_name[dataset_list_included$dataset == dataset]
    possible_files <- possible_files[possible_files %in% list.files(get_data_path())]
    # check that at least one file is available
    if (length(possible_files) == 0) {
      stop("no variable has been downloaded for this dataset yet")
    }
    path_to_nc <- file.path(get_data_path(), possible_files[1])
  }

  climate_nc <- terra::rast(path_to_nc, subds = 1)
  return(terra::res(climate_nc))
}
