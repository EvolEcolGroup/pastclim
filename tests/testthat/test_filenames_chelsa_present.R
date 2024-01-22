# test that the files names generated for chelsa present do point to a valid file

test_that("filenames_chelsa_present are correct", {
  skip_if_offline()
  bio_files <- filenames_chelsa_present(bio_var = "bio04")
  expect_true(url_is_valid(bio_files[1]))
  expect_true(url_is_valid(bio_files[10]))
  bio_files <- filenames_chelsa_present(bio_var = "temperature_10")
  expect_true(url_is_valid(bio_files[1]))
  expect_true(url_is_valid(bio_files[10]))
  bio_files <- filenames_chelsa_present(bio_var = "precipitation_09")
  expect_true(url_is_valid(bio_files[1]))
  expect_true(url_is_valid(bio_files[10]))
}
)