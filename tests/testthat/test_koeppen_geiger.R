# set up data path for this test
data_path <- file.path(tempdir(), "pastclim_data")
# it should not exist, but remove it just in case
unlink(data_path, recursive = TRUE)
# set data path
set_data_path(
  path_to_nc = data_path,
  ask = FALSE,
  write_config = FALSE,
  copy_example = TRUE
)
################################################################################

test_that("koeppen geiger for numeric and matrix", {
  prec_num <- matrix(
    c(
      66, 51, 53, 53, 33, 34.2, 70.9, 58, 54, 104.3,
      81.2, 82.8
    ),
    ncol = 12
  )
  tavg_num <- matrix(c(-0.2, 1.7, 2.9, 0.3, 4.2, 5, 4, 9, 9.2, 7.3, 12.6, 12.7),
    ncol = 12
  )
  expect_error(
    koeppen_geiger(prec = prec_num, tavg = tavg_num),
    "only one valid row of data"
  )

  prec <- matrix(
    c(
      66, 51, 53, 53, 33, 34.2, 70.9, 58, 54, 104.3, 81.2, 82.8, 113.3,
      97.4, 89, 109.7, 89, 93.4, 99.8, 92.6, 85.3, 102.3, 84, 81.6, 108.6, 88.4,
      82.7, 140.1, 120.4, 111.6, 120.4, 113.9, 96.7, 90, 77.4, 79.1
    ),
    ncol = 12
  )
  tavg <- matrix(
    c(
      -0.2, 1.7, 2.9, 0.3, 4.2, 5, 4, 9, 9.2, 7.3, 12.6, 12.7, 12.1,
      17.2, 17, 15.5, 20.5, 20.3, 17.9, 22.8, 22.9, 17.4, 22.3, 22.4,
      13.2, 18.2,
      18.6, 8.8, 13, 13.6, 3.5, 6.4, 7.5, 0.3, 2.1, 3.4
    ),
    ncol = 12
  )
  koeppen_results <- koeppen_geiger(prec, tavg, broad = TRUE)
  expect_true(ncol(koeppen_results) == 2)
  # check for errors
  expect_error(
    koeppen_geiger(prec[, -1], tavg),
    "prec needs to have 12 columns"
  )
  expect_error(
    koeppen_geiger(prec, tavg[, -1]),
    "tavg needs to have 12 columns"
  )
  expect_error(
    koeppen_geiger(prec, tavg[-1, ]),
    "prec and tavg need to have the same number of rows"
  )
  expect_error(
    koeppen_geiger(prec, tavg + 273),
    "tavg should be in "
  )
})

test_that("koeppen geiger for SpatRaster and SpatRasterDataset", {
  prec_series <- terra::readRDS(system.file("/extdata/delta/prec_series.RDS",
    package = "pastclim"
  ))
  # get back the time units that are lost when saving the rds
  old_names <- names(prec_series) # there is a bug in terra
  terra::time(prec_series, tstep = "years") <- terra::time(prec_series)
  names(prec_series) <- old_names
  rm(old_names)

  tavg_series <- terra::readRDS(system.file("/extdata/delta/tavg_series.RDS",
    package = "pastclim"
  ))
  # get back the time units that are lost when saving the rds
  old_names <- names(tavg_series) # there is a bug in terra
  terra::time(tavg_series, tstep = "years") <- terra::time(tavg_series)
  names(tavg_series) <- old_names
  rm(old_names)
  prec_present <- pastclim::slice_region_series(prec_series, time_bp = 0)
  tavg_present <- pastclim::slice_region_series(tavg_series, time_bp = 0)
  koeppen_raster <- koeppen_geiger(
    prec = prec_present,
    tavg = tavg_present
  )
  expect_true(inherits(koeppen_raster, "SpatRaster"))
  koeppen_series <- koeppen_geiger(
    prec = prec_series,
    tavg = tavg_series
  )
  expect_true(inherits(koeppen_series, "SpatRasterDataset"))
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
