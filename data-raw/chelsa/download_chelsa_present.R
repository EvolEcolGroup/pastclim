#' Download the CHELSA modern observations.
#'
#' This function downloads annual and monthly variables from the CHELSA v2.1 dataset.
#' @param dataset the name of the dataset
#' @param bio_var the variable name
#' @param filename the filename as stored in the `data_path` of `pastclim`
#' @returns TRUE if the requested CHELSA variable was downloaded successfully
#' @examples
#' download_chelsa_present(dataset = "CHELSA_2.1_vsi", bio_var = "bio_06",
#' filename = "CHELSA_2.1_bio_vsi.vrt")
#' 
#' @keywords internal

download_chelsa_present <- function(dataset, bio_var, filename) {
  
  stop("this function does not work as the vrt are not valid (multivar vrt, non-functional",
       " need a vrt per variables")
  
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
    stop("not implemented yet!")
    # if we do not have a directory, create one
    chelsa_dir <- file.path(get_data_path(),"chelsa_2.1")
    if(!dir.exists(chelsa_dir)){
      dir.create(chelsa_dir)
    }
    # and now download the files
    chelsa_url <- file.path(chelsa_dir,basename(download_url))
    curl::curl_download(download_url,
                        destfile = chelsa_url,
                        quiet = FALSE
    )
  }
  # create the vrt file
  vrt_path <- terra::vrt(x = chelsa_url,
                         filename = filename,
                         options="-separate", overwrite=TRUE, return_filename=TRUE)
  # create band description and time axis
  time_vector <- rep(40,length(chelsa_url))
  if ("bio"== substr(bio_var,1,3)){
    band_vector <- paste0("bio",sprintf("%02d", 1:19))
  } else if ("tem" == substr(bio_var,1,3)){
    band_vector <- paste0("temperature_",1:12)
  } else if ("pre" == substr(bio_var,1,3)){  
    band_vector <- paste0("precipitation_",1:12)
  }

  # edit the vrt metadata
  return(vrt_set_meta(vrt_path = vrt_path, description_vector = band_vector,
                        time_vector = time_vector))
}





