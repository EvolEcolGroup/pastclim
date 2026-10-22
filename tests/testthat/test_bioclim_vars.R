load_delta_series <- function(var) {
  x <- terra::readRDS(system.file(paste0("/extdata/delta/", var, "_series.RDS"),
    package = "pastclim"
  ))
  # get back the time units that are lost when saving the rds
  terra::time(x, tstep = "years") <- terra::time(x)
  x
}

test_that("bioclim_vars for numeric and matrix", {
  prec <- c(66, 51, 53, 53, 33, 34.2, 70.9, 58, 54, 104.3, 81.2, 82.8)
  tavg <- c(-0.2, 1.7, 2.9, 0.3, 4.2, 5, 4, 9, 9.2, 7.3, 12.6, 12.7)
  bio_num <- bioclim_vars(prec, tavg)
  expect_equal(ncol(bio_num), 17)
  expect_equal(unname(bio_num[, "bio01"]), mean(tavg))
  expect_equal(unname(bio_num[, "bio12"]), sum(prec))
  # matrix version gives the same results, and NA rows stay NA
  bio_mat <- bioclim_vars(rbind(prec, NA), rbind(tavg, NA))
  expect_equal(bio_mat[1, ], bio_num[1, ])
  expect_true(all(is.na(bio_mat[2, ])))
  expect_error(
    bioclim_vars(rbind(prec, prec), rbind(tavg)),
    "prec and tavg should have same length"
  )
})

test_that("bioclim_vars for SpatRaster and SpatRasterDataset", {
  prec_series <- load_delta_series("prec")
  tavg_series <- load_delta_series("tavg")
  prec_present <- slice_region_series(prec_series, time_bp = 0)
  tavg_present <- slice_region_series(tavg_series, time_bp = 0)
  bio_rast <- bioclim_vars(prec_present, tavg_present)
  expect_true(inherits(bio_rast, "SpatRaster"))
  expect_equal(terra::nlyr(bio_rast), 17)
  bio_series <- bioclim_vars(prec_series, tavg_series)
  expect_true(inherits(bio_series, "SpatRasterDataset"))
  expect_equal(time_bp(bio_series), time_bp(prec_series))
  expect_equal(
    terra::values(slice_region_series(bio_series, time_bp = 0)),
    terra::values(bio_rast),
    ignore_attr = TRUE
  )
})

test_that("bioclim_vars and koeppen_geiger reject invalid region series", {
  prec_series <- load_delta_series("prec")
  tavg_series <- load_delta_series("tavg")
  # a SpatRasterDataset whose variables have different numbers of time steps
  # is not a valid region series
  prec_invalid <- prec_series
  prec_invalid[12] <- prec_series[[12]][[1:2]]
  expect_false(is_region_series(prec_invalid))
  expect_error(
    bioclim_vars(prec_invalid, tavg_series),
    "prec and tavg should be generated with region_series"
  )
  expect_error(
    koeppen_geiger(prec_invalid, tavg_series),
    "prec and tavg should be generated with region_series"
  )
})
