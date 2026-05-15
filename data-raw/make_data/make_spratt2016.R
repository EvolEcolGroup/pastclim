spratt2016 <- read.table("./data-raw/data_files/sea_level_spratt2016.txt", header = TRUE)
spratt2016 <- spratt2016[, c("age_calkaBP", "SeaLev_longPC1")]
colnames(spratt2016) <- c("time_bp", "sea_level")
spratt2016$time_bp <- -spratt2016$time_bp * 1000 # convert to years BP
usethis::use_data(spratt2016, internal = TRUE, overwrite = TRUE)
