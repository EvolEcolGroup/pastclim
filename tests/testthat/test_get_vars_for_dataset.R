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
  expect_true(inherits(vars, "character"))
  vars <- get_vars_for_dataset(
    dataset = "Example",
    details = TRUE
  )
  expect_true(inherits(vars, "data.frame"))
})


test_that("get_vars_for_dataset for local file", {
  example_filename <- getOption("pastclim.dataset_list")$file_name[
    getOption("pastclim.dataset_list")$dataset == "Example"
  ][1]
  path_to_example_nc <- system.file("/extdata/", example_filename,
    package = "pastclim"
  )
  vars <- get_vars_for_dataset(
    dataset = "custom",
    path_to_nc = path_to_example_nc
  )
  expect_true(inherits(vars, "character"))
  vars <- get_vars_for_dataset(
    dataset = "custom", path_to_nc = path_to_example_nc,
    details = TRUE
  )
  expect_true(inherits(vars, "data.frame"))
})

test_that("get_vars_for_dataset closes the nc file for custom datasets", {
  skip_if_not(dir.exists("/proc/self/fd"))
  # use a fresh copy of the file, so that we can check whether it is still open
  path_to_nc <- file.path(tempdir(), "example_copy_for_get_vars.nc")
  file.copy(
    system.file("extdata/example_climate_v1.3.0.nc", package = "pastclim"),
    path_to_nc
  )
  on.exit(unlink(path_to_nc))
  is_open <- function(path) {
    open_files <- Sys.readlink(list.files("/proc/self/fd", full.names = TRUE))
    normalizePath(path) %in% open_files
  }
  get_vars_for_dataset(dataset = "custom", path_to_nc = path_to_nc)
  expect_false(is_open(path_to_nc))
  get_vars_for_dataset(
    dataset = "custom", path_to_nc = path_to_nc,
    details = TRUE
  )
  expect_false(is_open(path_to_nc))
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
