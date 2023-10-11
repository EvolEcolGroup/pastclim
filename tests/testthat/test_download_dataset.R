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

test_that("download_dataset", {
  expect_error(
    download_dataset("Beyer"),
    "Invalid 'dataset',"
  )
  expect_error(
    download_dataset("Beyer2020",
      bio_variables = "foo"
    ),
    "^foo not available "
  )
  # check that only the example climate is in the data directory
  example_filename <- getOption("pastclim.dataset_list")$file_name[getOption("pastclim.dataset_list")$dataset == "Example"][1]
  expect_true(example_filename %in% list.files(get_data_path()))
  # expect no error as the dataset exists
  expect_error(download_dataset("Example"), NA)
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)
