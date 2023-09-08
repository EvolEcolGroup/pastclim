#' Download a WorldClim future predictions.
#'
#' This function downloads annual and monthly variables from the WorldClim 2.1 
#' predictions for the future. 
#' @param dataset the name of the dataset
#' @param bio_var the variable name
#' @param filename the file name (full path) of the file to be saved
#' @returns TRUE if the requested WorldClim variable was downloaded successfully
#'
#' @keywords internal

download_worldclim_future <- function(dataset, bio_var, filename){
  # reset warnings for gdal to terra default
  # this is necessary if sf was loaded in the mean time
  terra::gdal(warn = 3)
  # get resolution from the dataset name and convert it to the original
  res_conversion <- data.frame(our_res = c("10m","5m","2.5m", "0.5m"),
                                      wc_res = c("10m","5m", "2.5m", "30s"))
  wc_res <- res_conversion$wc_res[res_conversion$our_res==substr(dataset,
                                                                  start = regexpr("_\\d+\\.?\\d+m",dataset)+1,
                                                                  stop=nchar(dataset))]
  gcm <- c("ACCESS-CM2", "BCC-CSM2-MR", "CMCC-ESM2", "EC-Earth3-Veg", "FIO-ESM-2-0",
           "GFDL-ESM4", "GISS-E2-1-G", "HadGEM3-GC31-LL", "INM-CM5-0", "IPSL-CM6A-LR",
           "MIROC6", "MPI-ESM1-2-HR", "MRI-ESM2-0", "UKESM1-0-LL")
  scenarios <- c("ssp126",	"ssp245",	"ssp370",	"ssp585")
  dates_df <- data.frame(orig=c("2021-2040", "2041-2060", "2061-2080","2081-2100"),
                         time_bp = (c(2030,2050,2070,2090)-1950))
  wc_gcm <- gcm[which(unlist(lapply(gcm,grepl, dataset)))]
  wc_scenario <- scenarios[which(unlist(lapply(scenarios,grepl, dataset)))]

  # set appropriate postfix and prefix based on variable names
  if (grepl("bio",bio_var)){
    postfix <- "bioc"
    var_prefix <- "bio"
  } else if (grepl("temperature_min",bio_var)){
    postfix <- "tmin"
    var_prefix <- "temperature_min_"
  } else if (grepl("temperature_max",bio_var)){
    postfix <- "tmax"
    var_prefix <- "temperature_max_"
  } else if (grepl("precipitation_",bio_var)){
    postfix <- "prec"
    var_prefix <- "precipitation_"
  } else if (grepl("altitude",bio_var)){
    # TODO this requires dispatching to a custom function that takes the elevation
    # form the present, and then creates a special altitude file
    postfix <- "elev"
    var_prefix <- "elevation"
  }  

  base_url <- "https://geodata.ucdavis.edu/cmip6"
  base_url <- paste(base_url, wc_res, wc_gcm, wc_scenario, sep="/")
  base_file <- paste("wc2.1", wc_res, postfix,wc_gcm, wc_scenario,sep="_")
  base_url <- paste(base_url,base_file, sep="/")
  #  https://geodata.ucdavis.edu/cmip6/10m/ACCESS-CM2/ssp126/wc2.1_10m_tmin_ACCESS-CM2_ssp126_2081-2100.tif
  
  wc_list<-list()
  for (i_step in dates_df$orig){
    this_url <- paste0(base_url,"_",i_step,".tif")
    destfile <- tempfile()
    # download this zip file into a temp file
    curl::curl_download(this_url,
                      destfile = destfile,
                      quiet = FALSE
    )
  wc_list[[i_step]] <- terra::rast(destfile)

  message("this will take a few minutes")
  # and finally we save it as a netcdf file
  time_bp(wc_list[[i_step]]) <- rep(dates_df$time_bp[dates_df$orig == i_step],nlyr(wc_list[[i_step]]))
  }
  message("assembling all the data into a netcdf file for use with pastclim; this operation will take a couple of minutes...\n")
  
  var_names <- names(wc_list[[1]])
  sds_list <- list()
  for (i_var in var_names){
    sds_list[[i_var]]<-terra::rast(lapply(wc_list, terra::subset,subset=i_var))
    names(sds_list[[i_var]])<-rep(i_var,nlyr((sds_list[[i_var]])))
  }
  browser()
  wc_sds <- terra::sds(sds_list)
  
  terra::writeCDF(wc_sds,filename=filename, compression=9, 
                  overwrite=TRUE)
  # fix time axis (this is a workaround if we open the file with sf)
  nc_in <- ncdf4::nc_open(filename, write=TRUE)
  ncdf4::ncatt_put(nc_in, varid="time", attname="axis", attval = "T")
  ncdf4::nc_close(nc_in)

}

