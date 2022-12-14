# set up data path for this test
data_path <- file.path(tempdir(),"pastclim_data")
unlink(data_path, recursive = TRUE) # it should not exist, but remove it just in case
# set data path
set_data_path(path_to_nc = data_path,
              ask = FALSE,
              write_config = FALSE,
              copy_example = TRUE)
################################################################################

test_that("clean data path", {
  files_in_data_path <- list.files(get_data_path())
  expect_message(clean_data_path(ask = FALSE),
                 "Everything is")
  # the files should not be touched
  expect_equal(files_in_data_path,list.files(get_data_path()))
  # now create a spurious file
  file_to_add <- "example_climate_v0.0.1.nc"
  write.csv("blash",file.path(get_data_path(),file_to_add))
  # now the extra file is there
  expect_true(file_to_add %in% list.files(get_data_path()))
  expect_true(clean_data_path(ask = FALSE))
  # now it's gone
  expect_false(file_to_add %in% list.files(get_data_path()))
  
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)

