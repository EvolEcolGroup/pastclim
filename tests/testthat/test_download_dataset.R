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
