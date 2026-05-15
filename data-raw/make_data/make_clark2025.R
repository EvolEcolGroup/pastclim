clark2025 <- read.csv("./data-raw/data_files/sea_level_clark2025.csv", skip=1)
clark2025 <- clark2025[, c("age", "sea_level")]
colnames(clark2025) <- c("time_bp", "sea_level")
clark2025$time_bp <- -clark2025$time_bp * 1000000 # convert to years BP
# remove any rows with NA values
clark2025 <- clark2025[complete.cases(clark2025), ]
usethis::use_data(clark2025, internal = TRUE, overwrite = TRUE)
