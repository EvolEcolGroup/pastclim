library(geodata)
path_wc <- "../../project_temp/climate_downscale/worldclim_monthly"
wc_tavg_5<-worldclim_global(var="tavg", res=5, path=path_wc, version="2.1")
# to read in again the tiffs
path_wc <- file.path(path_wc,"wc2.1_5m")
list_of_tiffs <- file.path(path_wc,dir(path_wc))
wc_tavg_5<-terra::rast(list_of_tiffs)
# better to save it as a netcdf
writeCDF(wc_tavg_5, file.path(get_data_path(),"wc2.1_5m_tavg.nc"))

One month
foo<-wc_tavg_5[[1]]


##get a tile
foo<-worldclim_tile("tavg",lon=0,lat=52,path=tempdir())