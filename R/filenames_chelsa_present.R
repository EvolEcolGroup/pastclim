#' Generate file names to download the chelsa present dataset
#'
#' This function creates a vector of paths needed to download the CHELSA present
#' dataset
#' @param dataset the name of the dataset of interest (currently unused)
#' @param bio_var the variable of interest
#' @param version the version of the dataset (currently unused)
#' @returns a vector of times, one per band
#'
#' @keywords internal
filenames_chelsa_present <- function(dataset, bio_var, version=NULL){
  # based on the variable, set the vars prefix (which include all version of
  # that variables, e.g. all bio, or all monthly precipitations)
  if ("bio"== substr(bio_var,1,3)){
    var_prefix <- "bio"
    var_indices <- paste0(var_prefix,1:19)
  } else if ("tem" == substr(bio_var,1,3)){
    var_prefix <- "tas"
    var_indices <- paste0(var_prefix,"_",sprintf("%02d", 1:12))
  } else if ("pre" == substr(bio_var,1,3)){  
    var_prefix <- "pr"
    var_indices <- paste0(var_prefix,"_",sprintf("%02d", 1:12))
  }
  # compose download paths
  paste0("https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/",
                         var_prefix,"/CHELSA_",var_indices,"_1981-2010_V.2.1.tif")
}