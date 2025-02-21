#' Download the worldclim future time series.
#'
#' This function downloads annual and monthly variables from the WorldClim v2.1
#' dataset for future projections.
#'
#' Note: the data come as tiffs each containing all bio (or prec/temp) variables
#' for a given time step. From these, we generate a vrt per variable. So, since
#' we download the full set for a give variable type, we create all the vrts for
#' that variable type (e.g. all the bio). We use the filename to get the version
#' name, and then at the end to check that we did generate it correctly given
#' our programmatic way of creating the names of all vrt files.
#' @param dataset the name of the dataset
#' @param bio_var the variable name
#' @param filename ()
#' @returns TRUE if the requested worldclim variable was downloaded successfully
#'
#' @keywords internal

download_worldclim_future <- function(dataset, bio_var, filename = NULL) {
  # extract the version from the filename
  version <- gsub("^.*_v([0-9]+\\.[0-9]+\\.[0-9]+)\\..*$", "\\1", filename)
  # compose download paths
  download_url <- filenames_worldclim_future(
    dataset = dataset,
    bio_var = bio_var
  )
  time_vector <- c(2030, 2050, 2070, 2090)

  # create band vectors
  # function to grab the number from the raster layer
  if (grepl("bio", bio_var)) {
    band_vector <- paste0("bio", sprintf("%02d", 1:19))
  } else {
    var_prefix <- substr(bio_var, nchar(bio_var) - 1, nchar(bio_var))
    band_vector <- paste0(var_prefix, sprintf("%02d", 1:12))
  }

  # if we do not have a directory, create one
  worldclim_dir <- file.path(get_data_path(), "worldclim_2.1")
  if (!dir.exists(worldclim_dir)) {
    dir.create(worldclim_dir)
  }

  # and now download the files (so the url is actually a local file)
  worldclim_url <- file.path(worldclim_dir, basename(download_url))
  download_res <- curl::multi_download(download_url,
    destfiles = worldclim_url
  )
  if (any(!download_res$success)) {
    stop("something went wrong downloading the data; try again")
  }


  # create a vrt for each variable
  for (i in seq_len(length(band_vector))) {
    vrt_path <- file.path(get_data_path(), paste0(
      dataset, "_",
      band_vector[i], "_v",
      version, ".vrt"
    ))
    # nolint start
    # create the vrt file
    # we capture warnings from the vrt to make sure that all is well
    # withCallingHandlers({
    #   vrt_path <- terra::vrt(x = worldclim_url,
    #                          filename = vrt_path,
    #                          options=c("-b", i,"-separate"), overwrite=TRUE, return_filename=TRUE)
    # }, warning = function(w) {
    #   if (!grepl("Only the first one",w)){
    #     file.remove(vrt_path)
    #     stop("vrt creation failed with ", w,"\n try to redownload this dataset")
    #   }
    #   invokeRestart("muffleWarning")
    # })
    # nolint end

    if (file.exists(vrt_path)) {
      file.remove(vrt_path)
    }
    withCallingHandlers(
      {
        sf::gdal_utils(
          util = "buildvrt",
          source = worldclim_url,
          destination = vrt_path,
          options = c("-b", i, "-separate")
        )
      },
      warning = function(w) {
        if (!grepl("Only the first one", w)) {
          file.remove(vrt_path)
          stop(
            "vrt creation failed with ", w,
            "\n try to redownload this dataset"
          )
        }
        invokeRestart("muffleWarning")
      }
    )


    ######################################################################
    # in gdal <3.8, the -b is ignored, and only the first band is used
    # so, we edit the SourceBand for each band
    x <- xml2::read_xml(vrt_path)
    band_nodes <- xml2::xml_find_all(x, ".//SourceBand")
    xml2::xml_text(band_nodes) <- as.character(i)
    xml2::write_xml(x, vrt_path)
    ## end of workaround
    ######################################################################

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
        "something went wrong setting up this dataset",
        "\n the dataset will need downloading again"
      )
    }
  }
  if (!file.exists(vrt_path)) {
    stop(
      "something went wrong setting up this dataset",
      "\n the dataset will need downloading again"
    )
  }
  return(TRUE)
}
