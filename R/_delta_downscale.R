delta_compute <- function(x_modern, high_res) {
  # get the extent of the high res reference

  # check that it is compatible with the x_modern

  # disaggregate the x_modern SpatRaster to the resolution of
  # the high res with "near"

  # compute anomalies against the modern
}

delta_downscale <- function(x, delta_rast, time_point, sea_level_path) {
  # check that extent and resolutions are compatible

  # sea level https://www.ncdc.noaa.gov/paleo-search/study/19982
  etopo1 <- terra::rast("ETOPO1_Ice_c_gmt4.grd")
  sea_level <- read.table("spratt2016.txt", header = TRUE, row.names = 1)

  # downscale x with near

  # adjust the land area based on sea level

  # expand with bilinear for areas without information for both x and delta_rast

  # apply the delta_rast to x
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
