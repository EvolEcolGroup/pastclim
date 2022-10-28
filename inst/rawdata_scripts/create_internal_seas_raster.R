# "create_internal_seas" generates a mask for internal seas (Caspian and Black
# sea) which are not removed in some reconstructions. We use a fix outline over
# time, as there are no good reconstrutions through time of their depth levels.
# Just source this script from the root directory of the package

library(pastclim)
library(terra)
unzip(
  zipfile = "./inst/rawdata_scripts/data_files/shapefiles_internal_seas.zip",
  exdir = "./inst/rawdata_scripts/temp_files"
)
caspian_shp <- vect(
  "./inst/rawdata_scripts/temp_files/shapefiles_internal_seas/Caspian_sea.shp"
)
black_sea_shp <- vect(
  "./inst/rawdata_scripts/temp_files/shapefiles_internal_seas/black_sea.shp"
)
mask_base <- region_slice(time_bp = 0, "biome", dataset = "Beyer2020")

caspian_raster <- rasterize(caspian_shp, mask_base)
caspian_raster[is.nan(caspian_raster)] <- 0
black_sea_raster <- rasterize(black_sea_shp, mask_base)
black_sea_raster[is.nan(black_sea_raster)] <- 0
internal_seas <- caspian_raster + black_sea_raster
internal_seas[internal_seas == 1] <- NaN
internal_seas[internal_seas == 0] <- 1
internal_seas[is.nan(internal_seas)] <- 0
writeCDF(internal_seas, "./inst/rawdata_scripts/temp_files/internal_seas.nc",
         varname="internal_seas", overwrite=TRUE)
library(ClimateOperators)
#cdo("--reduce_dim -copy ./inst/rawdata_scripts/temp_files/internal_seas_w_time.nc ./inst/rawdata_scripts/temp_files/internal_seas.nc")
#unlink("./inst/rawdata_scripts/temp_files/internal_seas_w_time.nc")
unlink("./inst/rawdata_scripts/temp_files/shapefiles_internal_seas",
  recursive = TRUE
)
