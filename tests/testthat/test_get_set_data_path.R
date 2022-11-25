test_that("set and get data path", {
  # set data path to temp dir
  set_data_path(tempdir())
  expect_true(file.exists(file.path(
    tools::R_user_dir("pastclim", "config"),
    "pastclim_data.txt"
  )))
  expect_equal(get_data_path(), tempdir())
  # give error if custom dir does not exist
  expect_error(set_data_path("blah/blah"),"blah")
  
  # use dir with spaces 
  new_path <- file.path(tempdir(),"/Users/pkgbuilds/Library/Application Support/org.R-project.R/R/pastclim")
  if (!dir.exists(new_path)){
    dir.create(new_path, recursive = TRUE)
  }
  set_data_path(new_path)
  expect_equal(get_data_path(), new_path)
  # now use the standard directory for the library
  set_data_path()
  expect_equal(get_data_path(), tools::R_user_dir("pastclim", "data"))
  # give error if custom dir does not exist
  expect_error(set_data_path("blah/blah"),"blah")
})
