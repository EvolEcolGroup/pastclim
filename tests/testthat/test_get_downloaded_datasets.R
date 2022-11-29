# set up data path for this test
data_path <- file.path(tempdir(),"pastclim_data")
unlink(data_path, recursive = TRUE) # it should not exist, but remove it just in case
# set data path
set_data_path(path_to_nc = data_path,
              ask = FALSE,
              write_config = FALSE,
              copy_example = TRUE)
################################################################################


testthat::test_that("get_downloaded_datasets", {
  path_to_example_nc <- system.file("/extdata/", package = "pastclim")
  # there is only the Example dataset available
  expect_true(length(get_downloaded_datasets(data_path = path_to_example_nc))
  == 1)
  # return an empty list if there are no files
  expect_true(length(get_downloaded_datasets(data_path = "./foo")) == 0)
  # check that we have downloaded a variable
  expect_true(check_var_downloaded("bio01", "Example"))
  # raise error if the variable is not available
  expect_error(
    check_var_downloaded("npp", "Example"),
    "^npp not available"
  )
  # in the future, use skip_if to avoid this test if we already have this variable installed
  expect_error(
    check_var_downloaded("cloudiness_01", "Krapp2021"),
    "^variable"
  )
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
