# set up data path for this test
data_path <- file.path(tempdir(),"pastclim_data")
unlink(data_path, recursive = TRUE) # it should not exist, but remove it just in case
# set data path
set_data_path(path_to_nc = data_path,
              ask = FALSE,
              write_config = FALSE,
              copy_example = TRUE)
################################################################################

test_that("is_region_series returns correct values", {
  climate_region <- region_series(
    time_bp = list(min=-15000,max=0), c("bio01", "bio10", "bio12"),
    "Example"
  )
  expect_true(is_region_series(climate_region))
  expect_true(is_region_series(climate_region, strict = TRUE))

  # change the time for one variable
  time(climate_region[1], tstep="years")<-c(1,2,3,4)
  # the simple test should still pass, but the strict test should not
  expect_true(is_region_series(climate_region))
  expect_false(is_region_series(climate_region, strict = TRUE))

  # now remove a time step (all tests should fail)
  climate_region <- region_series(
    time_bp = list(min=-15000,max=0), c("bio01", "bio10", "bio12"),
    "Example"
  )
  climate_region[1] <- climate_region[1][[1:3]]
  expect_false(is_region_series(climate_region))
  expect_false(is_region_series(climate_region, strict = TRUE))
  
  # now give it a slice
  europe_climate_20k <- region_slice(
    time_bp = -20000,
    c("bio01", "bio10", "bio12"),
    dataset = "Example",
    ext = region_extent$Europe
  )
  expect_error(is_region_series(europe_climate_20k),
               "x should be a SpatRasterDataset")
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)

