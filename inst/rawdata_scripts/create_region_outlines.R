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
#region_outline <- outlines_df
#
region_outline<-as.list(outlines_df$geometry)
names(region_outline)<-outlines_df$name
usethis::use_data(region_outline, overwrite = TRUE)
