prec_series <- terra::sds(system.file("/extdata/delta/prec_series.nc",
                                       package="pastclim"))
tavg_series <- terra::sds(system.file("/extdata/delta/tavg_series.nc",
                                       package="pastclim"))
prec_present <- pastclim::slice_region_series(prec_series,time_bp=0)
tavg_present <- pastclim::slice_region_series(tavg_series,time_bp=0)
koeppen_raster <- koeppen_geiger(prec = prec_present,
                                 tavg = tavg_present)
# expect mostly Af
koeppen_series <- koeppen_geiger(prec = prec_series,
                                 tavg = tavg_series)

### worldclim check against the original paper
tavg_worldclim <- pastclim::region_slice(time_bp = 35,
                       bio_variables=c(paste0("temperature_0", 1:9), paste0("temperature_", 10:12)),
                       dataset="WorldClim_2.1_10m")
prec_worldclim <- pastclim::region_slice(time_bp = 35,
                                         bio_variables=c(paste0("precipitation_0", 1:9), paste0("precipitation_", 10:12)),
                                         dataset="WorldClim_2.1_10m")
koeppen_worldclim <- koeppen_geiger(prec = prec_worldclim,
                                 tavg = tavg_worldclim)
### 7k years ago
tavg_7k <- pastclim::region_slice(time_bp = -7000,
                                  bio_variables=c(paste0("temperature_0", 1:9), paste0("temperature_", 10:12)),
                                  dataset="Beyer2020")
prec_7k <- pastclim::region_slice(time_bp = -7000,
                                         bio_variables=c(paste0("precipitation_0", 1:9), paste0("precipitation_", 10:12)),
                                         dataset="Beyer2020")
koeppen_7k <- koeppen_geiger(prec = prec_7k,
                                    tavg = tavg_7k)
plot(koeppen_7k)
