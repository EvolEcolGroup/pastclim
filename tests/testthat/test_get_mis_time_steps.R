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
################################################################################

test_that("get_mis_time_steps for standard dataset", {
  expect_equal(get_mis_time_steps(mis = "2", dataset = "Example"),
    c(-20000, -15000),
    ignore_attr = TRUE
  )
})

test_that("get_mis_time_steps for local file", {
  example_filename <- getOption("pastclim.dataset_list")$file_name[getOption("pastclim.dataset_list")$dataset == "Example"][1]
  path_to_example_nc <- system.file("/extdata/", example_filename,
    package = "pastclim"
  )
  expect_equal(
    get_mis_time_steps(
      mis = "2", dataset = "custom",
      path_to_nc = path_to_example_nc
    ),
    c(-20000, -15000),
    ignore_attr = TRUE
  )
})

test_that("get_mis_time_steps requires correct variables", {
  expect_error(
    get_mis_time_steps(
      mis = "blah", dataset = "custom",
      path_to_nc = path_to_example_nc
    ),
    "'mis' should be one of"
  )
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
