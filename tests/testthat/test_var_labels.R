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

test_that("var_labels for plots", {
  # check that we can correctly return expressions for every variable (i.e.
  # that nothing is malforms and crashes the parsing)
  for (i in list_available_datasets()) {
    my_labels <- var_labels(get_vars_for_dataset(i), dataset = i)
    expect_true(inherits(my_labels, "expression"))
    my_labels <- var_labels(get_vars_for_dataset(i),
      dataset = i,
      with_units = FALSE
    )
    expect_true(inherits(my_labels, "expression"))
    my_labels <- var_labels(get_vars_for_dataset(i),
      dataset = i,
      abbreviated = TRUE
    )
    expect_true(inherits(my_labels, "expression"))
    my_labels <- var_labels(get_vars_for_dataset(i),
      dataset = i,
      with_units = FALSE, abbreviated = TRUE
    )
    expect_true(inherits(my_labels, "expression"))
  }
  # error for non-existent variable
  expect_error(
    var_labels("blah", dataset = "Example"),
    "blah does not exist in dataset Example"
  )
  # error for non-existent dataset
  expect_error(
    var_labels("blah", dataset = "blah"),
    "^dataset should be one of"
  )
  # labels for SpatRaster
  climate_20k <- region_slice(
    time_bp = -20000,
    bio_variables = c("bio01", "bio10", "bio12"),
    dataset = "Example"
  )
  my_labels <- var_labels(climate_20k, dataset = "Example")
  expect_true(inherits(my_labels, "expression"))
  # error if x is not a correct object
  expect_error(
    var_labels(matrix(1:4, ncol = 1), dataset = "Example"),
    "x should be either a character vector or a SpatRaster"
  )
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
