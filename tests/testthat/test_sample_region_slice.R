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
  