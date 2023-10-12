#' Download palaeoclimate reconstructions.
#'
#' This function downloads palaeoclimate reconstructions. Files will be stored
#' in the data path of `pastclim`, which can be inspected with
#' [get_data_path()] and changed with [set_data_path()]
#'
#' @param dataset string defining dataset to be downloaded (a list of possible
#' values can be obtained with [list_available_datasets()]). This function
#' will not work on custom datasets.
#' @param bio_variables one or more variable names to be downloaded. If left
#' to NULL, all variables available for this dataset will be downloaded (the
#' parameters `annual` and `monthly`, see below, define which types)
#' @param annual boolean to download annual variables
#' @param monthly boolean to download monthly variables
#' @returns TRUE if the dataset(s) was downloaded correctly.
#'
#' @export

download_dataset <- function(dataset, bio_variables = NULL, annual = TRUE,
                             monthly = FALSE) {
  # check the dataset exists
  available_datasets <- unique(getOption("pastclim.dataset_list")$dataset)
  if (!dataset %in% available_datasets) {
    cat("'dataset' must be one of ")
    get_available_datasets()
    stop(
      "Invalid 'dataset', for a comprehensive list of all possible combinations, use `list_available_datasets()`"
    )
  }

  # check that the variable is available for this dataset
  available_variables <-
    getOption("pastclim.dataset_list")$variable[getOption("pastclim.dataset_list")$dataset == dataset]
  # if variable is null, donwload all possible variables
  if (is.null(bio_variables)) {
    bio_variables <- getOption("pastclim.dataset_list")[getOption("pastclim.dataset_list")$dataset == dataset, ]
    if (!monthly) {
      bio_variables <- bio_variables[bio_variables$monthly == FALSE, ]
    }
    if (!annual) {
      bio_variables <- bio_variables[bio_variables$monthly != FALSE, ]
    }
    bio_variables <- bio_variables$variable
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

  # if (dataset %in% c("Krapp2021", "Beyer2020", "Example")){
  #   # add biome to list of variables (we need it to generate the landmask)
  #   if (!"biome" %in% bio_variables) {
  #     bio_variables <- c(bio_variables, "biome")
  #   }
  # }

  # add biome to list of variables (we need it to generate the landmask)
  if (all((!"biome" %in% bio_variables), ("biome" %in% available_variables))) {
    bio_variables <- c(bio_variables, "biome")
  }


  # special case for the example dataset
  # as we have a copy on the package
  if (dataset == "Example") {
    copy_example_data()
  } else {
    # download the file for each variable
    for (this_var in bio_variables) {
      file_details <- get_file_for_dataset(this_var, dataset)
      # only download the file if it is needed
      if (!file.exists(file.path(get_data_path(), file_details$file_name))) {
        # if it is a standard file to download
        if (file_details$download_path != "") {
          curl::curl_download(file_details$download_path,
            destfile = file.path(get_data_path(), file_details$file_name),
            quiet = FALSE
          )
        } else { # we use a custom download function if the files have to be converted locally
          eval(parse(text = file_details$download_function))(dataset = dataset,
            bio_var = this_var,
            filename = file.path(get_data_path(), file_details$file_name))
        }
      }
    }
  }
  return(TRUE)
}
