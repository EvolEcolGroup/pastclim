# set up data path for this test
data_path <- file.path(tempdir(), "pastclim_data")
unlink(data_path, recursive = TRUE) # it should not exist, but remove it just in case
# set data path
set_data_path(
  path_to_nc = data_path,
  ask = FALSE,
  write_config = FALSE,
  copy_example = TRUE
)
################################################################################

test_that("load_dataset_list", {
  # now create a file in the tempdir
  new_table <- load_dataset_list(on_cran = TRUE)
  # now update to the version
  new_table$dataset_list_v[1] <- "99.0.0"

  write.csv(new_table,
    file.path(tempdir(), "dataset_list_included.csv"),
    row.names = FALSE
  )
  # now check the version when we reload the dataset
  expect_true(load_dataset_list(on_cran = TRUE)$dataset_list_v[1] == "99.0.0")
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
