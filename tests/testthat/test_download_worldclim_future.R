# set up data path for this test
data_path <- file.path(tempdir(), "pastclim_data")
# it should not exist, but remove it just in case
unlink(data_path, recursive = TRUE)
# set data path
set_data_path(
  path_to_nc = data_path,
  ask = FALSE,
  write_config = FALSE,
  copy_example = TRUE
)
################################################################################

# mock the download of the WorldClim tifs by writing small local rasters, with
# band b of time step t set to b + 100 * t
mock_multi_download <- function(urls, destfiles, ...) {
  for (i in seq_along(destfiles)) {
    n_bands <- 12
    if (grepl("bioc", urls[i])) {
      n_bands <- 19
    }
    r <- terra::rast(
      nrows = 2, ncols = 2, nlyrs = n_bands,
      xmin = 0, xmax = 2, ymin = 0, ymax = 2, crs = "lonlat"
    )
    terra::values(r) <- matrix(seq_len(n_bands) + 100 * i,
      nrow = 4, ncol = n_bands, byrow = TRUE
    )
    terra::writeRaster(r, destfiles[i], overwrite = TRUE)
  }
  data.frame(success = rep(TRUE, length(destfiles)))
}

test_that("download_worldclim_future creates correctly named vrt files", {
  local_mocked_bindings(multi_download = mock_multi_download, .package = "curl")
  dataset <- "WorldClim_2.1_ACCESS-CM2_ssp126_10m"
  for (this_var in c("precipitation_01", "bio01")) {
    this_meta <- get_var_meta(this_var, dataset)
    download_worldclim_future(
      dataset = dataset, bio_var = this_var,
      filename = file.path(get_data_path(), this_meta$file_name)
    )
    expect_true(file.exists(file.path(get_data_path(), this_meta$file_name)))
  }
  # all monthly variables should now be available
  monthly_vars <- paste0("precipitation_", sprintf("%02d", 1:12))
  expect_true(all(monthly_vars %in% get_downloaded_datasets()[[dataset]]))
  # and they should be readable, with the correct band and times
  prec_06 <- region_series(
    bio_variables = "precipitation_06",
    dataset = dataset
  )
  expect_equal(time_bp(prec_06), c(2030, 2050, 2070, 2090) - 1950)
  expect_equal(
    as.numeric(terra::values(prec_06$precipitation_06)[1, ]),
    6 + 100 * (1:4)
  )
  bio_19 <- region_series(bio_variables = "bio19", dataset = dataset)
  expect_equal(
    as.numeric(terra::values(bio_19$bio19)[1, ]),
    19 + 100 * (1:4)
  )
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
