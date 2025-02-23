# test that the files names generated for paleoclim present do point to a valid
# file

test_that("filenames_paleoclim are correct", {
  skip_if_offline()
  bio_files <- filenames_paleoclim("paleoclim_1.0_10m", bio_var = "bio04")
  expect_true(url_is_valid(bio_files[1]))
  expect_true(url_is_valid(bio_files[4]))
  bio_files <- filenames_paleoclim("paleoclim_1.0_5m", bio_var = "bio10")
  expect_true(url_is_valid(bio_files[1]))
  expect_true(url_is_valid(bio_files[5]))
  bio_files <- filenames_paleoclim("paleoclim_1.0_2.5m", bio_var = "bio15")
  expect_true(url_is_valid(bio_files[1]))
  expect_true(url_is_valid(bio_files[7]))
})
