test_that("download_dataset", {
  expect_error(
    download_dataset("Beyer"),
    "'dataset' must be one of Beyer2020, Krapp2021, Example"
  )
  expect_error(
    download_dataset("Beyer2020",
      bio_variables = "foo"
    ),
    "^foo not available "
  )
  # check that only the example climate is in the data directory
  expect_true(list.files(get_data_path()) == "example_climate.nc")
  # expect no error as the dataset exists
  expect_error(download_dataset("Example"), NA)
  # but we should not have downloaded anything, as we already have the file
  expect_true(list.files(get_data_path()) == "example_climate.nc")
})
