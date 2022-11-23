# x a spatraster of the variable we want to downscale, with all the relevant time steps
# ref_time the time slice in x used to create the delta (usually the present)
# high_res_obs the observed high resolution data used to create the delta

delta_compute <- function(x, ref_time, high_res_obs) {
  ref_index <- which(time_bp(x)==ref_time)
  if(length(ref_index)!=1){
    stop("ref_time should be a time in x")
  }
  x_modern<-x[[ref_index]]
  if (terra::ext(high_res_obs)!=terra::ext(x_modern)){
    stop("x_modern and high_res_obs don't have the same extent")
  }
  # disaggregate the x_modern SpatRaster to the resolution of
  # the high res with "bilinear" interpolation
  x_modern_high<-disagg(x_modern, fact = terra::res( x_modern)/terra::res(high_res_obs),
         method="bilinear")
  # compute anomalies against the modern
  delta <- x_modern_high - high_res_obs
  # binary mask for delta
  delta_binary <- make_binary_mask(delta)
  # binary mask for maximum land extent
  max_land_binary<-make_binary_mask(max(x,na.rm=TRUE))
  max_land_binary<-disagg(max_land_binary, fact = terra::res( x_modern)/terra::res(high_res_obs),
                        method="near")
  # reset this mask to having NAs
  max_land_binary[max_land_binary==0] <- NA
  # delta gap (pixels for which we don't have a delta values)
  delta_gap <- max_land_binary - delta_binary
  delta_gap[delta_gap==0]<-NA
  delta_df <- as.data.frame(delta,xy=TRUE,na.rm=TRUE)
  delta_gap_df <- as.data.frame(delta_gap, xy=TRUE, na.rm=TRUE)
  names(delta_df)[3] <-"this_var"
  names(delta_gap_df)[3] <-"this_var"
  # interpolate those gaps with idw (time consuming...)
  # add ... to the function to be able to take additional params to gstat
  idw_obj <- gstat(formula = this_var~1, locations = ~x+y, data = delta_df, nmax=7,
               set=list(idp = .5))
  idw_pred <- predict(foo, newdata = delta_gap_df)[,-4] # remove the last column
  delta_gap_vals <- terra::rast(idw_pred,type="xyz")
  delta_gap_vals <- terra::extend(delta_gap_vals, delta)
  delta_extended < - merge(delta, delta_gap_vals)
  return(delta_extended)
}


# generate a SpatRaster of land masks at high resolution to feed to the downscale
# sea level https://www.ncdc.noaa.gov/paleo-search/study/19982
etopo1 <- terra::rast("ETOPO1_Ice_c_gmt4.grd")
sea_level <- read.table("spratt2016.txt", header = TRUE, row.names = 1)

# create a land mask and remove the ice

# sea level https://www.ncdc.noaa.gov/paleo-search/study/19982
etopo1 <- terra::rast("ETOPO1_Ice_c_gmt4.grd")
sea_level <- read.table("spratt2016.txt", header = TRUE, row.names = 1)

#system.file("extdata/sea_level_spratt2016.txt",data="package")


# downscaling:
# disaggregate the model predictions (bilinear interpolation)
# apply the delta
# cut by the land mask
# idw any remaining points on the coast




delta_downscale <- function(x, delta_rast,  x_landmask_high=NULL) {
  # check that extent and resolutions are compatible
  if (terra::ext(delta_rast)!=terra::ext(x)){
    stop("x and delta_rast don't have the same extent")
  }
  
  # downscale x with bilinear
  x_high <- disagg(x, fact = terra::res( x)/terra::res(delta_rast),
                        method="bilinear")
  # apply the delta_rast to x
  x_high <- x + delta_rast
  
  if(!is.null(x_landmask_high)){
    #refine the landmask in x_high
    
    
    # fill in any gaps that resulted from this step with idw
  }

  
}

# create mask for sea level
sea_level_mask <- function(topography_rast, sea_level) {
  
  
}

# create a binary mask where NAs are 0 and values are 1
make_binary_mask <- function (x){
  x[!is.na(x)]<-1
  x[is.na(x)]<-0
  return(x)
}

# fill in x for the values missing in y. 
idw_gap <- function(x, y, ...){
  # first mask x with y
  x<-terra::mask(x,y)
  x_bin <- make_binary_mask(x)
  y_bin <- make_binary_mask(y)
  # delta gap (pixels for which we don't have a delta values)
  x_gap <- y_bin - x_bin
  x_gap[x_gap==0]<-NA
  x_df <- terra::as.data.frame(x,xy=TRUE,na.rm=TRUE)
  x_gap_df <- terra::as.data.frame(x_gap, xy=TRUE, na.rm=TRUE)
  names(x_df)[3] <-"this_var"
  names(x_gap_df)[3] <-"this_var"
  # interpolate those gaps with idw (time consuming...)
  # add ... to the function to be able to take additional params to gstat
  idw_obj <- gstat::gstat(formula = this_var~1, locations = ~x+y, data = x_df, nmax=7,
                          set=list(idp = .5))
  idw_pred <- gstat::predict(foo, newdata = x_gap_df)[,-4] # remove the last column
  x_gap_vals <- terra::rast(idw_pred,type="xyz")
  x_gap_vals <- terra::extend(x_gap_vals, x)
  x_extended < - merge(x, x_gap_vals)
  return(x_extended)
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
