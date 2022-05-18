test_that("get_pastclimdata_path without pastclimData", {
  skip_if(requireNamespace("pastclimData"))
  expect_error(
    get_pastclimdata_path(),
    "^the parameter path_to_nc"
  )
})

test_that("get_pastclimdata_path with pastclimData", {
  skip_if(!requireNamespace("pastclimData"))
  expect_true(is.character(get_pastclimdata_path()))
})
