# This script repackages the Beyer dataset, and creates an annual and monthly set
# of variables. It generates both a "full" dataset with the ice sheets, and a "land"
# dataset with land only (which is the default for pastclim)

# it can be simply run with something like
# nohup Rscript "~/git/pastclim/data-raw/to_update/repackage_beyer2020 rewrite.R" > repackage_beyer2020.log 2>&1 & 
# nohup Rscript "repackage_beyer2020 rewrite.R" > repackage_beyer2020.log 2>&1 & 


# ideally set up a conda environment before running this script
# conda create --name beyer_repackage
# conda activate beyer_repackage
# conda install -c conda-forge mamba
# mamba install -c conda-forge cdo

library(reticulate)
use_condaenv("beyer_repackage")

# TO UPDATE MANUALLY
file_version <- "1.3.1"
# working directory where the final files will be stored
wkdir <- "~/datadisk1/project_temp/repackage_beyer"

# everything below here should work automatically
library(ClimateOperators)
library(ncdf4)

#output file names
uncut_ann_filename <- paste0("Beyer2020_uncut_annual_vars_v",file_version,".nc")
uncut_month_filename <- paste0("Beyer2020_uncut_monthly_vars_v",file_version,".nc")
ann_filename <- paste0("Beyer2020_annual_vars_v",file_version,".nc")
month_filename <- paste0("Beyer2020_monthly_vars_v",file_version,".nc")

# first download the two nc files into the directory `/temp_files/beyer`
# then create internal_seas.nc with `create_internal_seas_raster.R` 
# then run this shell script from `/temp_files/beyer`
################################################################################
# set up the working environment

# if the working path does not exist, create it
if (!dir.exists(wkdir)){
  dir.create(wkdir)
}
# input file names
beyer1_filename <- file.path(wkdir,"LateQuaternary_Environment.nc")
beyer2_filename <- file.path(wkdir, "LateQuaternary_MonthlyNPP.nc")
setwd(wkdir)
# if the file is not there yet, download it
if (!file.exists(beyer1_filename)){
  curl::multi_download("https://figshare.com/ndownloader/files/22659026",
                       destfiles = beyer1_filename)
}
if (!file.exists(beyer2_filename)){
  curl::multi_download("https://figshare.com/ndownloader/files/28567032",
                       destfiles = beyer2_filename)
}

################################################################################
# Now combine the files into a single file
dir.create("temp", showWarnings=FALSE)
# empty it if it already exists
unlink("./temp/*")
# move to temp
setwd("temp")
## fix missing values
cdo("-setmissval,nan", beyer1_filename, "LateQuaternary_Environment_miss.nc")
cdo("-setmissval,nan", beyer2_filename, "LateQuaternary_Environment_MonthlyNPP_miss.nc")

## fix units
ncatted(paste('-a units,longitude,m,c,"degrees_east"  -a units,latitude,m,c,"degrees_north"',
              "LateQuaternary_Environment_miss.nc","LateQuaternary_Environment_u.nc"))
ncatted(paste('-a units,longitude,m,c,"degrees_east"  -a units,latitude,m,c,"degrees_north"',
              "LateQuaternary_Environment_MonthlyNPP_miss.nc","LateQuaternary_MonthlyNPP_u.nc"))
# copy over monthly npp data to main file
ncks("-A -v mo_npp LateQuaternary_MonthlyNPP_u.nc LateQuaternary_Environment_u.nc")
# clean up attributes
ncatted ("-a Contact,global,d,, -a Citation,global,d,, -a Title,global,d,, -a Source,global,d,, -a history_of_appended_files,global,d,, -h LateQuaternary_Environment_u.nc")

# remove the unencessary NPP file
file.remove(c("LateQuaternary_MonthlyNPP_u.nc","LateQuaternary_Environment_miss.nc","LateQuaternary_Environment_MonthlyNPP_miss.nc"))

