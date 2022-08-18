test_that("climate_for_time_slice", {
  # using standard dataset
  path_to_example_nc <- system.file("/extdata/example_climate.nc", package = "pastclim")
  
  climate_region <- region_series(c(-20000,-10000), c("bio01", "bio12"),
                         "Example")
  expect_true(inherits(climate_region, "SpatRasterDataset"))
  expect_true(all(names(climate_region)==c("bio01", "bio12")))
  expect_true(all(terra::nlyr(climate_region)==c(2,2)))
  # do the same for a custom dataset
  climate_region <- region_series(c(-20000,-10000), c("BIO1", "BIO10"),
                                  "custom",path_to_nc = path_to_example_nc)
  expect_true(inherits(climate_region, "SpatRasterDataset"))
  expect_true(all(names(climate_region)==c("BIO1", "BIO10")))
  expect_true(all(terra::nlyr(climate_region)==c(2,2)))  
  
  # if we try to use a variable that does not exist
  expect_error(region_series(c(-20000,-10000), c("bio01", "bio19"), "Example"),
               "bio19 not available")
  expect_error(region_series(c(-20000,-10000), c("BIO1", "bio19"),"custom",
                             path_to_nc = path_to_example_nc),
               "variable \\(bio19\\) not")
  
  # if we try to use a variable that we have not downloaded yet
  expect_error(region_series(c(-20000,-10000), c("bio01", "bio19"), "Krapp2021"
  ), "^variable \\(bio01, bio19\\) not yet downloaded")

  # if we try to use a file that does not exist
  expect_error(region_series(c(-20000,-10000), c("BIO1", "BIO12"), "custom",
    path_to_nc = "./foo"
  ), "path_to_nc does not point to a file")
})
