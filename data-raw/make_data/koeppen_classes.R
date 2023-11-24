## code to prepare `koeppen_classes` dataset
## source this script in RStudio
koeppen_classes <- read.csv("./data-raw/data_files/koeppen_classes.csv")
koeppen_classes$colour <- sapply(strsplit(koeppen_classes$colour, " "), function(x)
  rgb(x[1], x[2], x[3], maxColorValue=255))
usethis::use_data(koeppen_classes, overwrite = TRUE)
