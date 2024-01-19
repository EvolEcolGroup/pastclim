# this file tests the setting and getting of metadata from a vrt file
# we work in the temp directory
temp_dir <- tempdir()
vrt_filename <- file.path(temp_dir,"test.vrt")

test_that("editing vrt meta", {
  tif_files <- list.files(system.file("extdata/CHELSA_bio01", package="pastclim"),
             full.names = TRUE)
  # create the file
  vrt_path <- terra::vrt(x = tif_files,
                         filename = vrt_filename,
                         options="-separate", overwrite=TRUE, return_filename=TRUE)
  
  description_vector <- paste0("band_name_",1:3)
  time_vector <- c(0,-10,-1000)
  expect_true(vrt_set_meta(vrt_path, description_vector, time_vector))
  vrt_rast <- terra::rast(vrt_path)
  expect_true(identical(names(vrt_rast),description_vector))
  expect_true(identical(vrt_get_times(vrt_path = vrt_path),time_vector))
}
)
