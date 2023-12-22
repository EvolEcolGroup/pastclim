test_that("ybp2date converts correctly", {
  # the reference year is 1950
  expect_true(lubridate::year(ybp2date(0)) == 1950)
  expect_true(lubridate::year(ybp2date(-10000)) == -8050)
  # check correct back and forth
  converted_date <- ybp2date(-10000)
  expect_true(date2ybp(converted_date) == -10000)
})
