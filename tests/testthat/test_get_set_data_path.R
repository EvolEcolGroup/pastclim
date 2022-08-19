test_that("set and get data path", {
  set_data_path()
  expect_true(file.exists(file.path(
    tools::R_user_dir("pastclim", "config"),
    "pastclim_data.txt"
  )))
  expect_equal(get_data_path(), tools::R_user_dir("pastclim", "data"))
})
