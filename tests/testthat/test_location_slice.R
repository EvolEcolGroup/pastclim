test_that("location_slice", {
  # using standard dataset
  locations <- data.frame(
    longitude = c(0, 90, -120, -9), latitude = c(20, 45, 60, 37),
    time_bp = c(0, -10000, -20000, -10000)
  )

  this_climate <- location_slice(
    x = locations[, c("longitude", "latitude")],
    time_bp = locations$time_bp, bio_variables = c("bio01", "bio12"),
    dataset = "Example", nn_interpol = FALSE
  )
  expect_false(is.na(this_climate[1, "bio01"]))
  expect_true(is.na(this_climate[3, "bio01"]))
  expect_true(is.na(this_climate[4, "bio01"]))
  # test nn_interpolation
  this_climate <- location_slice(
    x = locations[, c("longitude", "latitude")],
    time_bp = locations$time_bp, bio_variables = c("bio01", "bio12"),
    dataset = "Example", nn_interpol = TRUE
  )
  expect_false(is.na(this_climate[1, "bio01"]))
  expect_true(is.na(this_climate[3, "bio01"]))
  expect_false(is.na(this_climate[4, "bio01"]))

  # now test if we try a variable that is not available
  expect_error(
    location_slice(
      x = locations[, c("longitude", "latitude")],
      time_bp = locations$time_bp, bio_variables = c("bio01", "bio19"),
      dataset = "Example", nn_interpol = FALSE
    ),
    "bio19 not available"
  )
  expect_error(
    location_slice(
      x = locations[, c("longitude", "latitude")],
      time_bp = locations$time_bp, bio_variables = c("bio01", "bio19", "bio20"),
      dataset = "Example", nn_interpol = FALSE
    ),
    "bio19, bio20 not available"
  )

  # now test if we try to use a variable that we have not downloaded yet
  expect_error(
    location_slice(
      x = locations[, c("longitude", "latitude")],
      time_bp = locations$time_bp, bio_variables = c("bio01", "bio12"),
      dataset = "Krapp2021", nn_interpol = FALSE
    ),
    "variable \\(bio01, bio12\\) not yet downloaded"
  )

  # now test a custom dataset
  path_to_example_nc <- system.file("/extdata/example_climate.nc",
    package = "pastclim"
  )
  this_climate <- location_slice(
    x = locations[, c("longitude", "latitude")],
    time_bp = locations$time_bp, bio_variables = c("BIO1", "BIO12"),
    dataset = "custom", nn_interpol = FALSE, path_to_nc = path_to_example_nc
  )
  expect_false(is.na(this_climate[1, "BIO1"]))
  expect_true(is.na(this_climate[3, "BIO1"]))
  expect_true(is.na(this_climate[4, "BIO1"]))
  # if we try to use a variable that does not exist
  expect_error(
    location_slice(
      x = locations[, c("longitude", "latitude")],
      time_bp = locations$time_bp, bio_variables = c("BIO1", "BIO22"),
      dataset = "custom", nn_interpol = FALSE, path_to_nc = path_to_example_nc
    ),
    "variable \\(BIO22\\) not present in the file"
  )
  # if we try to use a file that does not exist
  expect_error(
    location_slice(
      x = locations[, c("longitude", "latitude")],
      time_bp = locations$time_bp, bio_variables = c("BIO1", "BIO22"),
      dataset = "custom", nn_interpol = FALSE, path_to_nc = "/foo"
    ),
    "path_to_nc does not point to a file"
  )

  # now use times which are not the exact timesteps
  locations_timeoff <- data.frame(
    longitude = c(0, 90, -120, -9), latitude = c(20, 45, 60, 37),
    time_bp = c(0, -9750, -20375, -10475)
  )
  this_climate_timeoff <- location_slice(
    x = locations_timeoff[, c("longitude", "latitude")],
    time_bp = locations_timeoff$time_bp, bio_variables = c("bio01", "bio12"),
    dataset = "Example", nn_interpol = TRUE
  )
  # and compare it to the estimates from exact times (they should be the same!)
  this_climate <- location_slice(
    x = locations[, c("longitude", "latitude")],
    time_bp = locations$time_bp, bio_variables = c("bio01", "bio12"),
    dataset = "Example", nn_interpol = TRUE
  )
  expect_true(identical(this_climate[, -c(1:3)],
                        this_climate_timeoff[, -c(1:3)]))
})
