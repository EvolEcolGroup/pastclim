# verify that all the variables in the tables are actually found in the files
# this requires all data to have been downloaded
full_meta <- read.csv("./inst/rawdata_scripts/data_files/variable_table.csv")
in_dir <- get_data_path()
in_dir <- "~/project_temp/past_climate/new_meta"
for (i in 1:nrow(full_meta)){
  nc_in <- ncdf4::nc_open(file.path(in_dir, full_meta$file_name[i]))
  if (!full_meta$ncvar[i] %in% names(nc_in$var)){
    ncdf4::nc_close(nc_in)
    stop("problem with ",full_meta$ncvar[i]," in ", full_meta$file_name[i])
  }
  ncdf4::nc_close(nc_in)
}
