test_that("get_file_for_dataset", {
  expect_true(nrow(get_file_for_dataset("bio01", "Example")) == 1)
  expect_error(
    get_file_for_dataset("bio19", "Example"),
    "bio19 not"
  )
  expect_true(nrow(get_file_for_dataset("bio01", "Beyer2020")) == 1)
  expect_error(
    get_file_for_dataset("bio01", "Beyer"),
    "^'dataset' must be one of "
  )
})
