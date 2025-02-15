#' Download the paleoclim time series.
#'
#' This function downloads annual and monthly variables from the Paleoclim V1.0 dataset.
#' @param dataset the name of the dataset
#' @param bio_var the variable name
#' @param filename (NOT USED FOR THIS FUNCTION: the data come as zip of all bio
#' variables, so we generate multiple files, not a single one)
#' @returns TRUE if the requested paleoclim variable was downloaded successfully
#' 
#' @keywords internal

download_paleoclim <- function(dataset, bio_var, filename = NULL) {
  version <- "1.0.0" # version of the vrt so that we can change things later
  
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
  # this server does not allow to resume downloads
  download_res <- curl::multi_download(download_url,
                       destfiles = paleoclim_path
  )

  # create band description and time axis
#  time_period_codes <- c("LH", "MH", "EH", "YDS", "BA", "HS1", "LIG")
  time_vector <- c(0,-2250,-6250, -10000, -12300, -13800,-15850, -21000, -130000)
  band_vector <- paste0("bio",sprintf("%02d", 1:19))
  resolution <- strsplit(dataset,"_")[[1]][3]
  # if resolution is 2.5, we need to change it to 2_5
  resolution <- gsub(".", "_", resolution, fixed = TRUE)
  resolution <- paste0(resolution,"in") # to get 10min
  # the zip with present day reconstructions has an additional directory
  # same for zip with LGM reconstructions
  paleoclim_path[1] <- file.path(paleoclim_path[1],resolution)
  paleoclim_path[8] <- file.path(paleoclim_path[8],resolution)
  # create a vrt for each variable
  for (i in seq_len(length(band_vector))){
    # build the vsizip paths
    paleoclim_vsizip <- paste0("/vsizip/",file.path(paleoclim_path,paste0("bio_",i,".tif")))
    # TODO to add the really old time slices, we need to substitute these for certain variables
    # with a blank raster
    vrt_filename <- paste0(dataset,"_",band_vector[i],"_v",version,".vrt")
    # create the vrt file
    # vrt_path <- terra::vrt(x = paleoclim_vsizip,
    #                        filename = file.path(get_data_path(),vrt_filename),
    #                        options="-separate", overwrite=TRUE, return_filename=TRUE)
    vrt_path <- file.path(get_data_path(),vrt_filename)
    if(file.exists(vrt_path)){
      file.remove(vrt_path)
    }
    sf::gdal_utils(
      util = "buildvrt",
      source = paleoclim_vsizip,
      destination = vrt_path,
      options = c("-separate")
    )
    # edit the vrt metadata
    edit_res <- vrt_set_meta(vrt_path = vrt_path, 
                 description = band_vector[i],
                 time_vector = time_vector)
     if (!edit_res){
      file.remove(vrt_path)
      stop("something went wrong setting up ", band_vector[i], "\n the dataset wil need downloading again")
    }
  }

  
  return(TRUE)
}





