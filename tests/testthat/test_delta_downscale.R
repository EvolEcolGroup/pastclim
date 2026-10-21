make_delta_inputs <- function() {
  # low resolution reconstructions with two time steps, with the corner of
  # the landmask missing
  x <- terra::rast(nrows = 4, ncols = 4, nlyrs = 2,
    xmin = 0, xmax = 4, ymin = 0, ymax = 4, crs = "lonlat"
  )
  terra::values(x) <- cbind(1:16, 101:116)
  x[1] <- NA
  time_bp(x) <- c(-1000, 0)
  # high resolution observations for the present
  obs <- terra::rast(nrows = 8, ncols = 8,
    xmin = 0, xmax = 4, ymin = 0, ymax = 4, crs = "lonlat"
  )
  terra::values(obs) <- seq(100, 163)
  # a high resolution landmask that covers the whole region
  landmask_high <- terra::rast(obs, nlyrs = 2)
  terra::values(landmask_high) <- 1
  list(x = x, obs = obs, landmask_high = landmask_high)
}

test_that("delta_downscale fills gaps in every layer", {
  inputs <- make_delta_inputs()
  delta_rast <- delta_compute(
    x = inputs$x, ref_time = 0, obs = inputs$obs,
    max_land = inputs$landmask_high[[1]]
  )
  x_down <- delta_downscale(
    x = inputs$x, delta_rast = delta_rast,
    x_landmask_high = inputs$landmask_high
  )
  expect_equal(terra::nlyr(x_down), 2)
  expect_equal(terra::ncell(x_down), terra::ncell(inputs$obs))
  # all cells in the landmask should have values, for every time step
  expect_equal(sum(is.na(terra::values(x_down))), 0)
})

test_that("delta_downscale works without a high resolution landmask", {
  inputs <- make_delta_inputs()
  delta_rast <- delta_compute(
    x = inputs$x, ref_time = 0, obs = inputs$obs,
    max_land = inputs$landmask_high[[1]]
  )
  x_down <- delta_downscale(x = inputs$x, delta_rast = delta_rast)
  expect_equal(terra::nlyr(x_down), 2)
  expect_equal(terra::ncell(x_down), terra::ncell(inputs$obs))
  # the cells outside the original landmask remain NA
  expect_true(sum(is.na(terra::values(x_down[[1]]))) > 0)
  # range limits are applied
  x_down_lim <- delta_downscale(
    x = inputs$x, delta_rast = delta_rast,
    range_limits = c(110, 150)
  )
  expect_true(min(terra::values(x_down_lim), na.rm = TRUE) >= 110)
  expect_true(max(terra::values(x_down_lim), na.rm = TRUE) <= 150)
})
