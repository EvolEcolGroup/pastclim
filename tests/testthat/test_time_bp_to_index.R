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

test_that("time_bp_to_index returns correct values", {
  time_bp <- c(-10000, -8500, -3000)
  time_steps <- c(-10000, -5000, 0)
  expect_true(
    all(
      time_bp_to_index(time_bp = time_bp, time_steps = time_steps) ==
        c(1, 1, 2)
    )
  )
  time_bp <- c(-10000, -3000, -8500)
  expect_true(
    all(
      time_bp_to_index(time_bp = time_bp, time_steps = time_steps) ==
        c(1, 2, 1)
    )
  )
  time_bp <- c(-10000, -3000, 8500)
  expect_warning(
    time_bp_to_index(time_bp = time_bp, time_steps = time_steps),
    "Some dates are"
  )
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
