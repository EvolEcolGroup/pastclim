# script to generate files for delta downscaling vignette
library(terra)
library(pastclim)
sea_ext<- terra::ext(110, 120, -5, 5)
tavg_vars <- c(paste0("temperature_0",1:9),paste0("temperature_",10:12))
time_steps <- get_time_steps(dataset = "Example")
tavg_series <- region_series(bio_variables =tavg_vars,
                             time_bp =  time_steps,
                             dataset = "Beyer2020",
                             ext = sea_ext)

# create download_worldclim(vars,res,version,path)
# and load_worldclim(vars, res, version, path)