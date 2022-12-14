#' Check dataset and path_to_nc params
#'
#' Check that the dataset and path_to_nc parameters are valid. Specifically,
#' if `path_to_nc` should only be set if `dataset` is `custom` (and conversely,
#' `custom` datasets require a `path_to_nc`).
#'
#' @param dataset string defining the dataset to use. If set to "custom",
#' then a single nc file is used from "path_to_nc".
#' @param path_to_nc the path to the custom nc file containing the palaeoclimate
#' reconstructions. All the variables of interest need to be included in
#' this file.
#' @returns TRUE if both dataset and path are valid.
#' @keywords internal

check_dataset_path <- function(dataset, path_to_nc) {
  check_available_dataset(dataset = dataset, include_custom = TRUE)

  if (all(dataset == "custom", is.null(path_to_nc))) {
    stop("you need to set path_to_nc if dataset='custom'")
  }
  # check that we are only given path_to_nc if we use a custom dataset
  if (!is.null(path_to_nc)) {
    if (dataset != "custom") {
      stop("path_to_nc can only be set if dataset=='custom'")
    }
    if (!file.exists(path_to_nc)) {
      stop("path_to_nc does not point to a file")
    }
  }
  return(TRUE)
}
