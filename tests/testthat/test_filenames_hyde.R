# test that the files names we have in the reference table for HYDE do point to a valid file
# sometimes these files are moved and we need to keep checking

test_that("filenames for HYDE are correct", {
  skip_if_offline()
  hyde_files <- pastclim:::dataset_list_included$download_path[pastclim:::dataset_list_included$dataset=="HYDE_3.3_baseline"]
  #check 3 random files
  expect_true(url_is_valid(sample(hyde_files,1)))
  expect_true(url_is_valid(sample(hyde_files,1)))
  expect_true(url_is_valid(sample(hyde_files,1)))
  
}
)