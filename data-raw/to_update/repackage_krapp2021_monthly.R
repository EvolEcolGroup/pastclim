# Download monthly data from osf
# https://osf.io/8n43x/files/osfstorage
# Unpack all the files in ./orig_files and remove annual estimates
# download the biome file into the root directory
dir.create("./monthly")

library(ClimateOperators)
# create landmask
cdo("select,name=biome ./biome4output_800ka.nc krapp_biome.nc")
cdo("-O -expr,'biome = ((biome < 28)) ? biome : -1' krapp_biome.nc krapp_biome2.nc")
cdo("-O -expr,'biome = ((biome >= 0)) ? 1 : 0' krapp_biome2.nc krapp_land_only.nc")
unlink(c("krapp_biome.nc", "krapp_biome2.nc"))

# use the landmask to cut out the ice
library(pastclim)
month_prefix <- tolower(substr(month.name, 1, 3))
for (i in (dir("./original_files/")[34:36])) {
  # get the month
  this_month <- unlist(strsplit(unlist(strsplit(i, "_"))[3], ".", fixed = T))[1]
  this_month_id <- match(this_month, month_prefix)
  if (this_month_id < 10) {
    this_month_id <- paste0("0", this_month_id)
  }
  new_filename <- paste(unlist(strsplit(i, "_"))[1:2], collapse = "_")
  new_filename <- paste0(new_filename, "_", this_month_id, ".nc")
  new_filename <- file.path("./monthly", new_filename)
  # mask the file
  if (unlist(strsplit(i, "_"))[1] == "biome4output") {
    cdo(
      "-z zip_9 div -selname,mo_npp", file.path("./original_files", i),
      " krapp_land_only.nc ", new_filename
    )
  } else {
    cdo(
      "-z zip_9 div", file.path("./original_files", i),
      " krapp_land_only.nc ", new_filename
    )
  }
}

# rename variables
month_prefix <- tolower(substr(month.name, 1, 3))
long_var_names <- c(
  biome4output = "monthly net primary productivity", prec = "monthly precipitation",
  temp = "monthly mean temperature", tcc = "monthly total cloud cover"
)
var_names <- c(
  biome4output = "mo_npp", prec = "prec",
  temp = "temp", tcc = "tcc"
)
for (i in dir("./monthly/")) {
  this_month_id <- unlist(strsplit(unlist(strsplit(i, "_"))[3], ".", fixed = T))[1]
  this_var <- unlist(strsplit(i, "_"))[1]
  # update the variable name
  ncatted(paste0(
    "-O -a long_name,", var_names[this_var], ",o,c,'", month.name[as.numeric(this_month_id)],
    " ", long_var_names[this_var], "' ", file.path("./monthly", i)
  ))
  ncrename("-h -O -v ", csl(var_names[this_var], paste(var_names[this_var], this_month_id, sep = "_")), file.path("./monthly", i))
}

# now combine monthly estimates for each variable
cdo("-z zip_9", "merge", "./monthly/biome*.nc", "Krapp2021_npp_monthly_v1.1.0.nc")
cdo("-z zip_9", "merge", "./monthly/prec*.nc", "Krapp2021_prec_monthly_v1.1.0.nc")
cdo("-z zip_9", "merge", "./monthly/temp*.nc", "Krapp2021_temp_monthly_v1.1.0.nc")
cdo("-z zip_9", "merge", "./monthly/tcc*.nc", "Krapp2021_tcc_monthly_v1.1.0.nc")

# update time variable
for (outfile_name in c(
  "Krapp2021_npp_monthly_v1.1.0.nc", "Krapp2021_prec_monthly_v1.1.0.nc",
  "Krapp2021_temp_monthly_v1.1.0.nc", "Krapp2021_tcc_monthly_v1.1.0.nc"
)) {
  nc_in <- ncdf4::nc_open(outfile_name, write = TRUE)
  ncdf4::ncatt_put(nc_in, varid = "time", attname = "units", attval = "years since 1950-01-01 00:00:00.0")
  ncdf4::ncatt_put(nc_in, varid = "time", attname = "long_name", attval = "years BP")
  ncdf4::ncatt_put(nc_in, varid = "time", attname = "axis", attval = "T")
  ncdf4::nc_close(nc_in)
}
