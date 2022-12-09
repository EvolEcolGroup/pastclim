# the code below downloads the full worldclim dataset. Another option is to use
# worldclim_tile("tavg",lon=0,lat=52,path=tempdir())
# to only get part of the world

path_wc <- "../../project_temp/climate_downscale/worldclim_monthly"
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
sea_ext<- terra::ext(100, 110, 0, 10)
# crop the observations for this extent
high_res_tavg <- terra::crop(wc_tavg_5, sea_ext)
high_res_prec <- terra::crop(wc_prec_5, sea_ext)

bioclim_pres <- bioclim_vars(tavg = high_res_tavg, prec = high_res_prec)

tavg_series <- region_series(bio_variables = c(paste0("temperature_0",1:9),paste0("temperature_",10:12)),
                             time_bp =  get_time_steps(dataset = "Example"),
                             dataset = "Beyer2020",
                              ext = sea_ext)

