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

test_that("download_paleoclim stops if the download fails", {
  local_mocked_bindings(
    multi_download = function(urls, destfiles, ...) {
      data.frame(success = c(FALSE, rep(TRUE, length(urls) - 1)))
    },
    .package = "curl"
  )
  dataset <- "paleoclim_1.0_10m"
  expect_error(
    download_paleoclim(
      dataset = dataset, bio_var = "bio01",
      filename = file.path(
        get_data_path(),
        get_var_meta("bio01", dataset)$file_name
      )
    ),
    "something went wrong downloading the data"
  )
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
