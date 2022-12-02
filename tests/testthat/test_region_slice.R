# set up data path for this test
data_path <- file.path(tempdir(),"pastclim_data")
unlink(data_path, recursive = TRUE) # it should not exist, but remove it just in case
# set data path
set_data_path(path_to_nc = data_path,
              ask = FALSE,
              write_config = FALSE,
              copy_example = TRUE)
################################################################################

test_that("region slice", {
  # using standard dataset
  climate_slice <- region_slice(
    c(-10000), c("bio01", "bio12"),
    "Example"
  )
  expect_true(inherits(climate_slice, "SpatRaster"))
  expect_true(all(varnames(climate_slice) == c("bio01", "bio12")))
  expect_true(terra::nlyr(climate_slice) == c(2))

  # do the same for a custom dataset
  example_filename <- files_by_dataset$file_name[files_by_dataset$dataset=="Example"][1]
  path_to_example_nc <- system.file("/extdata/", example_filename,
                                    package = "pastclim"
  )
  climate_slice <- region_slice(c(-10000), c("BIO1", "BIO10"),
    "custom",
    path_to_nc = path_to_example_nc
  )
  expect_true(inherits(climate_slice, "SpatRaster"))
  expect_true(all(varnames(climate_slice) == c("BIO1", "BIO10")))
  expect_true(terra::nlyr(climate_slice) == c(2))

  expect_error(
    region_slice(
      c(-10000, -20000), c("bio01", "bio12"),
      "Example"
    ),
    "time_bp should be a single time step"
  )
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)  
