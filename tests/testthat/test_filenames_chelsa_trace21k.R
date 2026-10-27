
# test that the function generates the correct file names 

test_that("CHELSA Trace21k bioclim URLs are correctly generated", {
  skip_if_offline()
  
  urls <- filenames_chelsa_trace21k("CHELSA_trace21k_1.0_0.5m_vsi","bio01")
  
  expect_length(urls, 221)
  expect_equal(basename(urls[1]),"CHELSA_TraCE21k_bio01_0020_V.1.0.tif")
  expect_equal(basename(urls[length(urls)]),"CHELSA_TraCE21k_bio01_-200_V.1.0.tif")
  
})


# test that the files names generated for chelsa do point to a valid file

test_that("filenames_chelsa_trace21k are correct", {
  skip_if_offline()
  bio_files <- filenames_chelsa_trace21k(
    data = "CHELSA_trace21k_1.0_0.5m",
    bio_var = "bio08"
  )
  expect_true(url_is_valid(bio_files[1]))
  expect_true(url_is_valid(bio_files[sample(2:199, 1)]))
  expect_true(url_is_valid(bio_files[length(bio_files)]))

  bio_files <- filenames_chelsa_trace21k(
    data = "CHELSA_trace21k_1.0_0.5m",
    bio_var = "temperature_max_11"
  )
  expect_true(url_is_valid(bio_files[1]))
  expect_true(url_is_valid(bio_files[sample(2:199, 1)]))
  expect_true(url_is_valid(bio_files[length(bio_files)]))

  bio_files <- filenames_chelsa_trace21k(
    data = "CHELSA_trace21k_1.0_0.5m",
    bio_var = "temperature_max_08"
  )
  expect_true(url_is_valid(bio_files[1]))
  expect_true(url_is_valid(bio_files[sample(2:199, 1)]))
  expect_true(url_is_valid(bio_files[length(bio_files)]))

  bio_files <- filenames_chelsa_trace21k(
    data = "CHELSA_trace21k_1.0_0.5m",
    bio_var = "temperature_min_11"
  )
  expect_true(url_is_valid(bio_files[1]))
  expect_true(url_is_valid(bio_files[sample(2:199, 1)]))
  expect_true(url_is_valid(bio_files[length(bio_files)]))

  bio_files <- filenames_chelsa_trace21k(
    data = "CHELSA_trace21k_1.0_0.5m",
    bio_var = "temperature_min_01"
  )
  expect_true(url_is_valid(bio_files[1]))
  expect_true(url_is_valid(bio_files[sample(2:199, 1)]))
  expect_true(url_is_valid(bio_files[length(bio_files)]))

  bio_files <- filenames_chelsa_trace21k(
    data = "CHELSA_trace21k_1.0_0.5m",
    bio_var = "precipitation_03"
  )
  expect_true(url_is_valid(bio_files[1]))
  expect_true(url_is_valid(bio_files[sample(2:199, 1)]))
  expect_true(url_is_valid(bio_files[length(bio_files)]))
})

