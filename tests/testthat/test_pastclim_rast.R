# this file tests the setting and getting of metadata from a vrt file
# we work in the temp directory

skip_on_cran()
# the gdal utilities are not properly installed on CRANs linux server
test_that("pastclim_rast handles vrt correctly", {
  vrt_path <- file.path(tempdir(), "test.vrt")
  tif_files <- list.files(
    system.file("extdata/CHELSA_bio01", package = "pastclim"),
    full.names = TRUE
  )
  if (file.exists(vrt_path)) {
    file.remove(vrt_path)
  }
  sf::gdal_utils(
    util = "buildvrt",
    source = tif_files,
    destination = vrt_path,
    options = c("-separate")
  )

  bio_var_orig <- "band_name_1"
  bio_var_pastclim <- "bio01"
  time_vector <- c(0, -10, -1000)
  bio_longname <- "annual mean temperature"
  bio_units <- "degrees Celsius"
  # set metadata
  expect_true(vrt_set_meta(vrt_path, bio_var_orig, time_vector))
  vrt_rast <- pastclim_rast(
    x = vrt_path, bio_var_orig = bio_var_orig,
    bio_var_pastclim = bio_var_pastclim,
    var_longname = bio_longname,
    var_units = bio_units
  )

  # check raster metadata
  expect_identical(varnames(vrt_rast), bio_var_pastclim)
  expect_identical(
    names(vrt_rast),
    paste(bio_var_pastclim, time_vector, sep = "_")
  )
  expect_identical(time_bp(vrt_rast), time_vector)
  expect_identical(longnames(vrt_rast), bio_longname)
  expect_identical(units(vrt_rast), rep(bio_units, nlyr(vrt_rast)))

  # error if we ask for the
  expect_error(
    vrt_rast <- pastclim_rast(
      x = vrt_path, bio_var_orig = "bio95",
      bio_var_pastclim = bio_var_pastclim,
      var_longname = bio_longname,
      var_units = bio_units
    ),
    "the file "
  )
})

test_that("pastclim_rast handles nc correctly", {
  example_filename <- getOption("pastclim.dataset_list")$file_name[
    getOption("pastclim.dataset_list")$dataset == "Example"
  ][1] # nolint
  path_to_example_nc <- system.file("/extdata/", example_filename,
    package = "pastclim"
  )
  bio_var_orig <- "BIO1"
  bio_var_pastclim <- "bio01"
  time_vector <- c(-20000, -15000, -10000, -5000, 0)
  bio_longname <- "annual mean temperature"
  bio_units <- "degrees Celsius"
  nc_rast <- pastclim_rast(path_to_example_nc, bio_var_orig, bio_var_pastclim)
  # check raster metadata
  expect_identical(varnames(nc_rast), bio_var_pastclim)
  expect_identical(
    names(nc_rast),
    paste(bio_var_pastclim, time_vector, sep = "_")
  )
  expect_identical(time_bp(nc_rast), time_vector)
  expect_identical(longnames(nc_rast), bio_longname)
  expect_identical(units(nc_rast), rep(bio_units, nlyr(nc_rast)))
})
