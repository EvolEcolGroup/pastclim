# test that the files names we have in the reference table for HYDE do point to
# a valid file sometimes these files are moved and we need to keep checking

test_that("filenames for HYDE are correct", {
  skip_if_offline()
  hyde_files <- pastclim:::dataset_list_included$download_path[
    pastclim:::dataset_list_included$dataset == "HYDE_3.3_baseline"
  ]
  # the HYDE server sometimes fails to answer a request, so try each url up
  # to 3 times, 5 seconds apart, before deciding that it is not valid
  url_is_valid_retry <- function(url, tries = 3) {
    for (i in seq_len(tries)) {
      if (url_is_valid(url)) {
        return(TRUE)
      }
      if (i < tries) {
        Sys.sleep(5)
      }
    }
    FALSE
  }
  # check 3 random files
  expect_true(url_is_valid_retry(sample(hyde_files, 1)))
  expect_true(url_is_valid_retry(sample(hyde_files, 1)))
  expect_true(url_is_valid_retry(sample(hyde_files, 1)))
})
