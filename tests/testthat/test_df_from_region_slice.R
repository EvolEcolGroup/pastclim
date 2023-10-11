# set up data path for this test
data_path <- file.path(tempdir(), "pastclim_data")
unlink(data_path, recursive = TRUE) # it should not exist, but remove it just in case
# set data path
set_data_path(
  path_to_nc = data_path,
  ask = FALSE,
  write_config = FALSE,
  copy_example = TRUE
)
################################################################################

test_that("get df from region slice", {
  x <- region_slice(
    time_bp = -10000,
    bio_variables = c("bio01", "bio10", "bio12"),
    dataset = "Example"
  )
  df_slice <- df_from_region_slice(x)
  expect_true(all(c("x", "y") %in% names(df_slice)))
  df_slice <- df_from_region_slice(x, xy = FALSE)
  expect_false(all(c("x", "y") %in% names(df_slice)))
  expect_error(
    df_from_region_slice("foo", xy = FALSE),
    "x is not a valid SpatRaster "
  )
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
