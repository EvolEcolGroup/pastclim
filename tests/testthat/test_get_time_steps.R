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

test_that("get_time_bp_steps requires correct variables", {
  expect_error(
    get_time_bp_steps(dataset = "blah"),
    "'dataset' must be one of "
  )
  expect_error(
    get_time_bp_steps(dataset = "Example", path_to_nc = "blah"),
    "path_to_nc can only be set if"
  )
})

test_that("get_time_bp_steps for standard dataset", {
  expect_equal(get_time_bp_steps(dataset = "Example"),
    c(-20000, -15000, -10000, -5000, 0),
    ignore_attr = TRUE
  )
  # expect error for dataset not downloaded yet
  expect_error(get_time_bp_steps(dataset = "WorldClim_2.1_MRI-ESM2-0_ssp370_5m"),
               "no variable has been downloaded")
})

test_that("get_time_bp_steps for local file", {
  example_filename <- getOption("pastclim.dataset_list")$file_name[getOption("pastclim.dataset_list")$dataset == "Example"][1]
  path_to_example_nc <- system.file("/extdata/", example_filename,
    package = "pastclim"
  )
  expect_equal(
    get_time_bp_steps(
      dataset = "custom",
      path_to_nc = path_to_example_nc
    ),
    c(-20000, -15000, -10000, -5000, 0),
    ignore_attr = TRUE
  )

})


################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
