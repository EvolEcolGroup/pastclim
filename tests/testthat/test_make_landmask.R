# test that we can create landmasks correctly
test_that("make_land_mask works", {
  relief_rast <- terra::rast(matrix(c(0, 1, 2, 3, 4, 5), nrow = 2))
  time_bp <- c(1000, 2000)
  sea_level <- c(2.5, 3.5)
  
  land_mask <- make_land_mask(relief_rast, time_bp, sea_level)
  
  expect_equal(nlyr(land_mask), length(time_bp))
  expect_true(all.equal(as.vector(land_mask[[1]]), c(NA, NA, 1, NA, 1, 1)))
  expect_true(all.equal(as.vector(land_mask[[2]]), c(NA, NA, 1, NA, NA, 1)))
})