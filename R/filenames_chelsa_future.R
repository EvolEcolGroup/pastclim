#' Generate file names to download the chelsa future dataset
#'
#' This function creates a vector of paths needed to download the CHELSA future
#' dataset
#' @param dataset the name of the dataset of interest
#' @param bio_var the variable of interest
#' @param version the version of the dataset (currently unused)
#' @returns a vector of times, one per band
#'
#' @keywords internal

# CHELSA_2.1_GFDL-ESM4_ssp126_0.5m
# "GFDL-ESM4","IPSL-CM6A-LR", "MPI-ESM1-2-HR","MRI-ESM2-0","UKESM1-0-LL"
# c("ssp126","ssp370","ssp585")
# time_steps <- c(2025, 2055, 2075)

filenames_chelsa_future <- function(dataset, bio_var, version=NULL){
  # split the dataset name: model is element 3 and scenario element 4
  dataset_parsed <- unlist(strsplit(dataset,"_"))
  
  var_index <- substr(bio_var,nchar(bio_var)-1,nchar(bio_var))
  
  if ("bio"== substr(bio_var,1,3)){
    var_prefix <- "bio"
    var_index <- paste0(var_prefix,as.numeric(var_index)) # strip leading 0
  } else if ("tem" == substr(bio_var,1,3)){
    var_prefix <- "tas"
    var_index <- paste0(var_prefix,"_",var_index)
  } else if ("pre" == substr(bio_var,1,3)){  
    var_prefix <- "pr"
    var_index <- paste0(var_prefix,"_",var_index)
  }
  time_steps <- c("2011-2040","2041-2070","2071-2100")
  time_steps_underscore <- c("2011_2040","2041_2070","2071_2100")
  # compose download paths
  if (var_prefix=="bio"){
    chelsa_files <- paste0("https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/",
                           time_steps,"/",dataset_parsed[3],"/",dataset_parsed[4],"/",
                           var_prefix,"/CHELSA_",var_index,"_",time_steps,"_",
                           tolower(dataset_parsed[3]),"_",dataset_parsed[4],"_V.2.1.tif")
  } else {
    chelsa_files <- paste0("https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/",
                           time_steps,"/",dataset_parsed[3],"/",dataset_parsed[4],"/",
                           var_prefix,"/CHELSA_",tolower(dataset_parsed[3]),
                           "_r1i1p1f1_w5e5_",dataset_parsed[4], "_",var_index,
                           "_", time_steps_underscore,"_norm.tif")
    
  }
  return(chelsa_files)
  
}