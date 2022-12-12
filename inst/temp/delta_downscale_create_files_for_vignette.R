# script to generate files for delta downscaling vignette
library(terra)
library(pastclim)
if (!dir.exists("../extdata")){
stop("your working directory was not set in the directory of this script")
}
delta_dir <- "../extdata/delta"
dir.create(delta_dir,showWarnings = FALSE)
sea_ext<- terra::ext(110, 120, -5, 5)
tavg_vars <- c(paste0("temperature_0",1:9),paste0("temperature_",10:12))
time_steps <- get_time_steps(dataset = "Example")
tavg_series <- region_series(bio_variables =tavg_vars,
                             time_bp =  time_steps,
                             dataset = "Beyer2020",
                             ext = sea_ext)

# create download_worldclim(vars,res,version,path)
# and 
prec_vars <- c(paste0("precipitation_0",1:9),paste0("precipitation_",10:12))
prec_series <- region_series(bio_variables = prec_vars,
                             time_bp =  time_steps,
                             dataset = "Beyer2020",
                             ext = sea_ext)

pastclim:::download_worldclim("tavg",10)
tavg_obs_hres_all <- pastclim:::load_worldclim("tavg",10)
tavg_obs_hres_all <- terra::crop(tavg_obs_hres_all, sea_ext)

pastclim:::download_worldclim("prec",10)
prec_obs_hres_all <- pastclim:::load_worldclim("prec",10)
prec_obs_hres_all <- terra::crop(prec_obs_hres_all, sea_ext)

tavg_obs_hres_rast <- tavg_obs_hres_all[[1]]
relief_rast <- pastclim:::download_relief(tavg_obs_hres_rast)

terra::writeCDF(tavg_series,file.path(delta_dir,"tavg_series.nc"),
                compression=9, overwrite = TRUE)
terra::writeCDF(prec_series,file.path(delta_dir,"prec_series.nc"),
                compression=9, overwrite = TRUE)
terra::writeCDF(relief_rast,file.path(delta_dir,"relief.nc"),
                compression=9, overwrite = TRUE)
terra::writeCDF(tavg_obs_hres_all,file.path(delta_dir,"tavg_obs_hres_all.nc"),
                compression=9, overwrite = TRUE)
terra::writeCDF(prec_obs_hres_all,file.path(delta_dir,"prec_obs_hres_all.nc"),
                compression=9, overwrite = TRUE)

# hack until terra is fixed
# for (nc_name in c(file.path(delta_dir,"tavg_series.nc"),
#                   file.path(delta_dir,"prec_series.nc"))){
#   nc_in <- ncdf4::nc_open(nc_name, write=TRUE)
#   ncdf4::ncatt_put(nc_in,varid="time", 
#                    attname = "units",
#                    attval = "years since 1950-01-01 00:00:00.0")
#   ncdf4::ncatt_put(nc_in,varid="time", 
#                    attname = "long_name",
#                    attval = "years BP")
#   ncdf4::ncatt_put(nc_in, varid="time", attname="axis", attval = "T")
#   ncdf4::nc_close(nc_in)  
# }
# 
# 
