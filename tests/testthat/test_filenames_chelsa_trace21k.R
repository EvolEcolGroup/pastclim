# test that the files names generated for chelsa do point to a valid file

test_that("filenames_chelsa_trace21k are correct", {
  skip_if_offline()
  bio_files <- filenames_chelsa_trace21k(data="CHELSA_trace21k_1.0_0.5m",
                                         bio_var = "bio08")
  expect_true(url_is_valid(bio_files[1]))
  expect_true(url_is_valid(bio_files[sample(2:199,1)]))
  expect_true(url_is_valid(bio_files[length(bio_files)]))
  
  bio_files <- filenames_chelsa_trace21k(data="CHELSA_trace21k_1.0_0.5m",
                                         bio_var = "temperature_max_11")
  expect_true(url_is_valid(bio_files[1]))
  expect_true(url_is_valid(bio_files[sample(2:199,1)]))
  expect_true(url_is_valid(bio_files[length(bio_files)]))
  
  bio_files <- filenames_chelsa_trace21k(data="CHELSA_trace21k_1.0_0.5m",
                                         bio_var = "temperature_min_11")
  expect_true(url_is_valid(bio_files[1]))
  expect_true(url_is_valid(bio_files[sample(2:199,1)]))
  expect_true(url_is_valid(bio_files[length(bio_files)]))
  
  bio_files <- filenames_chelsa_trace21k(data="CHELSA_trace21k_1.0_0.5m",
                                         bio_var = "precipitation_03")
  expect_true(url_is_valid(bio_files[1]))
  expect_true(url_is_valid(bio_files[sample(2:199,1)]))
  expect_true(url_is_valid(bio_files[length(bio_files)]))

}
)