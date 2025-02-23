path <- "/media/andrea/Elements/resolve2017/"
# create the path if it does not exist
if (!dir.exists(path)) {
  dir.create(path)
}
# download the resolve dataset
# download.file("https://storage.googleapis.com/teow2016/Ecoregions2017.zip", destfile = file.path(path, "Ecoregions2017.zip"))

# read the zipped file
ecoregions <- terra::vect(paste0("/vsizip/", file.path(path, "Ecoregions2017.zip")))
worldclim_pres <- pastclim::region_slice(
  time_ce = 1985,
  bio_variables = c("bio01"),
  dataset = "WorldClim_2.1_10m"
)
ecoregions_rast <- terra::rast(terra::ext(worldclim_pres),
  resolution = terra::res(worldclim_pres),
  crs = terra::crs(worldclim_pres)
)

# rasterise the biomes at the resolutions of Worldclim
ecoregions_rast <- terra::rasterize(ecoregions, ecoregions_rast, field = "BIOME_NAME")
# store the levels
ecoregions_meta <- levels(ecoregions_rast)
# expand whilst there are mismatches with worldclim
while (terra::global((!is.na(worldclim_pres) & is.na(ecoregions_rast)), "sum") > 0) {
  ecoregions_rast <- terra::focal(ecoregions_rast, 3, "modal", na.policy = "only")
}

# now we mask by Worldclim
ecoregions_rast <- terra::mask(ecoregions_rast, worldclim_pres)

# reassign levels
levels(ecoregions_rast) <- ecoregions_meta
time(ecoregions_rast, "years") <- time(worldclim_pres)
# now save this
ncdf_filename <- file.path(path, "ecoregions_1985.nc")
terra::writeCDF(ecoregions_rast,
  varname = "biome",
  longname = "biome from RESOLVE Ecoregions 2017",
  filename = ncdf_filename, prec = "integer",
  overwrite = TRUE
)
# fix a few things in the netcdf file
nc_in <- ncdf4::nc_open(ncdf_filename, write = TRUE)
ncdf4::ncatt_put(nc_in, varid = "time", attname = "units", attval = "years since 1950-01-01 00:00:00.0")
ncdf4::ncatt_put(nc_in, varid = "time", attname = "long_name", attval = "years BP")
ncdf4::ncatt_put(nc_in, varid = "time", attname = "axis", attval = "T")
format_line <- function(x) {
  paste0(paste(x, collapse = "  "), "; ")
}
ncdf4::ncatt_put(nc_in,
  varid = "biome", attname = "biomes",
  attval = paste(apply(ecoregions_meta[[1]], 1, format_line), collapse = "")
)
ncdf4::nc_close(nc_in)


# TODO we need to save this as integers, and with info on the levels
