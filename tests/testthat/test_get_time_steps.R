test_that("get_time_steps requires correct variables", {
  expect_error(
    get_time_steps(dataset = "blah"),
    "'dataset' must be one of "
  )
  expect_error(
    get_time_steps(dataset = "Example", path_to_nc = "blah"),
    "path_to_nc can only be set if"
  )
})

test_that("get_time_steps for pastclimData", {
  expect_equal(get_time_steps(dataset = "Example"),
    c(-20000, -15000, -10000, -5000, 0),
    ignore_attr = TRUE
  )
})

test_that("get_time_steps for local file", {
  path_to_example_nc <- system.file("/extdata/", "example_climate.nc",
    package = "pastclim"
  )
  expect_equal(get_time_steps(dataset = "custom",
                              path_to_nc = path_to_example_nc),
    c(-20000, -15000, -10000, -5000, 0),
    ignore_attr = TRUE
  )
  expect_equal(get_mis_time_steps(mis = "2", dataset = "custom",
                                  path_to_nc = path_to_example_nc),
    c(-20000, -15000),
    ignore_attr = TRUE
  )
})
