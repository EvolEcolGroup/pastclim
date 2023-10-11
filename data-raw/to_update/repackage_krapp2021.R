# This script repackages the Krapp dataset, and creates an annual and monthly set
# of variables. It generates both a "full" dataset with the ice sheets, and a "land"
# dataset with land only (which is the default for pastclim)

# in a directory called original_files, download the directories:
# bioclimate, precipitation, temperature, vegetation, and total_cloud_cover
# from the OSF site

# it can be simply run with something like
# nohup Rscript "~/git/pastclim/data-raw/to_update/repackage_krapp2020 rewrite.R" > repackage_krapp2020.log 2>&1 &
# nohup Rscript "repackage_krapp2020 rewrite.R" > repackage_krapp2020.log 2>&1 &


# ideally set up a conda environment before running this script
# conda create --name krapp_repackage
# conda activate krapp_repackage
# conda install -c conda-forge mamba
# mamba install -c conda-forge cdo

library(reticulate)
use_condaenv("beyer_repackage", required = TRUE)

# TO UPDATE MANUALLY
file_version <- "1.4.0"
# working directory where the final files will be stored
# wkdir <- "/media/andrea/Elements/pastclim/"
wkdir <- "~/datadisk1/pastclim_data/mario/"

# everything below here should work automatically
library(ClimateOperators)
library(ncdf4)

setwd(wkdir)

# names of directory with original files
if (!dir.exists("./repackaged")) {
  dir.create("./repackaged")
  dir.create("./repackaged/cut")
  dir.create("./repackaged/uncut")
}
if (!dir.exists("./temp")) {
  dir.create("./temp")
}

# now process the biomes
if (!dir.exists("./original_files/vegetation_annual")) {
  dir.create("./original_files/vegetation_annual")
}
if (file.exists("./original_files/vegetation/biome4output_800ka.nc")) {
  file.copy(
    "./original_files/vegetation/biome4output_800ka.nc",
    "./original_files/vegetation_annual/biome4output_800ka.nc"
  )
  file.remove("./original_files/vegetation/biome4output_800ka.nc")
}

# create landmask
cdo("select,name=biome ./original_files/vegetation_annual/biome4output_800ka.nc ./temp/krapp_biome.nc")
cdo("-O -expr,'biome = ((biome < 28)) ? biome : -1' ./temp/krapp_biome.nc ./temp/krapp_biome2.nc")
cdo("-O -expr,'biome = ((biome >= 0)) ? 1 : 0' ./temp/krapp_biome2.nc ./temp/krapp_land_only.nc")
file.remove("./temp/krapp_biome.nc", "./temp/krapp_biome2.nc")

# now process each file
download_dir <- file.path(wkdir, "original_files/bioclimate")
for (file_id in list.files(download_dir, full.names = TRUE)) {
  this_file <- basename(file_id)
  var1 <- strsplit(this_file, "_")[[1]][1]
  if (var1 %in% c("bio13", "bio14")) { # divide by 12
    file_id_temp <- file.path("./temp", this_file)
    cdo(paste0("-z zip_5 -b F32 -divc,12. ", file_id, " ", file_id_temp))
    file_id <- file_id_temp
  } else if (var1 %in% c("bio16", "bio17", "bio18", "bio19")) { # divide by 4
    file_id_temp <- file.path("./temp", this_file)
    cdo(paste0("-z zip_5 -b F32 -divc,4. ", file_id, " ", file_id_temp))
    file_id <- file_id_temp
  }
  new_file_cut <- file.path("./repackaged/cut", paste0("Krapp2021_", var1, "_v", file_version, ".nc"))
  new_file_uncut <- file.path("./repackaged/uncut", paste0("Krapp2021_uncut_", var1, "_v", file_version, ".nc"))

  cdo(paste0("-z zip_9 div ", file_id, " ./temp/krapp_land_only.nc ", new_file_cut))

  ## TODO this needs to be reinstated to create uncut files
  # file.copy(from= file_id, to=new_file_uncut)
  # NOTE that the above does not recompress the file
  # cdo(paste0("-z zip_9 ",file_id," ",new_file_uncut))
}


## TODO this has not been implemented yet!!!!
# new_file <- file.path("./repackaged/", paste0(var1,"_biome_v",file_version,".nc"))
# ncks(paste0("-C -O -x -v pco2,npp,LAI ", file_id, " ", new_file))

###################
# Monthly variables
###################
monthly_dirs <- c("precipitation", "temperature", "vegetation", "total_cloud_cover")
monthly_dirs <- file.path(wkdir, "original_files", monthly_dirs)

# first combine the files into single uncut files
# first we need to change the var names (so, copy over and change var name)
# cdo ("-z zip_9", "merge","./monthly/biome*.nc","Krapp2021_npp_monthly_v1.1.0.nc")
# cdo ("-z zip_9", "merge","./original_files/precipitation/prec*.nc",
#      paste0("./repackaged/uncut/Krapp2021_uncut_prec_monthly_v", file_version,".nc"))
# cdo ("-z zip_9", "merge","./monthly/temp*.nc","Krapp2021_temp_monthly_v1.1.0.nc")
# cdo ("-z zip_9", "merge","./monthly/tcc*.nc","Krapp2021_tcc_monthly_v1.1.0.nc")
#


