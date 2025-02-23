# set up data path for this test
data_path <- file.path(tempdir(), "pastclim_data")
# it should not exist, but remove it just in case
unlink(data_path, recursive = TRUE)
# set data path
set_data_path(
  path_to_nc = data_path,
  ask = FALSE,
  write_config = FALSE,
  copy_example = TRUE
)
################################################################################

test_that("get df from region series", {
  x <- region_series(
    time_bp = list(min = -15000, max = 0),
    bio_variables = c("bio01", "bio10", "bio12"),
    dataset = "Example"
  )
  df_series <- df_from_region_series(x, xy = TRUE)
  expect_true(length(unique(df_series$time_bp)) == 4)
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
