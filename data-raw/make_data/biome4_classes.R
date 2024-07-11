## code to prepare `koeppen_classes` dataset
## source this script in RStudio
biome4_classes <- read.csv("./data-raw/data_files/biome4_classes.csv")
biome4_classes$colour <- sapply(strsplit(biome4_classes$colour, " "), function(x) {
  rgb(x[1], x[2], x[3], maxColorValue = 100)
})
usethis::use_data(biome4_classes, overwrite = TRUE)
