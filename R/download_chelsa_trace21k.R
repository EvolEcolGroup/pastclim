#' Download the CHELSA trace21k
#'
#' This function downloads annual and monthly variables from the CHELSA trace v1.0 dataset.
#' 
#' As this dataset is huge, we should not download all files in most situations. For this
#' reason, time_bp has to be set for downloading (but it is allowed for virtual datasets)
#' 
#' @param dataset the name of the dataset
#' @param bio_var the variable name
#' @param filename the filename as stored in the `data_path` of `pastclim` (includes the full data path)
#' @param time_bp the time steps for which the dataset should be built (NULL for all time steps)
#' @returns TRUE if the requested CHELSA variable was downloaded successfully
#' 
#' @keywords internal


# download_chelsa_trace21(dataset = "CHELSA_trace21k_1.0_0.5m_vsi", bio_var = "bio06",
# filename = file.path(get_data_path(), "CHELSA_trace21k_1.0_0.5m_bio06_vsi.vrt"),
# time_bp= c(-22000,-10000,0))

download_chelsa_trace21k <- function(dataset, bio_var, filename=NULL, time_bp=NULL){
  if (substr(dataset,nchar(dataset)-2,nchar(dataset))=="vsi"){
    virtual <- TRUE
  } else {
    virtual <- FALSE
  }
  
  if (!virtual & is.null(time_bp)){
    stop("the CHELSA Trace21k dataset is very large. You can either use
         a virtual dataset (leaving the files on the server), or, if you want
         to download specific time slices, use 'download_chelsa_trace21k' by
         setting the time slices of interest with the parameter 'time_bp'.
         See the dataset help page for more information
         (use ??CHELSA_Trace21k)")
  }

  # convert time to an index to select the correct file
  avail_time_bp <- seq(0,-22000,-100)
  if (is.null(time_bp)){
    time_bp <- avail_time_bp
  }
  if (!all(time_bp %in% avail_time_bp)){
    stop("some values in time_bp are not valid; only steps from 0 to -22000 in steps of -100 are valid")
  }
  avail_yr_id <- seq(20,-200,by=-1)
  # convert time_bp to yr_id
  yr_id<-avail_yr_id[match(time_bp,avail_time_bp)]
  
  # create file names for a given variable
  download_url <- filenames_chelsa_trace21k(dataset = dataset,
                                            bio_var = bio_var)
  # subset to the years that we want
  file_yr_id <- as.numeric(gsub(".*_(\\-?\\d+)_.*","\\1",download_url))
  download_url <- download_url[match(yr_id, file_yr_id)]
  
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
    download_res <- curl::multi_download(download_url,
                                         destfiles = chelsa_url, resume = TRUE
    )
    if(any(!download_res$success)){
      stop("something went wrong downloading the data; try again")
    }
  }

  
  # we capture warnings from the vrt to make sure that all is well
  tryCatch(vrt_path <- terra::vrt(x = chelsa_url,
                                  filename = filename,
                                  options=c("-separate"), overwrite=TRUE, return_filename=TRUE),
           warning  = function(w) {
             # don't throw an error if we get a warning because of the old gadal version
             # which only saves the first band and ignores the -b option
             if (!grepl("Only the first one",w)){
               file.remove(vrt_path)
               stop("vrt creation failed with ", w,"\n try to redownload this dataset")
             }
             
           })
  

  # edit the vrt metadata
  edit_res <- vrt_set_meta(vrt_path = vrt_path, description = bio_var,
                           time_vector = time_bp, time_bp=TRUE)
  if (!edit_res){
    file.remove(vrt_path)
    stop("something went wrong setting up this dataset", , "\n the dataset wil need downloading again")
  }
  return()
}





