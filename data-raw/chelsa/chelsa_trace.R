# chelsa download pipeline

# create a download function that simply tells the user to use download_chelsa_trace21k


download_chelsa_trace21k <- function(time_bp, work_dir = tempdir()){
  vers <- "1.0"
  chelsa_trace_path<- "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V1/chelsa_trace/" 
  avail_time_bp <- seq(0,-22000,-100)
  # TODO check that they time_bp are valid
  avail_yr_id <- seq(20,-200,by=-1)
  # convert time_bp to yr_id
  yr_id<-avail_yr_id[match(time_bp,avail_time_bp)]

  # check available variables
  this_var_path <- "bio" # for the future, if we want monthly variables
  # create file names for a given variable
  i_var<-"bio01"
  pastclim_nc_name <- paste0("CHELSA_TraCE21k_",i_var,"_v",vers,".nc")
  files_this_var <- paste0("CHELSA_TraCE21k_",i_var,"_",yr_id,"_V",vers,".tif")
  # TODO we should only download files if we need them, but we need to make sure the files have been
  # downloaded correctly
  download_res <- curl::multi_download(urls=paste0(chelsa_trace_path,this_var_path,"/",files_this_var),
                       destfiles = file.path(work_dir,files_this_var))
  # TODO check that the download was successful
  this_var_rast <- terra::rast(file.path(work_dir,files_this_var))
  time_bp(this_var_rast) <- time_bp
  names(this_var_rast)<- rep(i_var,terra::nlyr(this_var_rast))
  cat("writing ",i_var,": this might take a long time, depending on the number of timesteps")
  terra::writeCDF(this_var_rast, 
                  filename = file.path(get_data_path(),pastclim_nc_name), 
                  varname = i_var,
                  compression = 9,
                  overwrite=TRUE) 
}
