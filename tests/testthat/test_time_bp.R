# set up data path for this test
data_path <- file.path(tempdir(),"pastclim_data")
unlink(data_path, recursive = TRUE) # it should not exist, but remove it just in case
# set data path
set_data_path(path_to_nc = data_path,
              ask = FALSE,
              write_config = FALSE,
              copy_example = TRUE)
################################################################################

test_that("time_bp", {
  # using standard dataset
  climate_slice <- region_slice(
    c(-10000), c("bio01", "bio12"),
    "Example"
  )
  expect_true(all(time_bp(climate_slice)==c(-10000,-10000)))
  # the method will only work on a SpatRaster
  expect_error(time_bp("blah"),"unable to find an inherited method")
  
  # set the time units incorrectly to raw
  time(climate_slice)<-c(-20,-100)
  expect_error(time_bp(climate_slice),"^The time units of SpatRaster are not")
  
  # and now let's fix them back
  time_bp(climate_slice) <- c(-10000,-10000)
  expect_true(all(time_bp(climate_slice)==c(-10000,-10000)))
  
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)  
