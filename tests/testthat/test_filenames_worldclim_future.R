# test that the files names generated for worldclim present do point to a valid
# file
set.seed(123)
test_that("filenames_worldclim_future are correct", {
  skip_if_offline()
  datasets <- c(
    "ACCESS-CM2", "BCC-CSM2-MR", "CMCC-ESM2", "EC-Earth3-Veg", "FIO-ESM-2-0",
    "GFDL-ESM4", "GISS-E2-1-G", "HadGEM3-GC31-LL", "INM-CM5-0", "IPSL-CM6A-LR",
    "MIROC6", "MPI-ESM1-2-HR", "MRI-ESM2-0", "UKESM1-0-LL"
  )
  scenarios <- c("ssp126", "ssp245", "ssp370", "ssp585")
  resolutions <- c("10m", "5m", "2.5m", "0.5m")
  # annual variables
  variables <- c(paste0("bio", sprintf("%02d", 1:19)))

  target_datasets <- paste("WorldClim_2.1", datasets,
    sample(scenarios, length(datasets), replace = TRUE),
    resolutions,
    sep = "_"
  )
  # remove combinations for which there are no data
  target_datasets <- target_datasets[
    !(grepl("FIO-ESM-2-0_ssp370", x = target_datasets) |
    grepl("GFDL-ESM4_ssp245", x = target_datasets) |
    grepl("GFDL-ESM4_ssp585", x = target_datasets) |
    grepl("HadGEM3-GC31-LL_ssp370", x = target_datasets))]

  for (i in seq_len(length(target_datasets))) {
    bio_files <- filenames_worldclim_future(
      dataset = target_datasets[i],
      bio_var = sample(variables, 1)
    )
    expect_true(url_is_valid(bio_files[sample(1:4, 1)]))
  }
  # monthly variables
  variables <- c(
    paste0("temperature_min_", sprintf("%02d", 1:12)),
    paste0("temperature_max_", sprintf("%02d", 1:12)),
    paste0("precipitation_", sprintf("%02d", 1:12))
  )

  for (i in seq_len(length(target_datasets))) {
    bio_files <- filenames_worldclim_future(
      dataset = target_datasets[i],
      bio_var = sample(variables, 1)
    )
    expect_true(url_is_valid(bio_files[sample(1:4, 1)]))
  }
})
