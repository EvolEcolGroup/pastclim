#' Get time steps for a given dataset
#'
#' Get the time steps (in time_bp or time_ce) available in a given dataset.
#'
#' @param dataset string defining dataset to be downloaded (a list of possible
#' values can be obtained with [list_available_datasets()]). If set to
#' "custom", then a single nc file is used from "path_to_nc"
#' @param path_to_nc the path to the custom nc file containing the palaeoclimate
#' reconstructions. All the variables of interest need to be included in
#' this file.
#' @returns a vector of time steps (in time_bp, or time_ce)
#'
#' @export

get_time_bp_steps <- function(dataset, path_to_nc = NULL) {
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

  # if the last 4 chars are vrt, this is a virtual raster
  if (substr(path_to_nc,nchar(path_to_nc)-2,nchar(path_to_nc))=="vrt"){
    return(vrt_get_meta(path_to_nc)$time_bp)
  } else {
    climate_nc <- terra::rast(path_to_nc, subds = 1)
    return(time_bp(climate_nc))
  }
  
}

#' @rdname get_time_bp_steps
#' @export
get_time_ce_steps <- function(dataset, path_to_nc = NULL) {
  get_time_bp_steps(
    dataset = dataset,
    path_to_nc = path_to_nc
  ) + 1950
}


#' @rdname get_time_bp_steps
#' @export
get_time_steps <- function(dataset, path_to_nc = NULL) {
  warning("this function is deprecated, use `get_time_bp_steps()` instead")
  get_time_bp_steps(
    dataset = dataset,
    path_to_nc = path_to_nc
  )
}
