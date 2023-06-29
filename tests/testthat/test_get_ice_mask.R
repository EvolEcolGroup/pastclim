# set up data path for this test
data_path <- file.path(tempdir(),"pastclim_data")
unlink(data_path, recursive = TRUE) # it should not exist, but remove it just in case
# set data path
set_data_path(path_to_nc = data_path,
              ask = FALSE,
              write_config = FALSE,
              copy_example = TRUE)
################################################################################

testthat::test_that("get ice mask", {
  # get multiple times
  my_times <- c(-10000,0)
  this_mask <- get_ice_mask(time_bp=my_times, dataset="Example")
  expect_true(terra::nlyr(this_mask)==2)
  expect_true(all(time_bp(this_mask)==my_times))
  # get single time
  my_times <- c(-20000)
  this_mask <- get_ice_mask(time_bp=my_times, dataset="Example")
  expect_true(terra::nlyr(this_mask)==1)
  expect_true(all(time_bp(this_mask)==my_times))
  # full series
  this_mask <- get_ice_mask(dataset="Example")
  expect_true(all(time_bp(this_mask)==get_time_bp_steps(dataset="Example")))
  # incorrect dataset
  expect_error(get_ice_mask(dataset="blah"),"this function only works")
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
