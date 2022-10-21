# Run this script from the package root to update the internal dataset
# of filenames for each variable, based on the variable_table.csv
files_by_dataset <-
  read.csv("./inst/rawdata_scripts/data_files/variable_table.csv")
files_by_dataset$dataset <- as.factor(files_by_dataset$dataset)
usethis::use_data(files_by_dataset, internal = TRUE, overwrite = TRUE)
