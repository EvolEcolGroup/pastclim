# this requires to have unpacked the shapefiles, which are in a zip file in
# /data-raw/data_files/shapefiles_internal_seas.zip

# TODO it should save the internal_seas.RDS into the extdata folder

library(terra)
azov <- terra::vect("azov_sea.shp")
black <- terra::vect("black_sea.shp")
caspian <- terra::vect("Caspian_sea.shp")
internal_seas <- rbind(azov, black, caspian)
internal_seas_wrap <- terra::wrap(internal_seas)
saveRDS(internal_seas_wrap, "internal_seas.RDS")
