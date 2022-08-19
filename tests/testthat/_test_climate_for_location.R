test_that("climate_for_time_slice", {
  # using standard dataset
  path_to_example_nc <- system.file("/extdata/", package = "pastclim")
  locations <- data.frame(
    longitude = c(0, 90, -120, -7), latitude = c(20, 45, 60, 37),
    time_bp = c(0, -10000, -20000, -10000)
  )

  this_climate <- climate_for_locations(
    x = locations[, c("longitude", "latitude")],
    time_bp = locations$time_bp, bio_variables = c("bio01", "bio12"),
    dataset = "Example", nn_interpol = FALSE, path_to_nc = path_to_example_nc
  )
  expect_false(is.na(this_climate[1, "bio01"]))
  expect_true(is.na(this_climate[3, "bio01"]))
  expect_true(is.na(this_climate[4, "bio01"]))
  # test nn_interpolation
  this_climate <- climate_for_locations(
    x = locations[, c("longitude", "latitude")],
    time_bp = locations$time_bp, bio_variables = c("bio01", "bio12"),
    dataset = "Example", nn_interpol = TRUE, path_to_nc = path_to_example_nc
  )
  expect_false(is.na(this_climate[1, "bio01"]))
  expect_true(is.na(this_climate[3, "bio01"]))
  expect_false(is.na(this_climate[4, "bio01"]))

  # now test if we try a variable that is not available
  expect_error(
    climate_for_locations(
      x = locations[, c("longitude", "latitude")],
      time_bp = locations$time_bp, bio_variables = c("bio01", "bio19"),
      dataset = "Example", nn_interpol = FALSE, path_to_nc = path_to_example_nc
    ),
    "bio19 not available"
  )
  expect_error(
    climate_for_locations(
      x = locations[, c("longitude", "latitude")],
      time_bp = locations$time_bp, bio_variables = c("bio01", "bio19", "bio20"),
      dataset = "Example", nn_interpol = FALSE, path_to_nc = path_to_example_nc
    ),
    "bio19, bio20 not available"
  )

  # now test if we try to use a variable that we have not downloaded yet
  expect_error(
    climate_for_locations(
      x = locations[, c("longitude", "latitude")],
      time_bp = locations$time_bp, bio_variables = c("bio01", "bio12"),
      dataset = "Krapp2021", nn_interpol = FALSE,
      path_to_nc = path_to_example_nc
    ),
    "variable \\(bio01, bio12\\) not yet downloaded"
  )

  # now treat it as if it was a custom dataset
  path_to_example_nc <- system.file("/extdata/example_climate.nc",
    package = "pastclim"
  )
  this_climate <- climate_for_locations(
    x = locations[, c("longitude", "latitude")],
    time_bp = locations$time_bp, bio_variables = c("BIO1", "BIO12"),
    dataset = "custom", nn_interpol = FALSE, path_to_nc = path_to_example_nc
  )
  expect_false(is.na(this_climate[1, "BIO1"]))
  expect_true(is.na(this_climate[3, "BIO1"]))
  expect_true(is.na(this_climate[4, "BIO1"]))
  # if we try to use a variable that does not exist
  expect_error(
    climate_for_locations(
      x = locations[, c("longitude", "latitude")],
      time_bp = locations$time_bp, bio_variables = c("BIO1", "BIO22"),
      dataset = "custom", nn_interpol = FALSE, path_to_nc = path_to_example_nc
    ),
    "variable \\(BIO22\\) not present in the file"
  )
  # if we try to use a file that does not exist
  expect_error(
    climate_for_locations(
      x = locations[, c("longitude", "latitude")],
      time_bp = locations$time_bp, bio_variables = c("BIO1", "BIO22"),
      dataset = "custom", nn_interpol = FALSE, path_to_nc = "/foo"
    ),
    "file /foo does not exist"
  )
})
