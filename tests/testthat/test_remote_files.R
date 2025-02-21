# nolint start
## This is a resource intensive test. It downloads all files in the dataset_list
## and then validates them. It is only run if the appropriate environment
## variable is set, and thus skipped most of the time
## To set the environment variable, use:
## Sys.setenv(PASTCLIM_TEST = "download_full")
## remember to unset it once you are done
## Sys.unsetenv("PASTCLIM_TEST")
# nolint end


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
test_that("download and validate all files", {
  skip_if(Sys.getenv("PASTCLIM_TEST") != "download_full")
  # download all files for each dataset
  all_datasets <- get_available_datasets()
  all_datasets <- all_datasets[!all_datasets %in% "Example"]
  for (i_dataset in all_datasets) {
    expect_true(download_dataset(dataset = i_dataset))
  }
  # now check that the files we downloaded are valid
  for (i_file in list.files(get_data_path())) {
    expect_true(validate_nc(i_file))
  }
  # check that the variables in the table are found in the respective files
  meta_table <- getOption("pastclim.dataset_list")
  for (i_row in seq_len(nrow(meta_table))) {
    nc_in <- ncdf4::nc_open(file.path(in_dir, meta_table$file_name[i]))
    # check below if !! works to unquote the expression
    expect_true(!!meta_table$ncvar[i] %in% names(nc_in$var))
    ncdf4::nc_close(nc_in)
  }
  # for each dataset, check that all variables cover the same extent and have
  # the same missing values
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
