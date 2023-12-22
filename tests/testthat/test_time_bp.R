# set up data path for this test
data_path <- file.path(tempdir(), "pastclim_data")
unlink(data_path, recursive = TRUE) # it should not exist, but remove it just in case
# set data path
set_data_path(
  path_to_nc = data_path,
  ask = FALSE,
  write_config = FALSE,
  copy_example = TRUE
)
################################################################################

test_that("time_bp for SpatRaster", {
  # using standard dataset
  climate_slice <- region_slice(
    time_bp = c(-10000),
    bio_variables = c("bio01", "bio12"),
    dataset = "Example"
  )
  expect_true(all(time_bp(climate_slice) == c(-10000, -10000)))
  # the method will only work on a SpatRaster
  expect_error(time_bp("blah"), "unable to find an inherited method")

  # set the time units incorrectly to raw
  time(climate_slice) <- c(-20, -100)
  expect_error(time_bp(climate_slice), "^The time units of SpatRaster are not")

  # and now let's fix them back
  time_bp(climate_slice) <- c(-10000, -10000)
  expect_true(all(time_bp(climate_slice) == c(-10000, -10000)))
})

test_that("time_bp for SpatRasterDataset", {
  # using standard dataset
  climate_series <- region_series(
    bio_variables = c("bio01", "bio12"),
    dataset = "Example"
  )
  expect_true(all(time_bp(climate_series) == c(-20000, -15000, -10000, -5000, 0)))
  time_bp(climate_series) <- c(-20, -15, -10, -5, 0)
  expect_true(all(time(climate_series[1]) == c(1930, 1935, 1940, 1945, 1950)))
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
