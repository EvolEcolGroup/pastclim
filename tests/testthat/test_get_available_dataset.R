# set up data path for this test
data_path <- file.path(tempdir(),"pastclim_data")
unlink(data_path, recursive = TRUE) # it should not exist, but remove it just in case
# set data path
set_data_path(path_to_nc = data_path,
              ask = FALSE,
              write_config = FALSE,
              copy_example = TRUE)
################################################################################

testthat::test_that("get_and_check_available_datasets", {
  testthat::expect_true(all(c(
    "Beyer2020",
    "Krapp2021",
    "Example"
  ) %in% list_available_datasets()))
  testthat::expect_true(check_available_dataset("Example"))
  testthat::expect_error(
    check_available_dataset("foo"),
    "'dataset' must be one of "
  )
  testthat::expect_true(check_available_dataset("custom",
                                                include_custom = TRUE))
  testthat::expect_error(
    check_available_dataset("custom"),
    "'dataset' must be one of "
  )
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
