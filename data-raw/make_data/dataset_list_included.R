## code to prepare `dataset_list_included` dataset
## set wkdir to the directory of this script, and source this script in RStudio
# or run from within the data-raw/make_data directory
dataset_list_included <-
  read.csv("../data_files/dataset_list_included.csv")
dataset_list_included$dataset <- as.factor(dataset_list_included$dataset)
usethis::use_data(dataset_list_included, internal = TRUE, overwrite = TRUE)
