# x_modern the modern climate reconstruction
# high_res_obs the observed high resolution data used to create the delta

delta_compute <- function(x_modern, high_res_obs) {
  if (terra::ext(high_res_obs)!=terra::ext(x_modern)){
    stop("x_modern and high_res_obs don't have the same extent")
  }
  # disaggregate the x_modern SpatRaster to the resolution of
  # the high res with "near"
  x_modern_high<-disagg(x_modern, fact = terra::res( x_modern)/terra::res(high_res_obs),
         method="near")
  # compute anomalies against the modern
  delta <- x_modern_high - high_res_obs
  return(delta)
}


# steps for delta downscaling in areas without info
# check Roberts or Mario's paper



delta_downscale <- function(x, delta_rast,  time_point, sea_level_path, x_ice, x_landmask_high) {
  # check that extent and resolutions are compatible

  # create a land mask and remove the ice
  
  # sea level https://www.ncdc.noaa.gov/paleo-search/study/19982
  etopo1 <- terra::rast("ETOPO1_Ice_c_gmt4.grd")
  sea_level <- read.table("spratt2016.txt", header = TRUE, row.names = 1)

  #system.file("extdata/sea_level_spratt2016.txt",data="package")
  
  # downscale x with near
  x_high<-disagg(x, fact = terra::res( x)/terra::res(delta_rast),
                        method="near")
  
  # adjust the land area based on sea level
  
  # expand with bilinear for areas without information for both x and delta_rast

  # apply the delta_rast to x
}

# create mask for sea level
sea_level_mask <- function(topography_rast, sea_level) {
  
  
}





eaf <- extent(30, 55, -15, 20)
r <- rast()
e <- ext(r)
as.vector(e)
as.character(e)

ext(r) <- c(0, 2.5, 0, 1.5)
af_precip <- crop(bio12_rasterbrick, eaf) # crop to africa


eaf <- terra::ext(30, 55, -15, 20)

etopo1 <- terra::rast("ETOPO1_Ice_c_gmt4.grd")
etopo30 <- terra::agg(etopo1, fact = 30)


bi <- terra::boundaries(land_mask)
bi_up <- terra::disagg(bi, fact = 30)


## create a sea level mask (ideally on full data), setting
## land to a recogniseable value (e.g. -99999)
## first mask the raster based based on sea level mask
## the cover the raster based on sea level mask
## now find values that were covered (i.e. -99999) and interpolate them