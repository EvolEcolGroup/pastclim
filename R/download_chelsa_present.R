#' Download the CHELSA modern observations.
#'
#' This function downloads annual and monthly variables from the CHELSA v2.1 dataset.
#' @param dataset the name of the dataset
#' @param bio_var the variable name
#' @param filename the filename as stored in the `data_path` of `pastclim` (includes the full data path)
#' @returns TRUE if the requested CHELSA variable was downloaded successfully
#' 
#' @keywords internal


# download_chelsa_present(dataset = "CHELSA_2.1_0.5m_vsi", bio_var = "bio06",
# filename = "CHELSA_2.1_0.5m_bio06_vsi.vrt")

download_chelsa_present <- function(dataset, bio_var, filename) {
  
  # if the last 3 letters are vsi, this is a virtual dataset
  if (substr(dataset,nchar(dataset)-2,nchar(dataset))=="vsi"){
    virtual <- TRUE
  } else {
    virtual <- FALSE
  }
  # compose download paths
  download_url <- filenames_chelsa_present(dataset=dataset,
                                           bio_var = bio_var)
  
  if (virtual){
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
    curl::curl_download(download_url,
                        destfile = chelsa_url,
                        quiet = FALSE
    )
  }
  # create the vrt file
  # TODO we should capture a warning here and abort
  vrt_path <- terra::vrt(x = chelsa_url,
                         filename = filename,
                         #options="-separate", 
                         overwrite=TRUE, return_filename=TRUE)

  # edit the vrt metadata
  return(vrt_set_meta(vrt_path = vrt_path, description = bio_var,
                        time_vector = 40))
}





