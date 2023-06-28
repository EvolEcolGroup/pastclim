# set up data path for this test
data_path <- file.path(tempdir(),"pastclim_data")
unlink(data_path, recursive = TRUE) # it should not exist, but remove it just in case
# set data path
set_data_path(path_to_nc = data_path,
              ask = FALSE,
              write_config = FALSE,
              copy_example = TRUE)
################################################################################

testthat::test_that("get biome classes", {
  distance_spatrast <- distance_from_sea(time_bp=-10000, 
                                             dataset="Example")
  # check that we have distances for land only for the correct landmask
  correct_landmask <- get_land_mask(time_bp=-10000,
                                    dataset="Example")
  expect_true(all(is.na(distance_spatrast[is.na(correct_landmask)])))
  wrong_landmask <- get_land_mask(time_bp=-20000,
                                  dataset="Example")
  expect_false(all(is.na(distance_spatrast[is.na(wrong_landmask)])))
  # now get them all
  distance_spatrast <- distance_from_sea(dataset="Example")
  expect_true(all(time_bp(distance_spatrast)==get_time_bp_steps(dataset="Example")))
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
