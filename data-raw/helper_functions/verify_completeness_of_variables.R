# this script check that we have values for the same cells across all variables
dataset <- "Krapp2021"
library(pastclim)
download_dataset(dataset=dataset)
this_path <- pastclim::get_data_path()
vars_for_dataset <- pastclim:::get_file_for_dataset(
  get_vars_for_dataset(dataset, monthly=TRUE), dataset)

file1 <- ncdf4::nc_open(paste0(this_path, "/", vars_for_dataset$file_name[1]))
n_steps <- file1$dim$time$len
n_nas <- matrix(nrow = nrow(vars_for_dataset), ncol = n_steps)
ncdf4::nc_close(file1)
count_na <- function(var) {
  sum(is.na(var))
}
for (i in seq_len(nrow(vars_for_dataset))) {
  file1 <- ncdf4::nc_open(paste0(this_path, "/", vars_for_dataset$file_name[i]))
  this_var <- ncdf4::ncvar_get(file1, vars_for_dataset$ncvar[i])
  ncdf4::nc_close(file1)
  if (vars_for_dataset$var[i] == "biome") {
    this_var[this_var == 28] <- NA
  }
  for (x in 1:n_steps) {
    n_nas[i, x] <- count_na(this_var[, , x])
  }
}

n_uniques <- function(x) {
  length(unique(x))
}
# expect this to generate all 1s
apply(n_nas, 2, n_uniques)

# check time vars
time_steps<-get_time_steps("custom",paste0(this_path, "/", vars_for_dataset$file_name[1]))
# check that the time steps are what we expect
time_steps
# and now check that all files have the same steps
for (i in seq.int(from=2, to=nrow(vars_for_dataset))) {
  time_steps_2<-get_time_steps("custom",paste0(this_path, "/", vars_for_dataset$file_name[i]))
  if(!all(time_steps==time_steps_2)){
    stop("file ", i, "is problematic")
  }
}

  