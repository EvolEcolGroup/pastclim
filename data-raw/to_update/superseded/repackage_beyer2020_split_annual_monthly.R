library(ClimateOperators)
library(ncdf4)
# annual variables
select_string <- "-select,name=biome,npp,lai,BIO1,BIO4,BIO5,BIO6,BIO7,BIO8,BIO9,BIO10,BIO11,BIO12,BIO13,BIO14,BIO15,BIO16,BIO17,BIO18,BIO19"
cdo("-z zip_9", select_string, "Beyer2020_all_vars_v1.0.0.nc", "Beyer2020_annual_vars_v1.1.0_temp.nc")
nc_in <- ncdf4::nc_open("Beyer2020_annual_vars_v1.1.0_temp.nc", write = TRUE)
ncdf4::ncatt_put(nc_in, varid = "time", attname = "units", attval = "years since 1950-01-01 00:00:00.0")
ncdf4::ncatt_put(nc_in, varid = "time", attname = "long_name", attval = "years BP")
ncdf4::nc_close(nc_in)

nc_in <- ncdf4::nc_open("Beyer2020_topography_v1.0.0.nc", write = TRUE)
ncdf4::ncvar_put(nc_in, varid = "time", vals = get_time_bp_steps("custom", "Beyer2020_annual_vars_v1.1.0_temp.nc"))
ncdf4::ncatt_put(nc_in, varid = "time", attname = "units", attval = "years since 1950-01-01 00:00:00.0")
ncdf4::ncatt_put(nc_in, varid = "time", attname = "long_name", attval = "years BP")
ncdf4::nc_close(nc_in)

cdo("-z zip_9 merge Beyer2020_annual_vars_v1.1.0_temp.nc Beyer2020_topography_v1.0.0.nc Beyer2020_annual_vars_v1.1.0.nc")

nc_in <- ncdf4::nc_open("Beyer2020_annual_vars_v1.1.0.nc", write = TRUE)
old_vars <- c("BIO1", "BIO4", "BIO5", "BIO6", "BIO7", "BIO8", "BIO9", "BIO10", "BIO11", "BIO12", "BIO13", "BIO14", "BIO15", "BIO16", "BIO17", "BIO18", "BIO19")
new_vars <- c("bio01", "bio04", "bio05", "bio06", "bio07", "bio08", "bio09", "bio10", "bio11", "bio12", "bio13", "bio14", "bio15", "bio16", "bio17", "bio18", "bio19")
nc_in <- ncdf4::nc_open("Beyer2020_annual_vars_v1.1.0.nc", write = TRUE)
for (i in 1:length(old_vars)) {
  nc_in <- ncdf4::ncvar_rename(nc_in,
    old_varname = old_vars[i],
    new_varname = new_vars[i]
  )
}
ncdf4::ncatt_put(nc_in,
  varid = 0, attname = "description",
  attval = "Annual variables from Beyer et al 2020, with icesheets and internal seas removed, to be used by the R library pastclim"
)
ncdf4::ncatt_put(nc_in,
  varid = 0, attname = "pastclim_version",
  attval = "1.1.0"
)
ncdf4::ncatt_put(nc_in,
  varid = 0, attname = "history",
  attval = ""
)
ncdf4::nc_close(nc_in)

######################################
# monthly variables
select_string <- "-select,name=temperature,precipitation,cloudiness,relative_humidity,wind_speed,mo_npp"
cdo("-z zip_9", select_string, "Beyer2020_all_vars_v1.0.0.nc", "Beyer2020_monthly_vars_temp.nc")
cdo("splitlevel", "Beyer2020_monthly_vars_temp.nc", "Beyer2020_monthly")
for (i in 1:12) {
  if (i < 10) {
    month_id <- paste0("0", i)
  } else {
    month_id <- i
  }
  file_name <- paste0("Beyer2020_monthly", "0000", month_id)
  cdo("vertsum", paste0(file_name, ".nc"), paste0(file_name, "s.nc"))
  nc_in <- ncdf4::nc_open(paste0(file_name, "s.nc"), write = TRUE)
  var_names <- names(nc_in$var)
  for (this_var in var_names) {
    this_var_long <- paste(
      month.name[i],
      ncdf4::ncatt_get(nc_in, this_var, attname = "long_name")$value
    )
    ncdf4::ncatt_put(nc_in, this_var,
      attname = "long_name", attval = this_var_long,
      prec = "text"
    )
    nc_in <- ncdf4::ncvar_rename(nc_in, this_var, paste0(this_var, "_", month_id))
  }
  ncdf4::nc_close(nc_in)
}

cdo("-z zip_9", "merge", "*s.nc", "Beyer2020_monthly_vars_v1.1.0.nc")

nc_in <- ncdf4::nc_open("Beyer2020_monthly_vars_v1.1.0.nc", write = TRUE)
ncdf4::ncatt_put(nc_in,
  varid = 0, attname = "description",
  attval = "Monthly variables from Beyer et al 2020, with icesheets and internal seas removed, to be used by the R library pastclim"
)
ncdf4::ncatt_put(nc_in,
  varid = 0, attname = "pastclim_version",
  attval = "1.1.0"
)
ncdf4::ncatt_put(nc_in,
  varid = 0, attname = "history",
  attval = ""
)
ncdf4::ncatt_put(nc_in, varid = "time", attname = "units", attval = "years since 1950-01-01 00:00:00.0")
ncdf4::ncatt_put(nc_in, varid = "time", attname = "long_name", attval = "years BP")
ncdf4::nc_close(nc_in)
unlink("Beyer2020_monthly0*")
unlink("Beyer2020_monthly_vars_temp.nc")
