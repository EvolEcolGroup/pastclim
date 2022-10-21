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
  expect_true(check_dataset_path(
    "custom",
    file.path(
      get_data_path(),
      "example_climate.nc"
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
