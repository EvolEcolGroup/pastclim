test_that("time_series_for_location", {
  # using standard dataset
  path_to_example_nc <- system.file("/extdata/", package = "pastclim")
  locations <- data.frame(
    longitude = c(0, 90, -120, -7), latitude = c(20, 45, 60, 37),
    time_bp = c(0, -10000, -20000, -10000)
  )

  locations_ts <- time_series_for_locations(
    x = locations[, c("longitude", "latitude")],
    bio_variables = c("bio01", "bio12"),
    dataset = "Example", path_to_nc = path_to_example_nc
  )
  expect_true(nrow(locations_ts) == 20)
  # now test if we try a variable that is not available
  expect_error(
    time_series_for_locations(
      x = locations[, c("longitude", "latitude")],
      bio_variables = c("bio01", "bio19"),
      dataset = "Example", path_to_nc = path_to_example_nc
    ),
    "bio19 not available"
  )
  expect_error(
    time_series_for_locations(
      x = locations[, c("longitude", "latitude")],
      bio_variables = c("bio01", "bio19", "bio20"),
      dataset = "Example", path_to_nc = path_to_example_nc
    ),
    "bio19, bio20 not available"
  )

  # now test if we try to use a variable that we have not downloaded yet
  expect_error(
    time_series_for_locations(
      x = locations[, c("longitude", "latitude")],
      bio_variables = c("bio01", "bio12"),
      dataset = "Krapp2021", path_to_nc = path_to_example_nc
    ),
    "variable \\(bio01, bio12\\) not yet downloaded"
  )

  # now treat it as if it was a custom dataset
  path_to_example_nc <- system.file("/extdata/example_climate.nc",
                                    package = "pastclim")
  locations_ts <- time_series_for_locations(
    x = locations[, c("longitude", "latitude")],
    bio_variables = c("BIO1", "BIO12"),
    dataset = "custom", path_to_nc = path_to_example_nc
  )
  expect_true(nrow(locations_ts) == 20)
  # if we try to use a variable that does not exist
  expect_error(
    time_series_for_locations(
      x = locations[, c("longitude", "latitude")],
      bio_variables = c("BIO1", "BIO22"),
      dataset = "custom", path_to_nc = path_to_example_nc
    ),
    "variable \\(BIO22\\) not present in the file"
  )
  # if we try to use a file that does not exist
  expect_error(
    time_series_for_locations(
      x = locations[, c("longitude", "latitude")],
      bio_variables = c("BIO1", "BIO22"),
      dataset = "custom", path_to_nc = "/foo"
    ),
    "file /foo does not exist"
  )
})
