# start with a clean slate in case other tests set up the path
options(pastclim.data_path = NULL) # reset the option

test_that("get data path when config not present", {
  skip_if((file.exists(file.path(
    tools::R_user_dir("pastclim", "config"),
    "pastclim_data.txt"
  ))),"config file already exists on this system")
  # try to get path when none is set
  expect_message(null_data_path <- get_data_path())
  expect_null(null_data_path)
  # now do the same in silent mode
  expect_no_message(null_data_path <- get_data_path(silent = TRUE))
  expect_null(null_data_path)
})

test_that("set and get data path", {
  # now set the path in a subdirectory of tempdir
  data_path <- file.path(tempdir(),"pastclim_data")
  unlink(data_path, recursive = TRUE) # it should not exist, but remove it just in case
  # set data path
  expect_true(set_data_path(path_to_nc = data_path,
                ask = FALSE,
                write_config = FALSE,
                copy_example = FALSE))
  expect_equal(normalizePath(get_data_path()), normalizePath(data_path))
  unlink(data_path, recursive = TRUE) # clean up
  options(pastclim.data_path = NULL) # reset the option
  
  # use dir with spaces (as it is the case for the default data dir on MacOS)
  data_path <- file.path(tempdir(),"/Users/pkgbuilds/Library/Application Support/org.R-project.R/R/pastclim")
  unlink(data_path, recursive = TRUE) # it should not exist, but remove it just in case
  expect_true(set_data_path(path_to_nc = data_path,
                            ask = FALSE,
                            write_config = FALSE,
                            copy_example = FALSE))
  expect_equal(normalizePath(get_data_path()), normalizePath(data_path))
  # this should be empty
  expect_true(length(dir(data_path)) ==0)
  # now copy the data files
  options(pastclim.data_path = NULL) # reset the option
  
  expect_true(set_data_path(path_to_nc = data_path,
                            ask = FALSE,
                            write_config = FALSE,
                            copy_example = TRUE))
  # there should be a file now
  expect_true(length(dir(data_path)) == 1)
  unlink(data_path, recursive = TRUE) # clean up
})
