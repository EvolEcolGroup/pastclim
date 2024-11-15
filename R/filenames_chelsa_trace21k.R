#' Generate file names to download the chelsa trace 21k
#'
#' This function creates a vector of paths needed to download the CHELSA trace21k
#' @param dataset the name of the dataset of interest (currently unused)
#' @param bio_var the variable of interest
#' @returns a vector of times, one per band
#'
#' @keywords internal
filenames_chelsa_trace21k<- function(dataset, bio_var){
  # TODO extract version from the dataset name
  version <- "1.0" 
  
  yr_id <- seq(20,-200,by=-1)
  
  # based on the variable, get the original var prefix and name for chelsa
  if (grepl("bio", bio_var)){
    var_prefix <- "bio"
    
    var_index <- paste0(var_prefix,
                        sprintf("%02d", 
                                as.numeric(substr(bio_var,nchar(bio_var)-1,nchar(bio_var)))))
  } else if (grepl("temperature_min", bio_var)){
    var_prefix <- "tasmin"
    var_index <- paste0(var_prefix,"_",
                        sprintf("%02d", 
                                as.numeric(substr(bio_var,nchar(bio_var)-1,nchar(bio_var)))))
  } else if (grepl("temperature_max", bio_var)){
    var_prefix <- "tasmax"
    var_index <- paste0(var_prefix,"_",
                        sprintf("%02d", 
                                as.numeric(substr(bio_var,nchar(bio_var)-1,nchar(bio_var)))))
  } else if (grepl("precipitation", bio_var)){
    var_prefix <- "pr"
    var_index <- paste0(var_prefix,"_",
                        as.numeric(substr(bio_var,nchar(bio_var)-1,nchar(bio_var))))
  }
  # create file names for a given variable
  #chelsa_trace_root <- "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V1/chelsa_trace"
  chelsa_trace_root <- "https://os.zhdk.cloud.switch.ch/chelsav1/chelsa_trace"
  file.path(chelsa_trace_root, var_prefix, paste0("CHELSA_TraCE21k_",var_index,"_",yr_id,"_V",version,".tif"))
}