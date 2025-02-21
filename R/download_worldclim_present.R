#' Download a WorldClim modern observations.
#'
#' This function downloads annual and monthly variables from the WorldClim 2.1
#' dataset.
#' @param dataset the name of the dataset
#' @param bio_var the variable name
#' @param filename the file name (full path) of the file to be saved
#' @returns TRUE if the requested WorldClim variable was downloaded successfully
#'
#' @keywords internal

download_worldclim_present <- function(dataset, bio_var, filename) {
  # extract the version from the filename
  version <- gsub("^.*_v([0-9]+\\.[0-9]+\\.[0-9]+)\\..*$", "\\1", filename)
  # compose download paths
  download_url <- filenames_worldclim_present(
    dataset = dataset,
    bio_var = bio_var
  )
  time_vector <- 1985

  # create band vectors
  # function to grab the number from the raster layer
  if (grepl("bio", bio_var)) {
    band_vector <- paste0("bio", sprintf("%02d", 1:19))
  } else if (grepl("altitude", bio_var)) {
    band_vector <- "altitude"
  } else {
    var_prefix <- substr(bio_var, 1, nchar(bio_var) - 2)
    band_vector <- paste0(var_prefix, sprintf("%02d", 1:12))
  }
  # TODO we are missing the special case for altitude
  # elev.zip

  # if we do not have a directory, create one
  worldclim_dir <- file.path(get_data_path(), "worldclim_2.1")
  if (!dir.exists(worldclim_dir)) {
    dir.create(worldclim_dir)
  }

  # and now download the zip file (so the url is actually a local file)
  worldclim_url <- file.path(worldclim_dir, basename(download_url))
  curl::curl_download(download_url,
    destfile = worldclim_url,
    quiet = FALSE
  )
  # for all variables (except altitude) we match file names to bands based on
  # the id at the end of the file name
  files_in_zip <- utils::unzip(worldclim_url, list = TRUE)$Name
  # TODO remove any readme from this list
  files_in_zip <- files_in_zip[!files_in_zip %in% c("readme.txt")]
  if (!grepl("altitude", bio_var)) {
    files_in_zip_id <- as.numeric(gsub(
      "^.*_([0-9]+)\\.tif$", "\\1",
      files_in_zip
    ))
    if (!all(seq_len(length(band_vector) %in% files_in_zip_id))) {
      stop("some files are missing from the downloaded archive")
    }
  } else { # for altitude
    if (length(files_in_zip) != 1) {
      stop("we expected only one file in the elevation zip file")
    }
  }

  # create a vrt for each variable
  for (i in seq_len(length(band_vector))) {
    # build the vsizip paths
    if (!grepl("altitude", bio_var)) {
      worldclim_vsizip <- paste0("/vsizip/", file.path(
        worldclim_url,
        files_in_zip[files_in_zip_id == i]
      ))
    } else { # special case for altitude
      worldclim_vsizip <- paste0("/vsizip/", file.path(
        worldclim_url,
        files_in_zip[1]
      ))
    }
    vrt_filename <- paste0(dataset, "_", band_vector[i], "_v", version, ".vrt")
    # nolint start
    # create the vrt file
    # vrt_path <- terra::vrt(x = worldclim_vsizip,
    #                        filename = file.path(get_data_path(),vrt_filename),
    #                        options="-separate", overwrite=TRUE, return_filename=TRUE)
    # nolint end
    vrt_path <- file.path(get_data_path(), vrt_filename)
    if (file.exists(vrt_path)) {
      file.remove(vrt_path)
    }
    sf::gdal_utils(
      util = "buildvrt",
      source = worldclim_vsizip,
      destination = vrt_path,
      options = c("-separate")
    )
    # edit the vrt metadata
    edit_res <- vrt_set_meta(
      vrt_path = vrt_path,
      description = band_vector[i],
      time_vector = time_vector,
      time_bp = FALSE
    )
    if (!edit_res) {
      file.remove(vrt_path)
      stop(
        "something went wrong setting up this dataset (", vrt_path,
        " could not be created correctly)",
        "\n the dataset will need downloading again"
      )
    }
  }
  if (!file.exists(filename)) {
    stop(
      "something went wrong setting up this dataset (", filename,
      " is missing)",
      "\n the dataset will need downloading again"
    )
  }
  return(TRUE)
}
