testthat::test_that("get_and_check_available_datasets", {
  testthat::expect_true(all(get_available_datasets() == c("Beyer2020",
                                                          "Krapp2021",
                                                          "Example")))
  testthat::expect_true(check_available_dataset("Example"))
  testthat::expect_error(
    check_available_dataset("foo"),
    "'dataset' must be one of Beyer2020, Krapp2021, Example"
  )
})
