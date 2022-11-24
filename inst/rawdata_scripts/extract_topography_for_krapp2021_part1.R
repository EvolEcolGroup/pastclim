# rugosity
dataset <- "Krapp2021"
# load the ETOPO1 dataset downloaded from NOAA
# https://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/ice_surface/cell_registered/netcdf/
etopo1 <- terra::rast("ETOPO1_Ice_c_gmt4.grd")
# sea level https://www.ncdc.noaa.gov/paleo-search/study/19982
sea_level <- read.table("spratt2016.txt", header = TRUE, row.names = 1)

# get the file needed to create a mask
mask_file <- pastclim:::get_file_for_dataset("bio01", dataset)$file_name
mask_nc <- terra::rast(paste0(
  system.file("extdata", package = "pastclimData"),
  "/", mask_file
), subds = "BIO1")
time_steps_bp_all <- time_bp(mask_nc)
# convert to rows of sea level

altitude_all <- NULL
rugosity_all <- NULL

problematic_cells <- list()

library(terra)
# read in previous file

if (file.exists("altitude.nc")) {
  res <- file.copy("altitude.nc", "altitude_temp.nc", overwrite = TRUE)
  if (!res) {
    stop("something went wrong copying the temp file")
  }
  altitude_all <- rast("altitude_temp.nc")
  time_bp(altitude_all) <- time_steps_bp_all[1:(dim(altitude_all)[3])]
  res <- file.copy("rugosity.nc", "rugosity_temp.nc", overwrite = TRUE)
  if (!res) {
    stop("something went wrong copying the temp file")
  }
  rugosity_all <- rast("rugosity_temp.nc")
  time_bp(rugosity_all) <- time_steps_bp_all[1:(dim(rugosity_all)[3])]
  n_steps <- dim(rugosity_all)[3]
} else {
  n_steps <- 0
}


time_steps_bp <- time_steps_bp_all[(n_steps + 1):(n_steps + 100)]
time_steps_bp <- time_steps_bp[!is.na(time_steps_bp)]

for (i in time_steps_bp) {
  cat(i)
  time_step_row <- - (i / 1000) + 1
  # now check neighbours of each boundary cell, and expand out if < sea level
  sea_level_now <- sea_level$SeaLev_longPC1[time_step_row]

  # repeat for the new set of cells that we have identified
  # we need to get a land_mask without internal seas
  land_mask <- pastclim::climate_for_time_slice(i, "bio01", dataset)
  land_mask[!is.na(land_mask)] <- 1
  bi <- terra::boundaries(land_mask)
  bi_up <- terra::disagg(bi, fact = 30)
  boundary_cells <- which(terra::values(bi_up) == 1)
  # subset etopo to the landmask
  etopo_now <- terra::crop(etopo1, bi_up)
  etopo_now <- terra::mask(etopo_now, bi_up)
  # now set boundary_cells that are below sea level to NA
  boundary_under_water <-
    boundary_cells[etopo_now[boundary_cells] < sea_level_now]
  etopo_now[boundary_under_water] <- NA
  rugosity_now <- terra::aggregate(etopo_now,
    fact = 30,
    fun = sd,
    na.rm = TRUE
  )
  altitude_now <- terra::aggregate(etopo_now,
    fact = 30,
    fun = mean,
    na.rm = TRUE
  )
  # now check if any cell was lost
  left_behind <- terra::mask(land_mask, rugosity_now, inverse = TRUE)
  left_behind_cells <- which(!is.na(values(left_behind)))
  if (length(left_behind_cells) > 0) {
    # we need to interpolate those cells
    altitude_extra <- altitude_now
    rugosity_extra <- rugosity_now
    while (length(left_behind_cells) > 0) {
      rugosity_extra <-
        focal(
          rugosity_extra,
          w = 3,
          fun = mean,
          na.rm = TRUE,
          NAonly = TRUE,
          pad = TRUE
        )
      rugosity_missing_vals <- rugosity_extra[left_behind_cells]
      rugosity_missing_vals$focal_mean[
        is.nan(rugosity_missing_vals$focal_mean)] <- NA
      rugosity_now[left_behind_cells] <- rugosity_missing_vals
      altitude_extra <-
        focal(
          altitude_extra,
          w = 3,
          fun = mean,
          na.rm = TRUE,
          NAonly = TRUE,
          pad = TRUE
        )
      altitude_missing_vals <- altitude_extra[left_behind_cells]
      altitude_missing_vals$focal_mean[
        is.nan(altitude_missing_vals$focal_mean)] <- NA
      altitude_now[left_behind_cells] <- altitude_missing_vals
      left_behind <-
        terra::mask(land_mask, rugosity_now, inverse = TRUE)
      left_behind_cells <- which(!is.na(values(left_behind)))
    }
  }
  time_bp(rugosity_now) <- i
  time_bp(altitude_now) <- i
  # and now we save the rasters
  if (is.null(rugosity_all)) {
    rugosity_all <- rugosity_now
    altitude_all <- altitude_now
  } else {
    terra::add(rugosity_all) <- rugosity_now
    terra::add(altitude_all) <- altitude_now
  }
  rm(rugosity_now, altitude_now, bi, bi_up, etopo_now, land_mask, left_behind)
  # try clean up
  tmpFiles(current = FALSE, orphan = TRUE, old = TRUE, remove = TRUE)
  gc()
}
writeCDF(rugosity_all, "rugosity.nc", overwrite = TRUE, compression = 9)
writeCDF(altitude_all, "altitude.nc", overwrite = TRUE, compression = 9)
