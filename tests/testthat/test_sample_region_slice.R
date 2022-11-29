# set up data path for this test
data_path <- file.path(tempdir(),"pastclim_data")
unlink(data_path, recursive = TRUE) # it should not exist, but remove it just in case
# set data path
set_data_path(path_to_nc = data_path,
              ask = FALSE,
              write_config = FALSE,
              copy_example = TRUE)
################################################################################

test_that("sample_region_slice samples correctly", {
  climate_20k <- region_slice(
    time_bp = -20000,
    bio_variables = c("bio01", "bio10"),
    dataset = "Example"
  )
  set.seed(123)
  this_sample<-sample_region_slice(climate_20k,10)
  expect_true(nrow(this_sample)==10)
  expect_true(sum(is.na(this_sample))==0)
  this_sample<-sample_region_slice(climate_20k,10, na.rm=FALSE)
  expect_true(sum(is.na(this_sample))>0)
  # error if we give more than one size (as we do for sample_region_series)
  expect_error(sample_region_slice(climate_20k,c(10,10)),
                                   "size should be a single value")
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)  
