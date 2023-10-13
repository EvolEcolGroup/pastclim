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
example_nc_filename <- unique(getOption("pastclim.dataset_list")$file_name[
  getOption("pastclim.dataset_list")$dataset == "Example"
])
path_to_example_nc <- file.path(get_data_path(), example_nc_filename)
path_to_broken_nc <- file.path(get_data_path(), "broken.nc")
################################################################################

test_that("validate_nc for custom file", {
  # error for non-existing file
  expect_error(
    validate_nc("blah/blah"),
    "The provided path_to_nc"
  )
  # copy example file and start changing it for tests
  file.copy(
    path_to_example_nc,
    path_to_broken_nc
  )
  # validate before breaking
  expect_true(validate_nc(path_to_nc = path_to_broken_nc))
  # remove long name
  nc_in <- ncdf4::nc_open(path_to_broken_nc, write = TRUE)
  ncdf4::ncatt_put(
    nc = nc_in,
    varid = "BIO1",
    attname = "long_name",
    attval = "",
    definemode = TRUE
  )
  ncdf4::nc_close(nc_in)
  expect_error(
    validate_nc(path_to_nc = path_to_broken_nc),
    "for BIO1 the longname is not given"
  )
  # get a new version to edit the time units
  file.copy(path_to_example_nc,
    path_to_broken_nc,
    overwrite = TRUE
  )
  nc_in <- ncdf4::nc_open(path_to_broken_nc, write = TRUE)
  ncdf4::ncatt_put(
    nc = nc_in,
    varid = "time",
    attname = "units",
    attval = "days since 1970",
    definemode = TRUE
  )
  ncdf4::nc_close(nc_in)
  expect_error(
    validate_nc(path_to_nc = path_to_broken_nc),
    "the time units should start with"
  )
  nc_in <- ncdf4::nc_open(path_to_broken_nc, write = TRUE)
  ncdf4::ncatt_put(
    nc = nc_in,
    varid = "time",
    attname = "units",
    attval = "years since present",
    definemode = TRUE
  )
  ncdf4::nc_close(nc_in)
  expect_error(
    validate_nc(path_to_nc = path_to_broken_nc),
    "the time units are "
  )
  # and now fix it
  nc_in <- ncdf4::nc_open(path_to_broken_nc, write = TRUE)
  ncdf4::ncatt_put(
    nc = nc_in,
    varid = "time",
    attname = "units",
    attval = "years since 1970",
    definemode = TRUE
  )
  ncdf4::nc_close(nc_in)
  expect_true(validate_nc(path_to_nc = path_to_broken_nc))
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