################################################################################
# Fix BIO15
nc_in <- ncdf4::nc_open("LateQuaternary_Environment_u.nc",
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


## MISSING bring in the topography variables

################################################################################
# Extract the annual variables
select_string <- "-select,name=biome,npp,lai,BIO1,BIO4,BIO5,BIO6,BIO7,BIO8,BIO9,BIO10,BIO11,BIO12,BIO13,BIO14,BIO15,BIO16,BIO17,BIO18,BIO19"
cdo(select_string,"LateQuaternary_Environment_u.nc","LateQuaternary_Environment_annual.nc")
# fix climate units
nc_in<-ncdf4::nc_open("LateQuaternary_Environment_annual.nc",write=TRUE)
ncdf4::ncatt_put(nc_in,varid="time", attname = "units",attval = "years since 1950-01-01 00:00:00.0")
ncdf4::ncatt_put(nc_in,varid="time", attname = "long_name",attval = "years BP")
old_vars<-c('BIO1','BIO4','BIO5','BIO6','BIO7','BIO8','BIO9','BIO10','BIO11','BIO12','BIO13','BIO14','BIO15','BIO16','BIO17','BIO18','BIO19')
new_vars<-c('bio01','bio04','bio05','bio06','bio07','bio08','bio09','bio10','bio11','bio12','bio13','bio14','bio15','bio16','bio17','bio18','bio19')
for (i in 1:length(old_vars)){
  nc_in<-ncdf4::ncvar_rename(nc_in, old_varname = old_vars[i],
                             new_varname = new_vars[i])
}
ncdf4::ncatt_put(nc_in, varid = 0, attname = "description",
                 attval = "Annual variables from Beyer et al 2020 to be used by the R library pastclim")
ncdf4::ncatt_put(nc_in, varid = 0, attname = "pastclim_version",
                 attval=file_version)
ncdf4::ncatt_put(nc_in, varid = 0, attname = "history",
                 attval="")
ncdf4::nc_close(nc_in)
# now compress it and copy it over to the main directory
cdo("pack","LateQuaternary_Environment_annual.nc",uncut_ann_filename)
# copy it over to the output directory
file.copy (uncut_ann_filename,file.path(wkdir, uncut_ann_filename),
           overwrite = TRUE)


################################################################################
# Extract the monthly variables
# We need to work in a further subdirectory as we will first split the variables into individual fiels and then merge them back together


select_string <- "-select,name=temperature,precipitation,cloudiness,relative_humidity,wind_speed,mo_npp"
cdo("-z zip_9",select_string,"LateQuaternary_Environment_u.nc","LateQuaternary_Environment_monthly.nc")
cdo("splitlevel","LateQuaternary_Environment_monthly.nc","Beyer2020_monthly")
for (i in 1:12){
  if (i<10){
    month_id<-paste0("0",i)
  } else {
    month_id<-i
  }
  file_name<-paste0("Beyer2020_monthly","0000",month_id)
  cdo("vertsum",paste0(file_name,".nc"),paste0(file_name,"split.nc"))
  nc_in<-ncdf4::nc_open(paste0(file_name,"split.nc"),write=TRUE)
  var_names <- names(nc_in$var)
  for (this_var in var_names){
    this_var_long <- paste(month.name[i],
                           ncdf4::ncatt_get(nc_in, this_var, attname="long_name")$value)
    ncdf4::ncatt_put(nc_in, this_var, attname="long_name",attval=this_var_long,
                     prec="text")
    nc_in<-ncdf4::ncvar_rename(nc_in,this_var,paste0(this_var,"_",month_id))
  }
  ncdf4::nc_close(nc_in)
}

cdo ("-z zip_9", "merge","*split.nc",uncut_month_filename)

nc_in<-ncdf4::nc_open(paste0("Beyer2020_uncut_monthly_vars_v",file_version,".nc"),write=TRUE)
ncdf4::ncatt_put(nc_in, varid = 0, attname = "description",
                 attval = "Monthly variables from Beyer et al 2020 to be used by the R library pastclim")
ncdf4::ncatt_put(nc_in, varid = 0, attname = "pastclim_version",
                 attval=file_version)
ncdf4::ncatt_put(nc_in, varid = 0, attname = "history",
                 attval="")
ncdf4::ncatt_put(nc_in,varid="time", attname = "units",attval = "years since 1950-01-01 00:00:00.0")
ncdf4::ncatt_put(nc_in,varid="time", attname = "long_name",attval = "years BP")
ncdf4::nc_close(nc_in)
unlink("Beyer2020_monthly0*")
file.copy (uncut_month_filename,file.path(wkdir, uncut_month_filename))

################################
# Now remove ice sheets and internal seas

# create landmask
cdo('select,name=biome LateQuaternary_Environment_u.nc beyer_biome.nc')
cdo("-O -expr,'biome = ((biome < 28)) ? biome : -1' beyer_biome.nc beyer_biome2.nc")
cdo("-O -expr,'biome = ((biome >= 0)) ? 1 : 0' beyer_biome2.nc beyer_land_only.nc")
file.remove("beyer_biome.nc","beyer_biome2.nc")

# crop the icesheets
cdo("div ", uncut_ann_filename," beyer_land_only.nc", "annual_no_ice.nc")
# readd the biome variables (which we don't want cropped for ice)
ncks("-A -v biome", uncut_ann_filename," annual_no_ice.nc")
# crop icesheet for  monthly data
cdo("div ", uncut_month_filename,"beyer_land_only.nc","monthly_no_ice.nc")

# create an internal sea raster
library(pastclim)
mask_base <- region_slice(time_bp = 0, "biome", dataset = "custom", path_to_nc = uncut_ann_filename)
#internal_seas <- terra::vect(system.file("extdata/internal_seas.RDS",package="pastclim"))
internal_seas <- terra::vect("~/git/pastclim/inst/extdata/internal_seas.RDS")
internal_seas<- rasterize(internal_seas, mask_base)
internal_seas[internal_seas == 1] <- 0
internal_seas[is.nan(internal_seas)] <- 1
writeCDF(internal_seas, "internal_seas.nc",
         varname="internal_seas", overwrite=TRUE)

# clean up the internal sea (it assumed we have internal_seas.nc)
# this might not be needed
#ncatted('-a units,time,m,c,"years since 1950-01-01 00:00:00.0", internal_seas.nc beyer_internal_seas2.nc')
ncks ("-C -O -x -v crs internal_seas.nc beyer_internal_seas3.nc")
ncatted ("-a grid_mapping,internal_seas,d,, beyer_internal_seas3.nc beyer_internal_seas4.nc")
cdo ("invertlat beyer_internal_seas4.nc beyer_internal_seas5.nc")

# remove internal seas
cdo ("-z zip_9 div "," annual_no_ice.nc beyer_internal_seas5.nc", ann_filename)
# readd the biome variables (which we don't want cropped for ice)
ncks("-A -v biome", uncut_ann_filename,ann_filename)
# TODO we need to add the internal seas to biome 0 (i.e. water bodies)
cdo ("-z zip_9 div "," monthly_no_ice.nc beyer_internal_seas5.nc", month_filename)

# clean up attributes
nc_in<-ncdf4::nc_open(ann_filename,write=TRUE)
ncdf4::ncatt_put(nc_in, varid = 0, attname = "description",
                 attval = "Annual variables from Beyer et al 2020, with ice sheets and internal seas removed, to be used by the R library pastclim")
ncdf4::ncatt_put(nc_in, varid = 0, attname = "history",
                 attval="")
ncdf4::nc_close(nc_in)

nc_in<-ncdf4::nc_open(month_filename,write=TRUE)
ncdf4::ncatt_put(nc_in, varid = 0, attname = "description",
                 attval = "Monthly variables from Beyer et al 2020, with ice sheets and internal seas removed, to be used by the R library pastclim")
ncdf4::ncatt_put(nc_in, varid = 0, attname = "history",
                 attval="created with repackage_beyer2020.R")
ncdf4::nc_close(nc_in)
