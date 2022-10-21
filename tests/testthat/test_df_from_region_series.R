test_that("get df from region series", {
  x <- region_series(
    time_bp = list(min=-15000,max=0), c("bio01", "bio10", "bio12"),
    "Example"
  )
  df_series <- df_from_region_series(x ,xy=TRUE)
  expect_true(length(unique(df_series$time_bp))==4)
})  