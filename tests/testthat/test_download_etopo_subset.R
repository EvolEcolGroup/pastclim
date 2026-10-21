test_that("download_etopo_subset requires square cells", {
  rast_template <- terra::rast(
    nrows = 10, ncols = 10,
    xmin = 0, xmax = 10, ymin = 0, ymax = 5
  )
  expect_error(
    download_etopo_subset(rast_template),
    "rast_template should have identical vertical and horizontal resolution"
  )
})
