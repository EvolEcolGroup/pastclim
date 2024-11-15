#' Generate file names to download the chelsa present dataset
#'
#' This function creates a vector of paths needed to download the CHELSA present
#' dataset
#' @param dataset the name of the dataset of interest (currently unused)
#' @param bio_var the variable of interest
#' @returns a vector of times, one per band
#'
#' @keywords internal
filenames_chelsa_present <- function(dataset, bio_var){
  var_index <- substr(bio_var,nchar(bio_var)-1,nchar(bio_var))
  
  if ("bio"== substr(bio_var,1,3)){
    var_prefix <- "bio"
    var_index <- paste0(var_prefix,as.numeric(var_index)) # strip leading 0
  } else if (length(grep(pattern="npp",bio_var))){  
    var_prefix <- "bio"
    var_index <- "npp"  
  } else if (length(grep(pattern="temperature_min",bio_var))){
    var_prefix <- "tasmin"
    var_index <- paste0(var_prefix,"_",var_index)        
  } else if (length(grep(pattern="temperature_max",bio_var)) ){
    var_prefix <- "tasmax"
    var_index <- paste0(var_prefix,"_",var_index)        
    
  } else if (length(grep(pattern="temperature_",bio_var))){
    var_prefix <- "tas"
    var_index <- paste0(var_prefix,"_",var_index)    
  } else if ("pre" == substr(bio_var,1,3)){  
    var_prefix <- "pr"
    var_index <- paste0(var_prefix,"_",var_index)
  }
  # compose download paths
  chelsa_root <- "https://os.zhdk.cloud.switch.ch/chelsav2/GLOBAL/climatologies/1981-2010/"
#  chelsa_root <- "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/"
  paste0(chelsa_root, var_prefix,"/CHELSA_",var_index,"_1981-2010_V.2.1.tif")
}