# set up data path for this test
data_path <- file.path(tempdir(),"pastclim_data")
unlink(data_path, recursive = TRUE) # it should not exist, but remove it just in case
# set data path
set_data_path(path_to_nc = data_path,
              ask = FALSE,
              write_config = FALSE,
              copy_example = TRUE)
example_nc_filename <- unique(files_by_dataset$file_name[files_by_dataset$dataset=="Example"])
#path_to_example_nc<- system.file(file.path("/extdata",example_nc_filename),
#                                 package = "pastclim")
path_to_example_nc <- file.path(get_data_path(),example_nc_filename)
path_to_broken_nc <- file.path(get_data_path(),"broken.nc")
################################################################################

test_that("validate_nc for custom file", {
  # error for non-existing file
  expect_error(validate_nc("blah/blah"),
              "The provided path_to_nc")
  # copy example file and start changing it for tests
  file.copy(path_to_example_nc,
            path_to_broken_nc)
  # validate before breaking
  expect_true(validate_nc(path_to_nc = path_to_broken_nc))
  # remove long name
  nc_in <- ncdf4::nc_open(path_to_broken_nc, write = TRUE)
  ncdf4::ncatt_get(nc_in,"BIO1","long_name")
  ncdf4::ncatt_put(nc = nc_in,
                   varid = "BIO1",
                   attname = "long_name", 
                   attval="", 
                   definemode = TRUE)
  ncdf4::nc_close(nc_in)
  expect_error(validate_nc(path_to_nc = path_to_broken_nc),
               "for BIO1 the longname is not given")
})

################################################################################
# clean up for the next test
unlink(data_path, recursive = TRUE)  
