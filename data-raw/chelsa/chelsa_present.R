#' Download the CHELSA modern observations.
#'
#' This function downloads annual and monthly variables from the CHELSA v2.1 dataset.
#' @param dataset the name of the dataset
#' @param bio_var the variable name
#' @param filename NOT USED, only used for compatibility with other download functions
#' @returns TRUE if the requested CHELSA variable was downloaded successfully
#'
#' @keywords internal

download_chelsa_present <- function(dataset, bio_var, filename=NULL) {
  if (substr(dataset,nchar(dataset)-2,nchar(dataset))=="vsi"){
    virtual <- TRUE
  } else {
    virtual <- FALSE
  }
  
  # based on the variable, set the vars prefix (which include all version of
  # that variables, e.g. all bio, or all monthly precipitations)
  if (any("bio" %in% substr(bio_var,1,3))){
    var_prefix <- "bio"
    var_indices <- paste0(var_prefix,1:19)
  } else if (any("tem" %in% substr(bio_var,1,3))){
    var_prefix <- "tas"
    var_indices <- paste0(var_prefix,"_",sprintf("%02d", 1:12))
  } else if (any("pre" %in% substr(bio_var,1,3))){  
    var_prefix <- "pr"
    var_indices <- paste0(var_prefix,"_",sprintf("%02d", 1:12))
  }
  
  # compose download paths
  download_url <- paste0("https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/",
                         var_prefix,"/CHELSA_",var_indices,"_1981-2010_V.2.1.tif")
  
  if (virtual){
    vrt_file_name <- paste0("CHELSA_2.1_",var_prefix,"_vsi.vrt")
    # add prefix for vsi dataset
    chelsa_url <- paste0("/vsicurl/", download_url) # urls of target files
  } else { # download the files
    vrt_file_name <- paste0("CHELSA_2.1_",var_prefix,".vrt")
    stop("not implemented yet!")
    # if we do not have a directory, create one
    chelsa_dir <- file.path(get_data_path(),"chelsa2.1")
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
  vrt_path <- vrt(x = chelsa_url,
                  filename = file.path(get_data_path(),vrt_file_name),
                  options="-separate", overwrite=TRUE, return_filename=TRUE)
  # update band description and time axis
  time_vector <- rep(40,length(chelsa_url))
  if (var_prefix=="bio"){
    band_vector <- paste0("bio",sprintf("%02d", 1:19))
  } else if (var_prefix=="pr"){
    band_vector <- paste0("precipitation_",1:12)
  } else if (var_prefix=="tas"){
    band_vector <- paste0("temperature_",1:12)
  }
  # read vrt file
  x<- xml2::read_xml(vrt_path)
  # add band description and times
  band_nodes <- xml2::xml_find_all(x, xpath="VRTRasterBand")
  for (i_node in seq_len(length(band_nodes))){
    xml2::xml_add_child(band_nodes[i_node],"Description", band_vector[i_node])
    xml2::xml_add_child(band_nodes[i_node],"Time", time_vector[i_node])
  }
  # overwrite vrt file with the new version
  xml2::write_xml(x, vrt_path)
  return(TRUE)
}





#######################
get_vrt_times <- function(vrt_path) {
  x<- xml2::read_xml(vrt_path)
  band_nodes <- xml2::xml_find_all(x, xpath="VRTRasterBand")
  as.numeric(xml2::xml_text(xml2::xml_find_first(band_nodes, ".//Time")))
}