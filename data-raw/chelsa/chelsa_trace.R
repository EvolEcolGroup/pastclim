#' @param dataset the name of the dataset
#' @param bio_var the variable name
#' @param filename NOT USED, only used for compatibility with other download functions
#' @returns TRUE if the requested CHELSA variable was downloaded successfully
#'
#' @keywords internal

download_chelsa_trace21k <- function(dataset, bio_var, filename=NULL, time_bp=NULL){
  if (substr(dataset,nchar(dataset)-2,nchar(dataset))=="vsi"){
    virtual <- TRUE
  } else {
    virtual <- FALSE
  }
  
  # based on the variable, get the original var prefix and name for chelsa
  if (any("bio" %in% substr(bio_var,1,3))){
    var_prefix <- "bio"
    
    var_index <- paste0(var_prefix,
                        sprintf("%02d", 
                                as.numeric(substr(bio_var,nchar(bio_var)-1,nchar(bio_var)))))
  } else if (any("tem" %in% substr(bio_var,1,3))){
    var_prefix <- "tas"
    var_index <- paste0(var_prefix,"_",
                        sprintf("%02d", 
                                as.numeric(substr(bio_var,nchar(bio_var)-1,nchar(bio_var)))))
  } else if (any("pre" %in% substr(bio_var,1,3))){  
    var_prefix <- "pr"
    var_index <- paste0(var_prefix,"_",
                        sprintf("%02d", 
                                as.numeric(substr(bio_var,nchar(bio_var)-1,nchar(bio_var)))))
  }
  vers <- "1.0"
  
  
  
  
  # convert time to an index to select the correct file
  avail_time_bp <- seq(0,-22000,-100)
  if (is.null(time_bp)){
    time_bp <- avail_time_bp
  }
  if (!all(time_bp %in% avail_time_bp)){
    stop("some values in time_bp are not valid; only steps from 0 to -22000 in steps of -100 are valid")
  }
  avail_yr_id <- seq(0,-200,by=-1)
  # convert time_bp to yr_id
  yr_id<-avail_yr_id[match(time_bp,avail_time_bp)]

  # create file names for a given variable
  chelsa_trace_root <- "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V1/chelsa_trace"
  download_url <- file.path(chelsa_trace_root, var_prefix, paste0("CHELSA_TraCE21k_",var_index,"_",yr_id,"_V",vers,".tif"))
 
  if (virtual){
    vrt_file_name <- paste0("CHELSA_trace_1.0_",var_prefix,"_vsi.vrt")
    # add prefix for vsi dataset
    chelsa_url <- paste0("/vsicurl/", download_url) # urls of target files
  } else { # download the files
    vrt_file_name <- paste0("CHELSA_trace_1.0_",var_prefix,".vrt")
    # if we do not have a directory, create one
    chelsa_dir <- file.path(get_data_path(),"chelsa_trace_1.0")
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
  
  #TODO copy over from chelsa present
  
  # TODO we should only download files if we need them, but we need to make sure the files have been
  # downloaded correctly
  download_res <- curl::multi_download(urls=paste0(chelsa_trace_root ,this_var_path,"/",files_this_var),
                       destfiles = file.path(work_dir,files_this_var))
  # TODO check that the download was successful
  this_var_rast <- terra::rast(file.path(work_dir,files_this_var))
  time_bp(this_var_rast) <- time_bp
  names(this_var_rast)<- rep(i_var,terra::nlyr(this_var_rast))
  cat("writing ",i_var,": this might take a long time, depending on the number of timesteps")
  pastclim_nc_name <- paste0("CHELSA_TraCE21k_",i_var,"_v",vers,".nc")
  terra::writeCDF(this_var_rast, 
                  filename = file.path(get_data_path(),pastclim_nc_name), 
                  varname = i_var,
                  compression = 6,
                  overwrite=TRUE) 
}
