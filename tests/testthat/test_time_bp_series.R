# set up data path for this test
data_path <- file.path(tempdir(),"pastclim_data")
unlink(data_path, recursive = TRUE) # it should not exist, but remove it just in case
# set data path
set_data_path(path_to_nc = data_path,
              ask = FALSE,
              write_config = FALSE,
              copy_example = TRUE)
################################################################################

test_that("time_bp_series returns correct values", {
  time_bp <- c(-10000,-20000)
  time_steps <- sort(-seq(0,20000,by = 5000))
  #####################################################
  # if time_bp is a vector
  #####################################################
  # correctly working 
  expect_true(all(time_bp_series(time_bp,time_steps)==c(3,1)))
  # incorrect values
  time_bp <- c(-9000,-20000)
  expect_error(time_bp_series(time_bp,time_steps),
               "time_bp should only include time steps available in the dataset")
  #####################################################
  # if time_bp is a list
  #####################################################
  time_bp <- list(min=-15000, max=-3000)
  expect_true(all(time_bp_series(time_bp,time_steps)==c(2,3,4)))
  time_bp <- list(min=-3000, max=-15000)
  expect_error(time_bp_series(time_bp,time_steps),
               "in time_bp, min should be less than max")
  #####################################################
  # if time_bp is null
  #####################################################
  expect_true(is.null(time_bp_series(NULL,time_steps)))
  #####################################################
  # if time_bp is nonsense
  #####################################################
  expect_error(time_bp_series("blah",time_steps),
               "time_bp can only be")
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)  

