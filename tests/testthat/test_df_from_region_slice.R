test_that("get df from region slice", {
  x <- region_slice(
    time_bp = -10000, c("bio01", "bio10", "bio12"),
    "Example"
  )
  df_slice <- df_from_region_slice(x)
  expect_true(all(c("x","y") %in% names(df_slice)))
  df_slice <- df_from_region_slice(x, xy=FALSE)
  expect_false(all(c("x","y") %in% names(df_slice)))
  expect_error(df_from_region_slice("foo", xy=FALSE),
               "x is not a valid SpatRaster ")
})  