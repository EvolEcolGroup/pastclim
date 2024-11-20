#' Download the CHELSA modern and future observations.
#'
#' This function downloads annual and monthly variables from the CHELSA v2.1 dataset.
#' @param dataset the name of the dataset
#' @param bio_var the variable name
#' @param filename the filename as stored in the `data_path` of `pastclim` (includes the full data path)
#' @returns TRUE if the requested CHELSA variable was downloaded successfully
#' 
#' @keywords internal


# download_chelsa(dataset = "CHELSA_2.1_0.5m_vsi", bio_var = "bio06",
# filename = file.path(get_data_path(), "CHELSA_2.1_0.5m_bio06_vsi.vrt"))
# download_chelsa(dataset = "CHELSA_2.1_GFDL-ESM4_ssp126_0.5m_vsi", bio_var = "bio06",
# filename = file.path(get_data_path(), "CHELSA_2.1_GFDL-ESM4_ssp126_0.5m_bio06_vsi.vrt"))
# download_chelsa(dataset = "CHELSA_2.1_0.5m", bio_var = "bio06",
# filename = file.path(get_data_path(), "CHELSA_2.1_0.5m_bio06.vrt"))

download_chelsa <- function(dataset, bio_var, filename) {
  
  # if the last 3 letters are vsi, this is a virtual dataset
  if (substr(dataset,nchar(dataset)-2,nchar(dataset))=="vsi"){
    virtual <- TRUE
  } else {
    virtual <- FALSE
  }
  
  # compose download paths
  # the lenght of the dataset name determines whether it's present or future
  if (length(unlist(strsplit(dataset, "_")))<5){
    download_url <- filenames_chelsa_present(dataset=dataset,
                                             bio_var = bio_var)
    time_vector <- 1990
  } else {
    download_url <- filenames_chelsa_future(dataset=dataset,
                                             bio_var = bio_var)
    time_vector <- c(2025, 2055, 2075)
  }
  
  
  if (virtual){
    if (!all(unlist(lapply(download_url,url_is_valid)))){
      stop("invalid URL for variable ", bio_var,"; either the server can not be reached at the moment, or the path has changed")
    }
    # add prefix for vsi dataset
    chelsa_url <- paste0("/vsicurl/", download_url) # urls of target files
  } else { # download the files
    # if we do not have a directory, create one
    chelsa_dir <- file.path(get_data_path(),"chelsa_2.1")
    if(!dir.exists(chelsa_dir)){
      dir.create(chelsa_dir)
    }
    # and now download the files (so the url is actually a local file)
    chelsa_url <- file.path(chelsa_dir,basename(download_url))
    download_res <- curl::multi_download(download_url,
                        destfiles = chelsa_url, resume = TRUE
    )
    if(any(!download_res$success)){
      stop("something went wrong downloading the data; try again")
    }
  }
  # create the vrt file
  # TODO we should capture a warning here and abort
  # vrt_path <- terra::vrt(x = chelsa_url,
  #                        filename = filename,
  #                        options="-separate", 
  #                        overwrite=TRUE, return_filename=TRUE)
  #############################################
  # workaround
  sf::gdal_utils(
    util = "buildvrt",
    source = chelsa_url,
    destination = filename,
    options = c("-separate","-overwrite")
  )

  vrt_path <- filename
  #############################
  
  # edit the vrt metadata
  edit_res <- vrt_set_meta(vrt_path = vrt_path, description = bio_var,
                           time_vector = time_vector, time_bp=FALSE)
  if (!edit_res){
    file.remove(vrt_path)
    stop("something went wrong setting up this dataset", "\n the dataset will need downloading again")
  }
  return(TRUE)
}





