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

testthat::test_that("get biome classes", {
  # check that we have 29 classes as expected
  expect_true(nrow(get_biome_classes("Example")) == 29)
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
