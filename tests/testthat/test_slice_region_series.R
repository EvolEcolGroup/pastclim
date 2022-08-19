test_that("climate_for_time_slice", {
  climate_region <- region_series(c(-20000,-10000), c("bio01", "bio12"),
                         "Example")
  my_slice <- slice_region_series(climate_region, time_bp = -10000)
  expect_true(inherits(my_slice, "SpatRaster"))
  expect_true(length(my_slice)==1)
  expect_true(terra::nlyr(my_slice)==2)
  expect_true(all(varnames(my_slice)==c("bio01", "bio12")))
  # use a time step that does not exist
  expect_error(slice_region_series(climate_region, time_bp = -19000),
               "time_bp is not a time slice within the region series x")
  # use too many timesteps
  expect_error(slice_region_series(climate_region, time_bp = c(-10000,-20000)),
               "time_bp should be a single time step")
})
