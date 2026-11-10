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

# create a zip file mimicking the WorldClim archive for a monthly variable,
# with tifs for the given months (band value equal to the month)
make_wc_zip <- function(months) {
  zip_dir <- tempfile("wc_zip")
  dir.create(zip_dir)
  for (m in months) {
    r <- terra::rast(
      nrows = 2, ncols = 2,
      xmin = 0, xmax = 2, ymin = 0, ymax = 2, crs = "lonlat"
    )
    terra::values(r) <- m
    terra::writeRaster(r, file.path(
      zip_dir,
      sprintf("wc2.1_10m_prec_%02d.tif", m)
    ))
  }
  zip_file <- tempfile(fileext = ".zip")
  old_wd <- setwd(zip_dir)
  on.exit(setwd(old_wd))
  utils::zip(zip_file, list.files(zip_dir), flags = "-q")
  zip_file
}

test_that("download_worldclim_present builds the vrt files", {
  skip_if(Sys.which("zip") == "")
  zip_file <- make_wc_zip(1:12)
  local_mocked_bindings(
    curl_download = function(url, destfile, ...) {
      file.copy(zip_file, destfile, overwrite = TRUE)
    },
    .package = "curl"
  )
  dataset <- "WorldClim_2.1_10m"
  this_meta <- get_var_meta("precipitation_01", dataset)
  download_worldclim_present(
    dataset = dataset, bio_var = "precipitation_01",
    filename = file.path(get_data_path(), this_meta$file_name)
  )
  prec_07 <- region_series(
    bio_variables = "precipitation_07",
    dataset = dataset
  )
  expect_equal(as.numeric(terra::values(prec_07$precipitation_07)[1, ]), 7)
})

test_that("download_worldclim_present detects missing files in the zip", {
  skip_if(Sys.which("zip") == "")
  zip_file <- make_wc_zip(c(1:5, 7:12))
  local_mocked_bindings(
    curl_download = function(url, destfile, ...) {
      file.copy(zip_file, destfile, overwrite = TRUE)
    },
    .package = "curl"
  )
  dataset <- "WorldClim_2.1_10m"
  this_meta <- get_var_meta("precipitation_01", dataset)
  expect_error(
    download_worldclim_present(
      dataset = dataset, bio_var = "precipitation_01",
      filename = file.path(get_data_path(), this_meta$file_name)
    ),
    "some files are missing from the downloaded archive"
  )
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
