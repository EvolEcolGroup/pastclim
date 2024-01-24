# test that the files names generated for worldclim present do point to a valid file

test_that("filenames_worldclim_present are correct", {
  skip_if_offline()
  bio_files <- filenames_worldclim_present(dataset="WorldClim_2.1_10m",bio_var = "bio04")
  expect_true(url_is_valid(bio_files))
  bio_files <- filenames_worldclim_present(dataset="WorldClim_2.1_2.5m", bio_var = "bio13")
  expect_true(url_is_valid(bio_files))
  bio_files <- filenames_worldclim_present(dataset="WorldClim_2.1_0.5m",bio_var = "temperature_10")
  expect_true(url_is_valid(bio_files))
  bio_files <- filenames_worldclim_present(dataset="WorldClim_2.1_5m", bio_var = "precipitation_01")
  expect_true(url_is_valid(bio_files))
  bio_files <- filenames_worldclim_present(dataset="WorldClim_2.1_5m", bio_var = "altitude")
  expect_true(url_is_valid(bio_files))
}
)