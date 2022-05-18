test_that("download_dataset", {
  path_to_example_nc <- system.file("/extdata/", package = "pastclim")
  expect_error(
    download_dataset("Beyer", path_to_nc = path_to_example_nc),
    "'dataset' must be one of Beyer2020, Krapp2021, Example"
  )
  expect_error(
    download_dataset("Beyer2020",
      bio_variables = "foo",
      path_to_nc = path_to_example_nc
    ),
    "^foo not available "
  )
  # check that only the example climate is in the data directory
  expect_true(list.files(path_to_example_nc) == "example_climate.nc")
  # expect no error as the dataset exists
  expect_error(download_dataset("Example", path_to_nc = path_to_example_nc), NA)
  # but we should not have downloaded anything, as we already have the file
  expect_true(list.files(path_to_example_nc) == "example_climate.nc")
})
