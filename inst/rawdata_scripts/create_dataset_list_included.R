# Run this script from the package root to update the internal dataset
# of filenames for each variable, based on the dataset_list_included.csv
dataset_list_included <-
  read.csv("./inst/rawdata_scripts/data_files/dataset_list_included.csv")
dataset_list_included$dataset <- as.factor(dataset_list_included$dataset)
usethis::use_data(dataset_list_included, internal = TRUE, overwrite = TRUE)
