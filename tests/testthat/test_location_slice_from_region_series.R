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

test_that("location_slice", {
  locations <- data.frame(
    name = c("A", "B", "C", "D"),
    longitude = c(0, 90, -120, -9), latitude = c(20, 45, 60, 37),
    time_bp = c(0, -10000, -20000, -10000)
  )

  this_series <- region_series(
    bio_variables = c("bio01", "bio12"),
    dataset = "Example"
  )

  # using a data frame of locations and a separate vector of
  this_climate <- location_slice_from_region_series(
    x = locations[, c("longitude", "latitude")],
    time_bp = locations$time_bp, region_series = this_series, nn_interpol = FALSE
  )
  expect_false(is.na(this_climate[1, "bio01"]))
  expect_true(is.na(this_climate[3, "bio01"]))
  expect_true(is.na(this_climate[4, "bio01"]))

  # this function is more thoroughly tested in locations_slice, which is a
  # wrapper around this function with added code to generate the region series
})

test_that("location_slice error handling", {
  
  # Load data
  locations <- data.frame(
    name = c("A", "B", "C", "D"),
    longitude = c(0, 90, -120, -9), latitude = c(20, 45, 60, 37),
    time_bp = c(0, -10000, -20000, -10000)
  )

  this_series <- region_series(
    bio_variables = c("bio01", "bio12"),
    dataset = "Example"
  )

  # Name-related errors
  name_error <- this_series
  names(name_error) <- c("1303", "\\")

  expect_error(location_slice_from_region_series(
    x = locations[, c("longitude", "latitude")],
    time_bp = locations$time_bp, region_series = name_error, 
    nn_interpol = FALSE
  ), "The subdatasets in 'region_series' must have valid names.")

  bio01 <- this_series[[1]]
  varnames(bio01) <- ""
  name_error <- sds(bio01, this_series[[2]])
  names(name_error) <- c("bio01", "bio12")

  expect_error(location_slice_from_region_series(
    x = locations[, c("longitude", "latitude")],
    time_bp = locations$time_bp, region_series = name_error, 
    nn_interpol = FALSE
  ), "'region_series' subdatasets must have valid varnames")

  # Time-related errors
  time_error <- locations
  time_error$time_ce <- seq(-500, -2000, length.out = 4)

  expect_error(location_slice_from_region_series(
    x = time_error,
    region_series = this_series, 
    nn_interpol = FALSE
  ), "in x, there should only be either a 'time_bp' column, or a 'time_ce' column")

  expect_error(location_slice_from_region_series(
    x = locations[, c("longitude", "latitude")],
    region_series = this_series, 
    nn_interpol = FALSE
  ), "missing times: they should either be given as a column of x, or as values for time_bp or time_ce")

  expect_error(location_slice_from_region_series(
    x = locations,
    time_bp = seq(-500, -2000, length.out = 4),
    region_series = this_series, 
    nn_interpol = FALSE
  ))

})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
