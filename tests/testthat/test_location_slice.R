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

  # using a data frame of locations and a separate vector of
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

  this_climate_buffer <- location_slice(
    x = locations[, c("longitude", "latitude")],
    time_bp = locations$time_bp, bio_variables = c("bio01", "bio12"),
    dataset = "Example",
    buffer = TRUE
  )
  expect_false(is.na(this_climate_buffer[1, "bio01"]))
  expect_true(is.na(this_climate_buffer[3, "bio01"]))
  expect_false(is.na(this_climate_buffer[4, "bio01"]))
  # the underwater location should return the same value with nn_interpol and
  # buffer but the other two values should differ
  expect_false(this_climate[1, "bio01"] == this_climate_buffer[1, "bio01"])
  expect_false(this_climate[2, "bio01"] == this_climate_buffer[2, "bio01"])
  expect_true(this_climate[4, "bio01"] == this_climate_buffer[4, "bio01"])

  # now use biome
  this_climate_biome <- location_slice(
    x = locations[, c("longitude", "latitude")],
    time_bp = locations$time_bp, bio_variables = c("bio01", "bio12", "biome"),
    dataset = "Example", nn_interpol = TRUE
  )
  # checked value by hand
  expect_true(as.numeric(this_climate_biome$biome[4]) == 18)

  # now use the full dataframe for pretty labelling
  this_climate_df <- location_slice(
    x = locations,
    bio_variables = c("bio01", "bio12"),
    dataset = "Example", nn_interpol = TRUE
  )
  expect_equal(
    this_climate_df[, c("bio01", "bio12")],
    this_climate[, c("bio01", "bio12")]
  )

  # check alternative coordinate names
  # now use the full dataframe for pretty labelling
  locations_coords <- locations
  names(locations_coords)[c(2, 3)] <- c("x", "y")
  this_climate_coords <- location_slice(
    x = locations_coords,
    bio_variables = c("bio01", "bio12"),
    dataset = "Example", nn_interpol = TRUE
  )
  expect_equal(
    this_climate_df[, c("bio01", "bio12")],
    this_climate_coords[, c("bio01", "bio12")]
  )

  # now set to arbitrary names
  names(locations_coords)[c(2, 3)] <- c("x.long", "y.lat")
  this_climate_coords <- location_slice(
    x = locations_coords,
    coords = c("x.long", "y.lat"),
    bio_variables = c("bio01", "bio12"),
    dataset = "Example", nn_interpol = TRUE
  )
  expect_equal(
    this_climate_df[, c("bio01", "bio12")],
    this_climate_coords[, c("bio01", "bio12")]
  )

  # check errors if we don't set up correctly with a dataframe
  # give time in both x and time_bp
  expect_error(this_climate_df <- location_slice(
    x = locations, time_bp = locations$time_bp,
    bio_variables = c("bio01", "bio12"),
    dataset = "Example", nn_interpol = TRUE
  ), "times should either be given as a column")
  # fail to give time when giving only locations
  expect_error(this_climate_df <- location_slice(
    x = locations[, c("longitude", "latitude")],
    bio_variables = c("bio01", "bio12"),
    dataset = "Example", nn_interpol = TRUE
  ), "missing times: they should either ")
  # dataframe with missing coordinates
  expect_error(this_climate_df <- location_slice(
    x = locations[, c("longitude", "time_bp")],
    bio_variables = c("bio01", "bio12"),
    dataset = "Example", nn_interpol = TRUE
  ), "There are no recognised coordinate columns")

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
    regexp = "variable\\(s\\) \\(bio01, bio12\\) not yet downloaded"
  )

  # now test a custom dataset
  example_filename <- getOption("pastclim.dataset_list")$file_name[
    getOption("pastclim.dataset_list")$dataset == "Example"
  ][1] # nolint
  path_to_example_nc <- system.file("/extdata/", example_filename,
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
  expect_true(identical(
    this_climate[, -c(1:3)],
    this_climate_timeoff[, -c(1:3)]
  ))

  # now do the same with time_ce
  locations_time_ce <- data.frame(
    longitude = c(0, 90, -120, -9), latitude = c(20, 45, 60, 37),
    time_ce = c(0, -9750, -20375, -10475) + 1950
  )
  this_climate_time_ce <- location_slice(
    x = locations_time_ce[, c("longitude", "latitude")],
    time_ce = locations_time_ce$time_ce, bio_variables = c("bio01", "bio12"),
    dataset = "Example", nn_interpol = TRUE
  )
  expect_true(
    all(
      this_climate_time_ce$time_ce == this_climate_timeoff$time_bp + 1950
    )
  )
  # using a data.frame
  this_climate_time_ce_df <- location_slice(
    x = locations_time_ce,
    bio_variables = c("bio01", "bio12"),
    dataset = "Example", nn_interpol = TRUE
  )


  # test a single variable
  location_slice_single <- location_slice(
    x = locations_time_ce[, c("longitude", "latitude")],
    time_ce = locations_time_ce$time_ce, bio_variables = "bio01",
    dataset = "Example"
  )

  location_slice_single <- location_slice(
    x = locations_time_ce[, c("longitude", "latitude")],
    time_ce = locations_time_ce$time_ce, bio_variables = "biome",
    dataset = "Example"
  )
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
