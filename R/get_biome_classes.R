#' Get the biome classes for a dataset.
#'
#' Get a full list of biomes and how their id as coded in the biome variable
#' for a given dataset.
#'
#' @param dataset string defining dataset to be downloaded (currently only
#' "Beyer2020", "Krapp2021" or "Example" are available)
#' @param path_to_nc the path to the directory containing the downloaded
#' reconstructions. Leave it unset if you are using the companion
#' `pastclimData` to store datasets.
#'
#' @export

get_biome_classes <- function(dataset, path_to_nc = NULL) {
  if (is.null(path_to_nc)) {
    path_to_nc <- get_pastclimdata_path()
  }
  # test that we ahve the biome variable
  check_var_downloaded("biome", dataset, path_to_nc = path_to_nc)
  # get file name for biome
  this_file <- get_file_for_dataset("biome", dataset)$file_name
  this_file <- file.path(path_to_nc, this_file)
  nc_in <- ncdf4::nc_open(this_file)
  biome_attributes <- ncdf4::ncatt_get(nc_in, "biome")
  # format the table
  if (dataset == "Beyer2020" | dataset == "Example") {
    indeces_biomes <- which(substr(names(biome_attributes), 1, 5) == "biome")
    biome_categories <- data.frame(
      id = 0:(length(indeces_biomes) - 1),
      category = unlist(biome_attributes[indeces_biomes])
    )
    row.names(biome_categories) <- NULL
  } else if (dataset == "Krapp2021") {
    biomes_string <- trimws(unlist(strsplit(biome_attributes$biomes,
      split =
        ";"
    )))
    biomes_string <- biomes_string[-length(biomes_string)]
    biomes_string <- substr(biomes_string, 4, nchar(biomes_string))
    biome_categories <- data.frame(
      id = seq_len(length(biomes_string)),
      category = biomes_string
    )
  }
  return(biome_categories)
}
