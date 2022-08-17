testthat::test_that("get_downloaded_datasets", {
  path_to_example_nc <- system.file("/extdata/", package = "pastclim")
  # there is only the Example dataset available
  expect_true(length(get_downloaded_datasets(path_to_nc = path_to_example_nc))
  == 1)
  # return an empty list if there are no files
  expect_true(length(get_downloaded_datasets(path_to_nc = "./foo")) == 0)
  # check that we have downloaded a variable
  expect_true(check_var_downloaded("bio01", "Example",
    path_to_nc = path_to_example_nc
  ))
  # raise error if the variable is not available
  expect_error(
    check_var_downloaded("npp", "Example", path_to_nc = path_to_example_nc),
    "^npp not available"
  )
  expect_error(
    check_var_downloaded("npp", "Krapp2021", path_to_nc = path_to_example_nc),
    "^variable"
  )
})
