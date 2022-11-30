# set up data path for this test
data_path <- file.path(tempdir(),"pastclim_data")
unlink(data_path, recursive = TRUE) # it should not exist, but remove it just in case
# set data path
set_data_path(path_to_nc = data_path,
              ask = FALSE,
              write_config = FALSE,
              copy_example = TRUE)
################################################################################

test_that("download_dataset", {
  expect_error(
    download_dataset("Beyer"),
    "'dataset' must be one of "
  )
  expect_error(
    download_dataset("Beyer2020",
      bio_variables = "foo"
    ),
    "^foo not available "
  )
  # check that only the example climate is in the data directory
  expect_true("example_climate_v2.nc" %in% list.files(get_data_path()))
  # expect no error as the dataset exists
  expect_error(download_dataset("Example"), NA)
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)

