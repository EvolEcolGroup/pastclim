#!/usr/bin/env Rscript

# arguments when running the code interactively
params <- list(reference_filename="LateQuaternary_Environment_u.nc",
               variable="BIO1",
               etopo="etopo2022_60s_v1.nc")

# parsing options when run from the command line with Rscript
if (!interactive()){
  library("optparse")
  parser <- OptionParser(description="Compute topography")
  
  parser <- add_option(parser, c("-rf", "--reference_filename"), action="store", 
                       type="character", help="reference file to be used to determine dimensions")
  parser <- add_option(parser, c("-v", "--variable"), action="store", 
                       type="character", help="variable to be used in ref file as template for dimensions")
  parser <- add_option(parser, c("-e", "--etopo"), action="store", 
                       type="character", help="file name for etopo")
  
  # Parse the command line arguments as members of a list called params
  params <- parse_args(parser)
}

library(pastclim)

# first create a template raster to fill in
mask_nc <- terra::rast(param$reference_filename,
    subds = params$variable)
etopo <- terra::rast(params$etopo)
time_steps_bp_all <- time_bp(mask_nc)
time_steps_bp <- c(0,-15000,-20000)
# convert to rows of sea level

altitude_all <- NULL
rugosity_all <- NULL

problematic_cells <- list()


for (i in time_steps_bp) {
  pastclim:::get_sea_level(i)

  # repeat for the new set of cells that we have identified
  # we need to get a land_mask without internal seas
  #land_mask <- pastclim::climate_for_time_slice(i, "bio01", dataset)
  land_mask <- mask_nc[which(time_steps_bp==i)]
  
  land_mask[!is.na(land_mask)] <- 1
  bi <- terra::boundaries(land_mask)
  bi_up <- terra::disagg(bi, fact = 30)
  boundary_cells <- which(terra::values(bi_up) == 1)
  # subset etopo to the landmask
  etopo_now <- terra::crop(etopo, bi_up)
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
}
#writeCDF(rugosity_all, "rugosity.nc")
#writeCDF(altitude_all, "altitude.nc")
