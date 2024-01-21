#' Download the paleoclim time series.
#'
#' This function downloads annual and monthly variables from the CHELSA v2.1 dataset.
#' @param dataset the name of the dataset
#' @param bio_var the variable name
#' @param filename the filename as stored in the `data_path` of `pastclim`
#' @returns TRUE if the requested CHELSA variable was downloaded successfully
#' @examples
#' download_paleoclim(dataset = "paleoclim_1.0_10m", bio_var = "bio_06",
#' filename = "paleoclim_10.vrt")
#' 
#' @keywords internal

download_paleoclim <- function(dataset, bio_var, filename) {
  
  # compose download paths
  download_url <- filenames_paleoclim(dataset=dataset,
                                     bio_var = bio_var)
  
  # if we do not have a directory, create one
  paleoclim_dir <- file.path(get_data_path(),"paleoclim_1.0")
  if(!dir.exists(paleoclim_dir)){
    dir.create(paleoclim_dir)
  }
  # and now download the files
  paleoclim_path <- file.path(paleoclim_dir,basename(download_url))
  download_res <- curl::multi_download(download_url,
                       destfiles = paleoclim_path,
                       resume = TRUE
  )
  # create band description and time axis
  time_period_codes <- c("LH", "MH")
  time_vector <- c(-5000,-3000)
  band_vector <- paste0("bio",sprintf("%02d", 1:19))
  
  # now unpack the files (files have the same name within each zip file, so
  # we need to extract them into subdirectories)
  # or can we use vsizip
  # this is wrong, we need to create files by variable
  for (i in seq_ln(19)){
    paleoclim_vsizip <- paste0("/vsizip/",file.path(paleoclim_path,paste0("bio_",i,".tif")))
    # create the vrt file
    vrt_path <- terra::vrt(x = paleoclim_vsizip,
                           filename = file.path(get_data_path(),filename),
                           options="-separate", overwrite=TRUE, return_filename=TRUE)
    # edit the vrt metadata
    vrt_set_meta(vrt_path = vrt_path, 
                 description_vector = rep(band_vector[i],length(time_period_codes)),
                 time_vector = time_vector)
  }
  
  return(TRUE)
}





