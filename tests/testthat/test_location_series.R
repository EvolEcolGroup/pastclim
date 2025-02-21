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

test_that("location_series", {
  # using standard dataset
  locations <- data.frame(
    name = c("A", "B", "C", "D"),
    longitude = c(0, 90, -120, -7), latitude = c(20, 45, 60, 37)
  )

  locations_ts <- location_series(
    x = locations[, c("longitude", "latitude")],
    bio_variables = c("bio01", "bio12"),
    dataset = "Example"
  )
  expect_true(nrow(locations_ts) == 20)

  # now check with arbitrary coordinate names
  locations_coords <- locations
  names(locations_coords)[c(2, 3)] <- c("x.long", "y.lat")
  locations_ts_coords <- location_series(
    x = locations_coords,
    coords = c("x.long", "y.lat"),
    bio_variables = c("bio01", "bio12"),
    dataset = "Example"
  )
  expect_equal(
    locations_ts[, c("bio01", "bio12")],
    locations_ts_coords[, c("bio01", "bio12")]
  )

  locations_ts <- location_series(
    x = locations[, c("longitude", "latitude")],
    time_bp = c(-20000, -10000, -5000),
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
  expect_true("name" %in% names(locations_ts))

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
      x = locations[, c("longitude", "name")],
      bio_variables = c("bio01", "bio12"),
      dataset = "Example"
    ),
    "There are no recognised coordinate columns"
  )


  # now use a custom dataset
  example_filename <- getOption("pastclim.dataset_list")$file_name[
    getOption("pastclim.dataset_list")$dataset == "Example"
  ][1] # nolint
  path_to_example_nc <- system.file("/extdata/", example_filename,
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

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
