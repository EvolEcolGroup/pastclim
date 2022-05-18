nc_in <- ncdf4::nc_open("/home/andrea/R/x86_64-pc-linux-gnu-library/4.2/pastclimData/extdata/Beyer2020_all_vars_v1.0.0.nc",
  write = TRUE
)
precipitation <- ncdf4::ncvar_get(nc_in, "precipitation")
precipitation <- precipitation + 1

for (i in 1:(dim(precipitation)[4])) {
  precipitation_sub <- precipitation[, , , i]
  precipitation_rast <- terra::rast(precipitation_sub)
  precipitation_sd <- terra::app(x = precipitation_rast, fun = sd)
  precipitation_mean <- terra::app(x = precipitation_rast, fun = mean)
  precipitation_cv <- (precipitation_sd / precipitation_mean) * 100
  ncdf4::ncvar_put(nc_in, "BIO15", as.matrix(precipitation_cv, wide = TRUE),
    start = c(1, 1, i), count = c(-1, -1, 1)
  )
}

ncdf4::nc_close(nc_in)
