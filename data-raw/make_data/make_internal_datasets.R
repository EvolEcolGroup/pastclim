## code to prepare internal datasets
## to be run from the root directory of the package

# `dataset_list_included` dataset
dataset_list_included <-
  read.csv("./data-raw/data_files/dataset_list_included.csv")
dataset_list_included$dataset <- as.factor(dataset_list_included$dataset)

# clark2025 sea level dataset
clark2025 <- read.csv("./data-raw/data_files/sea_level_clark2025.csv", skip=1)
clark2025 <- clark2025[, c("age", "sea_level")]
colnames(clark2025) <- c("time_bp", "sea_level")
clark2025$time_bp <- -clark2025$time_bp * 1000000 # convert to years BP
# remove any rows with NA values
clark2025 <- clark2025[complete.cases(clark2025), ]

spratt2016 <- read.table("./data-raw/data_files/sea_level_spratt2016.txt", header = TRUE)
spratt2016 <- spratt2016[, c("age_calkaBP", "SeaLev_longPC1")]
colnames(spratt2016) <- c("time_bp", "sea_level")
spratt2016$time_bp <- -spratt2016$time_bp * 1000 # convert to years BP

usethis::use_data(dataset_list_included, clark2025, spratt2016, internal = TRUE, overwrite= TRUE)
