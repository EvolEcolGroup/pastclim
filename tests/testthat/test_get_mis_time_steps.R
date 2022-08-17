test_that("get_mis_time_steps for pastclimData", {
  skip_if(!requireNamespace("pastclimData"))
  expect_equal(get_mis_time_steps(mis = "2", dataset = "Example"),
    c(-20000, -15000),
    ignore_attr = TRUE
  )
})

test_that("get_mis_time_steps for local file", {
  path_to_example_nc <- system.file("/extdata/", "example_climate.nc",
    package = "pastclim"
  )
  expect_equal(get_mis_time_steps(mis = "2", path_to_nc = path_to_example_nc),
    c(-20000, -15000),
    ignore_attr = TRUE
  )
})

test_that("get_mis_time_steps requires correct variables", {
  expect_error(
    get_mis_time_steps(mis = "blah", path_to_nc = path_to_example_nc),
    "'mis' should be one of"
  )
  expect_error(get_mis_time_steps(mis = 2), "Either 'dataset' or ")
  expect_error(
    get_mis_time_steps(mis = 2, dataset = "blah", path_to_nc = "blah"),
    "Only 'dataset' or "
  )
})