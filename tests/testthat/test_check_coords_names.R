test_that("check_coords_names finds standard coordinate names", {
  expect_identical(
    check_coords_names(data.frame(longitude = 1, latitude = 2), NULL),
    c("longitude", "latitude")
  )
  expect_identical(
    check_coords_names(data.frame(a = 1, x = 1, y = 2), NULL),
    c("x", "y")
  )
  expect_identical(
    check_coords_names(data.frame(a = 1, b = 2), c("a", "b")),
    c("a", "b")
  )
  expect_error(
    check_coords_names(data.frame(a = 1, b = 2), NULL),
    "There are no recognised coordinate columns"
  )
  expect_error(
    check_coords_names(data.frame(a = 1, b = 2), c("a", "c")),
    "There are no recognised coordinate columns"
  )
})

test_that("check_coords_names reports ambiguous coordinate names", {
  locations <- data.frame(x = 1, y = 2, longitude = 1, latitude = 2)
  expect_error(
    check_coords_names(locations, NULL),
    paste0(
      "There are multiple sets of possible coordinate columns ",
      "\\(x/y, longitude/latitude\\)"
    )
  )
  # setting coords explicitly resolves the ambiguity
  expect_identical(
    check_coords_names(locations, c("longitude", "latitude")),
    c("longitude", "latitude")
  )
})
