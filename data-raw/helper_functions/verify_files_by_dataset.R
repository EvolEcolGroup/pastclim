# verify that all the variables in the tables are actually found in the files
# this requires all data to have been downloaded
full_meta <- pastclim:::dataset_list_included
in_dir <- get_data_path()
problem_rows <- vector()
for (i in 1:nrow(full_meta)){
  pastclim::download_dataset(dataset = as.character(full_meta$dataset[i]),
                   bio_variables = full_meta$variable[i])
  nc_in <- ncdf4::nc_open(file.path(in_dir, full_meta$file_name[i]))
  if (!full_meta$ncvar[i] %in% names(nc_in$var)){
    message("problem with ",full_meta$ncvar[i]," in ", full_meta$file_name[i],"\n")
    problem_rows[i]<-TRUE
  } else {
    problem_rows[i]<-FALSE
  }
  ncdf4::nc_close(nc_in)
}

if (any(problem_rows)){
  which(problem_rows)
} else {
  cat("all files are fine")
}


### There is a problem with how we are renaming variables when downloading future worldclim
# monthly variables (it's not working)
# check line 78
