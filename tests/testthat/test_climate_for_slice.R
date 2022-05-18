test_that("climate_for_time_slice", {
  # using standard dataset
  path_to_example_nc <- system.file("/extdata/", package = "pastclim")
  expect_true(inherits(climate_for_time_slice(-20000, c("bio01", "bio12"),
                                              "Example",
    path_to_nc = path_to_example_nc
  ), "SpatRaster"))
  # if we try to use a variable that does not exist
  expect_error(climate_for_time_slice(-20000, c("bio01", "bio19"), "Example",
    path_to_nc = path_to_example_nc
  ), "bio19 not available")
  # if we try to use a variable that we have not downloaded yet
  expect_error(climate_for_time_slice(-20000, c("bio01", "bio19"), "Krapp2021",
    path_to_nc = path_to_example_nc
  ), "^variable \\(bio01, bio19\\) not yet downloaded")

  # now treat it as if it was a custom dataset
  path_to_example_nc <- system.file("/extdata/example_climate.nc",
                                    package = "pastclim")
  expect_true(inherits(climate_for_time_slice(-20000, c("BIO1", "BIO12"),
                                              "custom",
                                              path_to_nc = path_to_example_nc
  ), "SpatRaster"))
  # if we try to use a variable that does not exist
  expect_error(climate_for_time_slice(-20000, c("BIO01", "lai"), "custom",
    path_to_nc = path_to_example_nc
  ), "variable \\(BIO01, lai\\) not present in the file")
  # if we try to use a file that does not exist
  expect_error(climate_for_time_slice(-20000, c("BIO1", "BIO12"), "custom",
    path_to_nc = "./foo"
  ), "file ./foo does not exist")
})
