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

test_that("get_var_meta", {
  expect_true(nrow(get_var_meta("bio01", "Example")) == 1)
  expect_error(
    get_var_meta("bio19", "Example"),
    "bio19 not"
  )
  expect_true(nrow(get_var_meta("bio01", "Beyer2020")) == 1)
  expect_error(
    get_var_meta("bio01", "Beyer"),
    "^'dataset' must be one of "
  )
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
