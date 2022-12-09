# the code below downloads the full worldclim dataset. Another option is to use
# worldclim_tile("tavg",lon=0,lat=52,path=tempdir())
# to only get part of the world

base_path_wc <- "../../project_temp/climate_downscale/worldclim_monthly"
wc_res <- 5 # one of 10,5,2.5,0.5 minutes

library(geodata)
library(pastclim)

# load the observations (and download them if needed)
if (!file.exists(file.path(base_path_wc,"wc_tavg_5_monthly.nc"))){
  wc_tavg_5<-geodata::worldclim_global(var="tavg", res=wc_res, path=tempdir(), version="2.1")
  terra::writeCDF(wc_tavg_5,file.path(base_path_wc,"wc_tavg_5_monthly.nc"),
                  compression=9)
} else {
  wc_tavg_5<-terra::rast(file.path(base_path_wc,"wc_tavg_5_monthly.nc"))
}

if (!file.exists(file.path(base_path_wc,"wc_prec_5_monthly.nc"))){
  wc_prec_5<-geodata::worldclim_global(var="prec", res=wc_res, path=tempdir(), version="2.1")
  terra::writeCDF(wc_prec_5,file.path(base_path_wc,"wc_prec_5_monthly.nc"),
                  compression=9)
} else {
  wc_prec_5<-terra::rast(file.path(base_path_wc,"wc_prec_5_monthly.nc"))
}

# now set the extent for SEA
sea_ext<- terra::ext(110, 120, -5, 5)
# crop the observations for this extent
high_res_tavg <- terra::crop(wc_tavg_5, sea_ext)
high_res_prec <- terra::crop(wc_prec_5, sea_ext)
# check that we can compute bioclim variables for the present
bioclim_pres <- bioclim_vars(tavg = high_res_tavg, prec = high_res_prec)
# Get timeseries (only for a limited number of time steps, equivalent to the Example dataset)
tavg_series <- region_series(bio_variables = c(paste0("temperature_0",1:9),paste0("temperature_",10:12)),
                             time_bp =  get_time_steps(dataset = "Example"),
                             dataset = "Beyer2020",
                              ext = sea_ext)

prec_series <- region_series(bio_variables = c(paste0("precipitation_0",1:9),paste0("precipitation_",10:12)),
                             time_bp =  get_time_steps(dataset = "Example"),
                             dataset = "Beyer2020",
                             ext = sea_ext)
# now get the relief data and create landmasks
relief_rast <- pastclim:::download_relief(high_res_tavg)
high_res_mask <- pastclim:::make_land_mask(relief_rast = relief_rast, 
                                           time_bp = get_time_steps(dataset = "Example"))
# now we need to downscale the two series of monthly variables
# we will have to downscale one month at a time, put all the months into
# a list, and then combine them into a SpatRasterDataset
# start with temperature
tavg_downscaled_list<-list()
for (i in 1:12){
  delta_rast<-pastclim:::delta_compute(x=tavg_series[[i]], ref_time = 0, 
                                       obs = high_res_tavg[[i]])
  tavg_downscaled_list[[i]] <- pastclim:::delta_downscale (x = tavg_series[[i]], 
                                                  delta_rast = delta_rast,
                                                  x_landmask_high = high_res_mask)
}
tavg_downscaled <- terra::sds(tavg_downscaled_list)

prec_downscaled_list<-list()
for (i in 1:12){
  delta_rast<-pastclim:::delta_compute(x=prec_series[[i]], ref_time = 0, 
                                       obs = high_res_prec[[i]])
  prec_downscaled_list[[i]] <- pastclim:::delta_downscale (x = prec_series[[i]], 
                                                           delta_rast = delta_rast,
                                                           x_landmask_high = high_res_mask)
}
prec_downscaled <- terra::sds(prec_downscaled_list)

# now create the biovariables
bioclim_downscaled<-bioclim_vars(tavg =tavg_downscaled, prec = prec_downscaled)


## write some files for a future vignette
# terra::writeCDF(tavg_series,file.path(path_wc,"tavg_series.nc"),compression=9)
# terra::writeCDF(prec_series,file.path(path_wc,"prec_series.nc"),compression=9)
# terra::writeCDF(relief_rast,file.path(path_wc,"relief.nc"),compression=9)
# terra::writeCDF(high_res_tavg,file.path(path_wc,"high_res_tavg.nc"),compression=9)
# terra::writeCDF(high_res_prec,file.path(path_wc,"high_res_prec.nc"),compression=9)

# suggested range for a vignette:
#sea_ext<- terra::ext(110, 120, -5, 5)

