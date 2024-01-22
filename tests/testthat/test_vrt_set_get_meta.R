# this file tests the setting and getting of metadata from a vrt file
# we work in the temp directory
test_that("setting and getting vrt meta", {
  vrt_filename <- file.path(tempdir(),"test.vrt")
  tif_files <- list.files(system.file("extdata/CHELSA_bio01", package="pastclim"),
             full.names = TRUE)
  # create the file
  vrt_path <- terra::vrt(x = tif_files,
                         filename = vrt_filename,
                         options="-separate", overwrite=TRUE, return_filename=TRUE)
  
  description <- "band_name_1"
  time_vector <- c(0,-10,-1000)
  expect_true(vrt_set_meta(vrt_path, description, time_vector))
  # check we have the correct description in the file
  vrt_rast <- terra::rast(vrt_path)
  expect_true(identical(names(vrt_rast),paste(description,time_vector, sep="_")))
  vrt_meta <- vrt_get_meta(vrt_path = vrt_path)
  expect_true(identical(vrt_meta$time_bp,time_vector))
  expect_true(identical(vrt_meta$description,description))
  # check that get_time_bp_steps works with a vrt file
  expect_true(identical(
    get_time_bp_steps(dataset="custom", path_to_nc = vrt_path),time_vector))
  
  
  # expect an error if we try to set the metadata a second time
  expect_error(vrt_set_meta(vrt_path, description, time_vector),
               "metadata for pastclim is already present")
}
)
