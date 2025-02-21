# set up data path for this test
data_path <- file.path(tempdir(), "pastclim_data")
# it should not exist, but remove it just in case
unlink(data_path, recursive = TRUE)
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
    time_bp = locations$time_bp, region_series = this_series,
    nn_interpol = FALSE
  )
  expect_false(is.na(this_climate[1, "bio01"]))
  expect_true(is.na(this_climate[3, "bio01"]))
  expect_true(is.na(this_climate[4, "bio01"]))

  # this function is more thoroughly tested in locations_slice, which is a
  # wrapper around this function with added code to generate the region series
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
