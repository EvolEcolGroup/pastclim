# set up data path for this test
data_path <- file.path(tempdir(),"pastclim_data")
unlink(data_path, recursive = TRUE) # it should not exist, but remove it just in case
# set data path
set_data_path(path_to_nc = data_path,
              ask = FALSE,
              write_config = FALSE,
              copy_example = TRUE)
################################################################################

test_that("get_vars_for_dataset give appropriate errors", {
  expect_error(
    get_vars_for_dataset(dataset = "blah"),
    "'dataset' must be one of "
  )
  expect_error(
    get_vars_for_dataset(dataset = "Example", path_to_nc = "blah"),
    "path_to_nc should only be set"
  )
  expect_error(
    get_vars_for_dataset(dataset = "custom"),
    "path_to_nc should be set for"
  )
})

test_that("get_vars_for_dataset returns appropriate object", {
  vars <- get_vars_for_dataset(dataset = "Example")
  expect_true(inherits(vars,"character"))
  vars <- get_vars_for_dataset(dataset = "Example",
                               details = TRUE)
  expect_true(inherits(vars,"data.frame"))
})


test_that("get_vars_for_dataset for local file", {
  example_filename <- getOption("pastclim.dataset_list")$file_name[getOption("pastclim.dataset_list")$dataset=="Example"][1]
  path_to_example_nc <- system.file("/extdata/", example_filename,
                                    package = "pastclim"
  )
  vars <- get_vars_for_dataset(dataset = "custom", path_to_nc = path_to_example_nc)
  expect_true(inherits(vars,"character"))
  vars <- get_vars_for_dataset(dataset = "custom", path_to_nc = path_to_example_nc,
                               details = TRUE)
  expect_true(inherits(vars,"data.frame"))
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
