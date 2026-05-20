# test that we can create landmasks correctly
test_that("make_land_mask works", {
  relief_rast <- terra::rast(matrix(c(0, 1, 2, 3, 4, 5), nrow = 2))
  time_bp <- c(-1000, -2000)
  sea_level <- c(2.5, 3.5)

  land_mask <- make_land_mask(relief_rast, time_bp, sea_level)

  expect_equal(nlyr(land_mask), length(time_bp))
  expect_true(all.equal(as.vector(land_mask[[1]]), c(NA, NA, 1, NA, 1, 1)))
  expect_true(all.equal(as.vector(land_mask[[2]]), c(NA, NA, 1, NA, NA, 1)))
})

# now test using the inbuilt datasets
test_that("make_land_mask works with inbuilt datasets", {
  relief_rast <- terra::rast(matrix(c(0, 10, 20, 300, -30, -40), nrow = 2))

  land_mask <- make_land_mask(relief_rast,
    time_bp = c(-1000, -10000, -20000),
    sea_level = "Spratt2016"
  )
  # expect two cells underwater at -1000, one at -10000 and zero at -20000
  expect_true(sum(is.na(as.vector(land_mask[[1]]))) == 2)
  expect_true(sum(is.na(as.vector(land_mask[[2]]))) == 1)
  expect_true(sum(is.na(as.vector(land_mask[[3]]))) == 0)
  land_mask <- make_land_mask(relief_rast,
    time_bp = c(-1000, -10000, -20000),
    sea_level = "Clark2025"
  )
  # with clark we have a more extreme sea level drop at -10000, so we should
  # have more land exposed at that time point expect two cells underwater at
  # -1000, zero at -10000 and zero at -20000
  expect_true(sum(is.na(as.vector(land_mask[[1]]))) == 2)
  expect_true(sum(is.na(as.vector(land_mask[[2]]))) == 0)
  expect_true(sum(is.na(as.vector(land_mask[[3]]))) == 0)

  # get error if we use an incorrect dataset
  expect_error(
    make_land_mask(relief_rast,
      time_bp = c(-1000, -10000, -20000),
      sea_level = "wrong_dataset"
    ),
    "sea_level should be either"
  )
})
