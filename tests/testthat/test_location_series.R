test_that("time_series_for_location", {
  # using standard dataset
  locations <- data.frame(name=c("A","B","C","D"),
    longitude = c(0, 90, -120, -7), latitude = c(20, 45, 60, 37)
  )

  locations_ts <- location_series(
    x = locations[, c("longitude", "latitude")],
    bio_variables = c("bio01", "bio12"),
    dataset = "Example"
  )
  expect_true(nrow(locations_ts) == 20)
  
  locations_ts <- location_series(
    x = locations[, c("longitude", "latitude")],
    time_bp = c(-20000,-10000,-5000),
    bio_variables = c("bio01", "bio12"),
    dataset = "Example"
  )  
  expect_true(nrow(locations_ts) == 12)

  locations_ts <- location_series(
    x = locations[, c("longitude", "latitude")],
    time_bp = list(min = -10000, max = -5000),
    bio_variables = c("bio01", "bio12"),
    dataset = "Example"
  )  
  expect_true(nrow(locations_ts) == 8)

  # test one location only
  locations_ts <- location_series(
    x = locations[1, c("longitude", "latitude")],
    bio_variables = c("bio01"),
    dataset = "Example"
  ) 
  
  # test with names
  locations_ts <- location_series(
    x = locations,
    bio_variables = c("bio01", "bio12"),
    dataset = "Example"
  )
  expect_true("name"%in%names(locations_ts))
  
  # now test if we try a variable that is not available
  expect_error(
    location_series(
      x = locations[, c("longitude", "latitude")],
      bio_variables = c("bio01", "bio19"),
      dataset = "Example"
    ),
    "bio19 not available"
  )
  expect_error(
    location_series(
      x = locations[, c("longitude", "latitude")],
      bio_variables = c("bio01", "bio19", "bio20"),
      dataset = "Example"
    ),
    "bio19, bio20 not available"
  )

  # now test if we try to use a variable that we have not downloaded yet
  expect_error(
    location_series(
      x = locations[, c("longitude", "latitude")],
      bio_variables = c("bio01", "bio12"),
      dataset = "Krapp2021"
    ),
    "variable \\(bio01, bio12\\) not yet downloaded"
  )

  # test if we use a dataframe missing some coordinates
  expect_error(
    location_series(
      x = locations[, c("longitude","name")],
      bio_variables = c("bio01", "bio12"),
      dataset = "Example"
    ),
    "x should be a dataframe with"
  )  
  
  
  # now use a custom dataset
  path_to_example_nc <- system.file("/extdata/example_climate_v2.nc",
    package = "pastclim"
  )
  locations_ts <- location_series(
    x = locations[, c("longitude", "latitude")],
    bio_variables = c("BIO1", "BIO12"),
    dataset = "custom", path_to_nc = path_to_example_nc
  )
  expect_true(nrow(locations_ts) == 20)
  # if we try to use a variable that does not exist
  expect_error(
    location_series(
      x = locations[, c("longitude", "latitude")],
      bio_variables = c("BIO1", "BIO22"),
      dataset = "custom", path_to_nc = path_to_example_nc
    ),
    "variable \\(BIO22\\) not present in the file"
  )
  # if we try to use a file that does not exist
  expect_error(
    location_series(
      x = locations[, c("longitude", "latitude")],
      bio_variables = c("BIO1", "BIO22"),
      dataset = "custom", path_to_nc = "/foo"
    ),
    "path_to_nc does not point to a file"
  )
})
