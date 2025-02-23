etopo <- pastclim:::load_etopo()
reclass <- rbind(c(0, Inf, NA))
etopo <- terra::classify(etopo, reclass)
etopo_patch <- terra::patches(etopo)

# terra::makeTiles(etopo,c(3,3),filename="etop_sub.tif")
