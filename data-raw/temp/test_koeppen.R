prec_series <- terra::sds(system.file("/extdata/delta/prec_series.nc",
                                       package="pastclim"))
tavg_series <- terra::sds(system.file("/extdata/delta/tavg_series.nc",
                                       package="pastclim"))
prec_present <- pastclim::slice_region_series(prec_series,time_bp=0)
tavg_present <- pastclim::slice_region_series(tavg_series,time_bp=0)
koeppen_raster <- koeppen_geiger(prec = prec_present,
                                 tavg = tavg_present,
                                 broad = FALSE,
                                 class_names = FALSE)
koeppen_series <- koeppen_geiger(prec = prec_series,
                                 tavg = tavg_series,
                                 broad = FALSE,
                                 class_names = FALSE)