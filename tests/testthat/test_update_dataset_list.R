test_that("update_dataset_list installs a newer list", {
  old_list <- getOption("pastclim.dataset_list")
  config_file <- file.path(tempdir(), "dataset_list_included.csv")
  unlink(config_file)
  on.exit({
    options(pastclim.dataset_list = old_list)
    unlink(config_file)
  })
  # fake a newer list on the server
  new_list <- old_list
  new_list$dataset_list_v <- "99.0.0"
  remote_file <- tempfile(fileext = ".csv")
  utils::write.csv(new_list, remote_file, row.names = FALSE)
  local_mocked_bindings(
    curl_download = function(url, destfile, ...) {
      file.copy(remote_file, destfile, overwrite = TRUE)
    },
    .package = "curl"
  )
  expect_message(
    expect_true(update_dataset_list(on_cran = TRUE)),
    "The dataset list was updated."
  )
  expect_true(file.exists(config_file))
  expect_identical(
    getOption("pastclim.dataset_list")$dataset_list_v[1],
    "99.0.0"
  )
  expect_identical(
    load_dataset_list(on_cran = TRUE)$dataset_list_v[1],
    "99.0.0"
  )
  # running it again does not update anything
  expect_message(
    expect_false(update_dataset_list(on_cran = TRUE)),
    "already the latest version"
  )
})
