test_that("get_mis_time_steps for standard dataset", {
  expect_equal(get_mis_time_steps(mis = "2", dataset = "Example"),
    c(-20000, -15000),
    ignore_attr = TRUE
  )
})

test_that("get_mis_time_steps for local file", {
  path_to_example_nc <- system.file("/extdata/", "example_climate.nc",
    package = "pastclim"
  )
  expect_equal(get_mis_time_steps(mis = "2", dataset = "custom", 
                                  path_to_nc = path_to_example_nc),
    c(-20000, -15000),
    ignore_attr = TRUE
  )
})

test_that("get_mis_time_steps requires correct variables", {
  expect_error(
    get_mis_time_steps(mis = "blah", dataset = "custom", 
                       path_to_nc = path_to_example_nc),
    "'mis' should be one of"
  )
})
