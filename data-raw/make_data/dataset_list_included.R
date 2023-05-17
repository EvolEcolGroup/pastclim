## code to prepare `dataset_list_included` dataset 
## set wkdir to this file, and source this script in RStudio 
# or run from within the data-raw directory
dataset_list_included <-
  read.csv("../inst/extdata/dataset_list_included.csv")
dataset_list_included$dataset <- as.factor(dataset_list_included$dataset)
usethis::use_data(dataset_list_included, internal = TRUE, overwrite = TRUE)
