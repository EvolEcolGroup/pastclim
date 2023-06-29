#' Download a WorldClim modern observations.
#'
#' This function downloads annual and monthly variables from the WorldClim 2.1 dataset.
#' @param dataset the name of the dataset
#' @param bio_var the variable name
#' @param filename the file name (full path) of the file to be saved
#' @returns TRUE if the requested WorldClim variable was downloaded successfully
#'
#' @keywords internal

download_worldclim_present <- function(dataset, bio_var, filename){
  # get resolution from the dataset name and convert it to the original
  res_conversion <- data.frame(our_res = c("10m","5m","2.5m", "0.5m"),
                                      wc_res = c("10m","5m", "2.5m", "30s"))
  wc_res <- res_conversion$wc_res[res_conversion$our_res==substr(dataset,
                                                                  start = 15,
                                                                  stop=nchar(dataset))]
  
  #function to grab the number from the raster layer
  if (grepl("bio",bio_var)){
    postfix <- "bio.zip"
    var_prefix <- "bio"
  } else if (grepl("temperature_min",bio_var)){
    postfix <- "tmin.zip"
    var_prefix <- "temperature_min_"
  } else if (grepl("temperature_max",bio_var)){
    postfix <- "tmax.zip"
    var_prefix <- "temperature_max_"
  } else if (grepl("temperature_",bio_var)){
    postfix <- "tavg.zip"
    var_prefix <- "temperature_"
  } else if (grepl("precipitation_",bio_var)){
    postfix <- "prec.zip"
    var_prefix <- "precipitation_"
  } else if (grepl("altitude",bio_var)){
    postfix <- "elev.zip"
    var_prefix <- "elevation"
  }  

  base_url <- "https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1"
  full_url <- paste(base_url, wc_res, postfix, sep="_")
  destfile <- tempfile()
  # download this zip file into a temp file
  curl::curl_download(full_url,
                      destfile = destfile,
                      quiet = FALSE
  )
  
  # unzip it to a temporary directory
  destpath <- file.path(tempdir(),"to_unzip")
  utils::unzip(destfile,exdir=destpath)
  wc_rast <- terra::rast(dir(destpath, full.names = TRUE))
  # sort out variable names
  if (!(grepl("altitude",bio_var))){
    # digits at the end of the name are the key identifier of each variable
    digits_at_end <- sprintf("%02d",
                             as.numeric(substr(
                               names(wc_rast),
                               regexpr("_\\d+\\b",names(wc_rast)) + 1,
                               nchar(names(wc_rast))
                             )))
    
    # now we need to rename the layers
    names(wc_rast) <-
      paste0(var_prefix, digits_at_end)      
  } else {
    names(wc_rast)<-"altitude"
  }

  # and finally we save it as a netcdf file
  time_bp(wc_rast) <- rep(35,nlyr(wc_rast))
  # temporary workaround to prevent problems with sf being loaded whilst writing netcdf
  unloadNamespace("sf")
  terra::writeCDF(wc_rast,filename=filename, compression=9, 
                  split=TRUE, overwrite=TRUE)
  # fix time axis (this is a workaround if we open the file with sf)
  nc_in <- ncdf4::nc_open(filename, write=TRUE)
  ncdf4::ncatt_put(nc_in, varid="time", attname="axis", attval = "T")
  ncdf4::nc_close(nc_in)
  
  # clean up
  unlink(file.path(destpath,"*"))
}
