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

test_that("buffer keeps coordinates, names and times", {
  locations <- data.frame(
    name = c("A", "B", "C", "D"),
    longitude = c(0, 90, -120, -9), latitude = c(20, 45, 60, 37),
    time_bp = c(0, -10000, -20000, -10000)
  )
  this_series <- region_series(
    bio_variables = c("bio01", "bio12"),
    dataset = "Example"
  )
  this_climate <- location_slice_from_region_series(
    x = locations, region_series = this_series, buffer = TRUE
  )
  expect_identical(this_climate$name, locations$name)
  expect_identical(this_climate$longitude, locations$longitude)
  expect_identical(this_climate$latitude, locations$latitude)
  expect_identical(this_climate$time_bp, locations$time_bp)
  expect_identical(this_climate$time_bp_slice, locations$time_bp)
  expect_false(is.na(this_climate[1, "bio01"]))
  # time_ce should also be preserved
  locations_ce <- locations
  locations_ce$time_ce <- locations_ce$time_bp + 1950
  locations_ce$time_bp <- NULL
  this_climate_ce <- location_slice_from_region_series(
    x = locations_ce, region_series = this_series, buffer = TRUE
  )
  expect_identical(this_climate_ce$time_ce, locations_ce$time_ce)
  expect_equal(this_climate_ce$bio01, this_climate$bio01)
})

test_that("NAs in other columns do not trigger nn_interpol", {
  locations <- data.frame(
    name = c("A", "B", "C", "D"),
    longitude = c(0, 90, -120, -9), latitude = c(20, 45, 60, 37),
    time_bp = c(0, -10000, -20000, -10000)
  )
  this_series <- region_series(
    bio_variables = c("bio01", "bio12"),
    dataset = "Example"
  )
  this_climate <- location_slice_from_region_series(
    x = locations, region_series = this_series, nn_interpol = TRUE
  )
  locations_extra <- locations
  locations_extra$notes <- NA
  this_climate_extra <- location_slice_from_region_series(
    x = locations_extra, region_series = this_series, nn_interpol = TRUE
  )
  expect_equal(
    this_climate_extra[, c("bio01", "bio12")],
    this_climate[, c("bio01", "bio12")]
  )
  # also with a single variable
  this_climate_single <- location_slice_from_region_series(
    x = locations_extra,
    region_series = region_series(bio_variables = "bio01", dataset = "Example"),
    nn_interpol = TRUE
  )
  expect_equal(this_climate_single$bio01, this_climate$bio01)
})

test_that("location_slice_from_region_series works with cell numbers", {
  locations <- data.frame(
    longitude = c(0, 90, -9), latitude = c(20, 45, 37),
    time_bp = c(0, -10000, -10000)
  )
  this_series <- region_series(
    bio_variables = c("bio01", "bio12"),
    dataset = "Example"
  )
  cells <- terra::cellFromXY(
    this_series[[1]],
    as.matrix(locations[, c("longitude", "latitude")])
  )
  by_coords <- location_slice_from_region_series(
    x = locations, region_series = this_series, nn_interpol = TRUE
  )
  by_cells <- location_slice_from_region_series(
    x = cells, time_bp = locations$time_bp, region_series = this_series,
    nn_interpol = TRUE
  )
  expect_identical(by_cells$cell_number, cells)
  expect_equal(
    by_cells[, c("bio01", "bio12")],
    by_coords[, c("bio01", "bio12")]
  )
  # integer cell numbers are also accepted
  by_cells_int <- location_slice_from_region_series(
    x = as.integer(cells), time_bp = locations$time_bp,
    region_series = this_series, nn_interpol = TRUE
  )
  expect_equal(by_cells_int$bio01, by_cells$bio01)
  expect_error(
    location_slice_from_region_series(
      x = "a", time_bp = 0, region_series = this_series
    ),
    "x should be either a data.frame or a numeric vector"
  )
})

test_that("nn_interpol with biome keeps numeric variables numeric", {
  locations <- data.frame(
    name = c("A", "B", "C", "D"),
    longitude = c(0, 90, -120, -9), latitude = c(20, 45, 60, 37),
    time_bp = c(0, -10000, -20000, -10000)
  )
  this_series <- region_series(
    bio_variables = c("bio01", "bio12", "biome"),
    dataset = "Example"
  )
  for (this_buffer in c(FALSE, TRUE)) {
    this_climate <- location_slice_from_region_series(
      x = locations, region_series = this_series, nn_interpol = TRUE,
      buffer = this_buffer
    )
    expect_true(is.numeric(this_climate$bio01))
    expect_true(is.numeric(this_climate$bio12))
    expect_true(is.factor(this_climate$biome))
    expect_false(is.na(this_climate$bio01[4]))
    expect_false(is.na(this_climate$biome[4]))
  }
  # values for numeric variables should match those without biome
  this_climate_no_biome <- location_slice_from_region_series(
    x = locations,
    region_series = region_series(
      bio_variables = c("bio01", "bio12"),
      dataset = "Example"
    ),
    nn_interpol = TRUE, buffer = TRUE
  )
  expect_equal(this_climate$bio01, this_climate_no_biome$bio01)
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
