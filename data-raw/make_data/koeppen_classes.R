## code to prepare `koeppen_classes` dataset
## source this script in RStudio
koeppen_classes <- read.csv("./data-raw/data_files/koeppen_classes.csv")
usethis::use_data(koeppen_classes, overwrite = TRUE)
