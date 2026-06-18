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

test_that("make_land_mask treats NULL sea_level like the default dataset", {
  relief_rast <- terra::rast(matrix(c(0, 10, 20, 300, -30, -40), nrow = 2))

  land_mask_default <- make_land_mask(relief_rast,
    time_bp = c(-1000, -10000, -20000)
  )
  land_mask_null <- make_land_mask(relief_rast,
    time_bp = c(-1000, -10000, -20000),
    sea_level = NULL
  )

  expect_equal(terra::values(land_mask_null), terra::values(land_mask_default))
})

test_that("get_sea_level rejects future times", {
  expect_error(
    pastclim:::get_sea_level(1000),
    "time_bp should be in the past"
  )
})

test_that("get_sea_level validates baseline data structure", {
  bad_get_sea_level <- pastclim:::get_sea_level
  environment(bad_get_sea_level) <- list2env(
    list(
      spratt2016 = data.frame(
        time_bp = c(-1000, -500),
        sea_level = c(-20, -10)
      )
    ),
    parent = environment(pastclim:::get_sea_level)
  )

  expect_error(
    bad_get_sea_level(-750),
    "single time_bp == 0 entry"
  )
})
