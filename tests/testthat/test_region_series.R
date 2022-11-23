test_that("region series", {
  # using standard dataset
  climate_region <- region_series(
    c(-20000, -10000), c("bio01", "bio12"),
    "Example"
  )
  expect_true(inherits(climate_region, "SpatRasterDataset"))
  expect_true(all(names(climate_region) == c("bio01", "bio12")))
  expect_true(all(terra::nlyr(climate_region) == c(2, 2)))

  # do the same for a custom dataset
  path_to_example_nc <- system.file("/extdata/example_climate_v2.nc",
                                    package = "pastclim")
  climate_region <- region_series(c(-20000, -10000), c("BIO1", "BIO10"),
    "custom",
    path_to_nc = path_to_example_nc
  )
  expect_true(inherits(climate_region, "SpatRasterDataset"))
  expect_true(all(names(climate_region) == c("BIO1", "BIO10")))
  expect_true(all(terra::nlyr(climate_region) == c(2, 2)))

  # if we try to use a variable that does not exist
  expect_error(
    region_series(c(-20000, -10000), c("bio01", "bio19"), "Example"),
    "bio19 not available"
  )
  expect_error(
    region_series(c(-20000, -10000), c("BIO1", "bio19"), "custom",
      path_to_nc = path_to_example_nc
    ),
    "variable \\(bio19\\) not"
  )

  # if we try to use a variable that we have not downloaded yet
  expect_error(region_series(c(-20000, -10000),
                             c("bio01", "bio19"),
                             "Krapp2021"),
               "^variable \\(bio01, bio19\\) not yet downloaded")

  # if we try to use a file that does not exist
  expect_error(region_series(c(-20000, -10000), c("BIO1", "BIO12"), "custom",
    path_to_nc = "./foo"
  ), "path_to_nc does not point to a file")

  # if we use time steps that do not exist
  expect_error(
    region_series(
      c(-19000, -10000), c("bio01", "bio12"),
      "Example"
    ),
    "time_bp should only include time steps available in the dataset"
  )
  
  # get all values
  climate_region <- region_series(bio_variables = c("bio01", "bio12"),
    dataset = "Example"
  )
  expect_true(all(terra::nlyr(climate_region) == c(5, 5)))
  
  # get all values
  climate_region <- region_series(
    time_bp = list(min=-13000,max=0), c("bio01", "bio12"),
    "Example"
  )
  expect_true(all(terra::nlyr(climate_region) == c(3, 3)))
})

test_that("ext on region series", {
  # this should work
  expect_error(region_series(
    time_bp = -20000,
    c("bio01", "bio10", "bio12"),
    dataset = "Example",
    ext = terra::ext(region_extent$Europe)
  ),NA)
  
  # this should raise an error
  expect_error(region_series(
    time_bp = -20000,
    c("bio01", "bio10", "bio12"),
    dataset = "Example",
    ext = "foo"
  ), "ext should be a ")
  
  # not enough elements
  ext<-c(-15, 70, 33)
  expect_error(region_series(
    time_bp = -20000,
    c("bio01", "bio10", "bio12"),
    dataset = "Example",
    ext = ext
  ), "ext should be a ")
  
  # but this works as it is long enough
  ext<-c(-15, 70, 33, 75)
  expect_error(region_series(
    time_bp = -20000,
    c("bio01", "bio10", "bio12"),
    dataset = "Example",
    ext = ext
  ), NA)  

  test_that("crop on region series", {

    # this should work
    expect_error(region_series(
      time_bp = -20000,
      c("bio01", "bio10", "bio12"),
      dataset = "Example",
      crop = terra::vect(region_outline$Eurasia)
    ),NA)    
    
    # this should raise an error
    expect_error(region_series(
      time_bp = -20000,
      c("bio01", "bio10", "bio12"),
      dataset = "Example",
      crop = "foo"
    ), "crop should be a ")
    
    # this should work
    expect_error(region_series(
      time_bp = -20000,
      c("bio01", "bio10", "bio12"),
      dataset = "Example",
      crop = region_outline$Eurasia),NA)  
    
  })
  
  
})
  
