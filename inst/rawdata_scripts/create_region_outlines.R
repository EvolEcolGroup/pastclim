library(sf)
library(terra)
outlines <- read.csv("./inst/rawdata_scripts/data_files/continent_outlines.csv",
                     stringsAsFactors = TRUE)
outlines["X"] <- round(outlines["X"], 2)
outlines["Y"] <- round(outlines["Y"], 2)
# remove Antarctica, for whith the corodinates are problematic as they cross
# the the 90 latitude line
outlines <- outlines[outlines$id != "Antarctica", ]
outlines$id <- as.factor(as.character(outlines$id))
# create data.frame to store objects
outlines_df <- data.frame(name = levels(outlines$id), geometry = NA)
for (i in 1:nlevels(outlines$id)) {
  this_outline <- subset(outlines, id == levels(outlines$id)[i])
  this_coords <- as.matrix(this_outline[, c("X", "Y")])
  outlines_df$geometry[i] <- sf::st_sfc(sf::st_polygon(list(this_coords)))
}
europe<-data.frame(name="Europe", geometry = "POLYGON ((60 32.58, 33.79 32.58, 32.45 34.02, 
30.47 35.15, 28.93 35.65, 27.19 34.88, 24.84 34.02, 22.93 34.43, 21.99 35.73, 
16.16 36.25, 14.25 35.21, 13.14 36.06, 11.97 37.46, 11.13 38.1, 9.32 38.49, 
7.91 38.2, 6.67 40.08, 3.69 38.81, 1.58 37.88, -0.50 36.95, -1.61 36.38, 
-3.05 36, -4.29 35.92, -6.93 35.95, -9.08 36.41, -11.29 38.02, -11.06 41.41,
-9.88 44.27, -8.44 46.9, -6.63 48.4, -8.01 49.54, -9.72 50.64, -12.40 51.36, 
-15.21 55.45, -25.00 62.07, -27.15 66.09, -22.45 67.46, -16.82 68.47, 
-9.58 69.22, -9.65 72.43, -0.80 77.05, 13.68 80.95, 34.59 81.68, 60 81.68, 
60 32.58 ))")
europe <- sf::st_as_sf(europe, wkt="geometry")
outlines_df <- rbind(outlines_df, europe)
outlines_df <- sf::st_sf(outlines_df,
  sf_column_name = "geometry",
  crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"
)
region_outline_union <- outlines_df
region_outline_union<-as.list(outlines_df$geometry)
names(region_outline_union)<-outlines_df$name
usethis::use_data(region_outline_union, overwrite = TRUE)
# wrap_around_the antimeridian
outlines_df <- sf::st_wrap_dateline(outlines_df, options = c("WRAPDATELINE=YES",
                                                          "DATELINEOFFSET=180"))
region_outline<-as.list(outlines_df$geometry)
names(region_outline)<-outlines_df$name
usethis::use_data(region_outline, overwrite = TRUE)
