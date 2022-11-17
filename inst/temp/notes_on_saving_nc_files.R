# testing times

s <- rast(system.file("ex/logo.tif", package="terra"))   

# Date"
#d <- as.Date("2001-05-04") + 0:2
d <- c(0,-1000,-2000)
d <- c(0, 1000, 2000)
time(s) <- d

time(s)

setwd(tempdir())
rr <- writeCDF(s, "test.nc", overwrite=TRUE)
foo<-rast("test.nc",  drivers="NETCDF")

foo<-rast("test.nc",  drivers="blah")

nc_in <- ncdf4::nc_open("test.nc", write=TRUE)
ncdf4::ncatt_put(nc_in, varid="time", attname="axis", attval = "T")
ncdf4::ncatt_put(nc_in, varid="easting", attname="axis", attval = "X")
ncdf4::ncatt_put(nc_in, varid="northing", attname="axis", attval = "Y")
ncdf4::ncatt_put(nc_in, varid="time", attname="units", attval = "years since present")
ncdf4::nc_close(nc_in)

## time not recognised unless it is both axis=T and a unit that is NOT unknown
## is that a terra problem, or a gdal?
foo<-rast("test.nc",  drivers="NETCDF")

# but years in terra does not allow for negative values

rr <- writeCDF(f, "test2.nc", overwrite=TRUE, varname="alt", 
               longname="elevation in m above sea level", unit="m")


f <- system.file("ex/elev.tif", package="terra")
f <-rast(f)
writeCDF(f)
g <- rast("test2.nc")
