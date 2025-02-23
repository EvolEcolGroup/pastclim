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

test_that("check_dataset_path errors", {
  expect_true(check_dataset_path("Example", NULL))
  expect_error(
    check_dataset_path("foo", NULL),
    "'dataset' must be one of "
  )
  expect_error(
    check_dataset_path("custom", NULL),
    "you need to set path_to_nc if dataset='custom'"
  )
  example_filename <- getOption("pastclim.dataset_list")$file_name[
    getOption("pastclim.dataset_list")$dataset == "Example"
  ][1] # nolint
  expect_true(check_dataset_path(
    "custom",
    file.path(
      get_data_path(),
      example_filename
    )
  ))
  expect_error(
    check_dataset_path(
      "custom",
      file.path(
        get_data_path(),
        "foo.nc"
      )
    ),
    "path_to_nc does not point to a file"
  )
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
