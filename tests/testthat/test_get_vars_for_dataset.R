test_that("get_vars_for_dataset give appropriate errors", {
  expect_error(
    get_vars_for_dataset(dataset = "blah"),
    "'dataset' must be one of "
  )
  expect_error(
    get_vars_for_dataset(dataset = "Example", path_to_nc = "blah"),
    "path_to_nc should only be set"
  )
  expect_error(
    get_vars_for_dataset(dataset = "custom"),
    "path_to_nc should be set for"
  )
})

test_that("get_vars_for_dataset returns appropriate object", {
  vars <- get_vars_for_dataset(dataset = "Example")
  expect_true(inherits(vars,"character"))
  vars <- get_vars_for_dataset(dataset = "Example",
                               details = TRUE)
  expect_true(inherits(vars,"data.frame"))
})


test_that("get_vars_for_dataset for local file", {
  path_to_example_nc <- system.file("/extdata/", "example_climate.nc",
    package = "pastclim"
  )
  vars <- get_vars_for_dataset(dataset = "custom", path_to_nc = path_to_example_nc)
  expect_true(inherits(vars,"character"))
  vars <- get_vars_for_dataset(dataset = "custom", path_to_nc = path_to_example_nc,
                               details = TRUE)
  expect_true(inherits(vars,"data.frame"))
})
