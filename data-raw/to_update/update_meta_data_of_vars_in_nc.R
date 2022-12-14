#read.csv(system.file("rawdata_scripts/data_files/variable_table_complete_meta.csv",
#            library="pastclim"))
library(ClimateOperators)
rm(list=ls())
dataset <- "Krapp2021"
version_number <- "1.2.2"
out_dir <- "../../project_temp/past_climate/new_meta"
full_meta <- read.csv("./inst/rawdata_scripts/data_files/variable_table_complete_meta.csv")
data_path <- get_data_path()
sub_meta <- full_meta[full_meta$dataset == dataset,]
target_files <- unique(sub_meta$file_name)

for (i in target_files){
  name_components<-unlist(strsplit(i,"_",fixed=TRUE))
  # replace the last component with new version 1.2.2
  name_components<-name_components[-length(name_components)]
  new_name <- paste(paste(name_components, collapse="_"),paste0("v", version_number,".nc"),sep="_")
  new_target_path <- file.path(out_dir, new_name)
  old_target_path <- file.path(get_data_path(),i)
  file.copy(old_target_path,new_target_path)
  nc_in <- ncdf4::nc_open(new_target_path, write = TRUE)
  # update time units
  ncdf4::ncatt_put(nc_in, varid="time", attname = "units", attval = "years since 1950-01-01 00:00:00.0")
  ncdf4::ncatt_put(nc_in,varid="time", attname = "long_name",attval = "years BP")
  # update meta units
  this_var_names <- names(nc_in$var)
  for (x in this_var_names){
    ncdf4::ncatt_put(nc_in, varid=x, attname = "long_name",
                     attval = sub_meta$long_name[sub_meta$ncvar==x])
    ncdf4::ncatt_put(nc_in, varid=x, attname = "units",
                     attval = sub_meta$units[sub_meta$ncvar==x])
  }
  ncdf4::ncatt_put(nc_in, varid = 0, attname = "pastclim_version",
                   attval=version_number)
  
  ncdf4::nc_close(nc_in)
  # now remove the attribute unit if present (it should be units)
  for (x in this_var_names){
    ncatted(paste0('-a unit,',x,',d,, -h ',new_target_path))
  }
  
}