# ##TODO
# #We need a temp/monthly directory
#
# # use the landmask to cut out the ice
# month_prefix<-tolower(substr(month.name,1,3))
# for (this_file in list.files(monthly_dirs, full.names = TRUE)){
#   i <- basename(this_file)
#   # get the month
#   this_month<-unlist(strsplit(unlist(strsplit(i,"_"))[3],".",fixed=T))[1]
#   this_month_id <- match(this_month,month_prefix)
#   if (this_month_id<10){
#     this_month_id <- paste0("0",this_month_id)
#   }
#   new_filename<-paste(unlist(strsplit(i,"_"))[1:2],collapse="_")
#   new_filename<-paste0(new_filename,"_",this_month_id,".nc")
#   new_filename<-file.path("./temp/monthly",new_filename)
#   # mask the file
#   if (unlist(strsplit(i,"_"))[1]=="biome4output"){
#     cdo ("-z zip_9 div -selname,mo_npp",this_file,
#          " krapp_land_only.nc ", new_filename)} else
#          { cdo ("-z zip_9 div",this_file,
#                 " krapp_land_only.nc ", new_filename)}
# }
#
# # rename variables
# month_prefix<-tolower(substr(month.name,1,3))
# long_var_names<-c(biome4output="monthly net primary productivity",prec="monthly precipitation",
#                   temp="monthly mean temperature",tcc="monthly total cloud cover")
# var_names<-c(biome4output="mo_npp",prec="prec",
#              temp="temp",tcc="tcc")
# for (i in dir("./monthly/")){
#   this_month_id<-unlist(strsplit(unlist(strsplit(i,"_"))[3],".",fixed=T))[1]
#   this_var <- unlist(strsplit(i,"_"))[1]
#   # update the variable name
#   ncatted (paste0("-O -a long_name,",var_names[this_var],",o,c,'",month.name[as.numeric(this_month_id)],
#                   " ",long_var_names[this_var],"' ",file.path("./monthly",i)))
#   ncrename("-h -O -v ",csl(var_names[this_var],paste(var_names[this_var],this_month_id,sep="_")),file.path("./monthly",i))
# }
#
# # now combine monthly estimates for each variable
# cdo ("-z zip_9", "merge","./monthly/biome*.nc","Krapp2021_npp_monthly_v1.1.0.nc")
# cdo ("-z zip_9", "merge","./monthly/prec*.nc","Krapp2021_prec_monthly_v1.1.0.nc")
# cdo ("-z zip_9", "merge","./monthly/temp*.nc","Krapp2021_temp_monthly_v1.1.0.nc")
# cdo ("-z zip_9", "merge","./monthly/tcc*.nc","Krapp2021_tcc_monthly_v1.1.0.nc")

## example commands for monthly variables to change units
# cdo -z zip_9 -b F32 subc,273.15 Krapp2021_temp_monthly_v1.2.2.nc Krapp2021_temp_monthly_v1.4.0.nc
# cdo -z zip_9 -b F32 divc,12. Krapp2021_prec_monthly_v1.2.2.nc Krapp2021_prec_monthly_v1.4.0.nc
# ncatted -a pastclim_version,global,m,c,'1.4.0' Krapp2021_temp_monthly_v1.4.0.nc
# ncatted -a pastclim_version,global,m,c,'1.4.0' Krapp2021_prec_monthly_v1.4.0.nc




# NOTE this needs to be changed to work for uncut as well.
for (file_id in list.files("./repackaged/cut", full.names = TRUE)) {
  ncatted(paste0("-a author,global,d,, -a history,global,d,, -a description,global,d,, -a command_line,global,d,, -h ", file_id))
  ncatted(paste0("-a created_by,global,c,c,'Andrea Manica' -a pastclim_version,global,c,c,'", file_version, "' ", file_id))
  ncatted(paste0("-a link,global,a,c,'https://github.com/EvolEcolGroup/pastclim' -a description,global,a,c,'Data from Krapp et al 2021, with icesheets and internal seas removed, to be used by the R library pastclim' -a history,global,d,, -a history_of_appended_files,global,d,, -h ", file_id))
  # ncatted (paste0("-a units,time,m,c,'years since 1950-01-01 00:00:00.0' -h ",file_id))
  ncatted(paste0("-a command_line,global,c,c,'./inst/rawdata_scripts/repackage_krapp2021.R' -h ", file_id))
  # format time axis
  nc_in <- ncdf4::nc_open(file_id, write = TRUE)
  ncdf4::ncatt_put(nc_in, varid = "time", attname = "units", attval = "years since 1950-01-01 00:00:00.0")
  ncdf4::ncatt_put(nc_in, varid = "time", attname = "long_name", attval = "years BP")
  ncdf4::ncatt_put(nc_in, varid = "time", attname = "axis", attval = "T")
  ncdf4::nc_close(nc_in)
}

# clean up the metadata for the variables based on the information from the pastclim table
full_meta <- pastclim:::dataset_list_included
sub_meta <- full_meta[full_meta$dataset == "Krapp2021", ]
for (i_ncfile in list.files("./repackaged/cut", full.names = TRUE)) {
  nc_in <- ncdf4::nc_open(i_ncfile, write = TRUE)
  # update meta units
  this_var_names <- names(nc_in$var)
  for (x in this_var_names) {
    ncdf4::ncatt_put(nc_in,
      varid = x, attname = "long_name",
      attval = sub_meta$long_name[sub_meta$ncvar == x]
    )
    ncdf4::ncatt_put(nc_in,
      varid = x, attname = "units",
      attval = sub_meta$units[sub_meta$ncvar == x]
    )
  }
  ncdf4::nc_close(nc_in)
  # now remove the attribute unit if present (it should be units)
  for (x in this_var_names) {
    ncatted(paste0("-a unit,", x, ",d,, -h ", i_ncfile))
  }
}
