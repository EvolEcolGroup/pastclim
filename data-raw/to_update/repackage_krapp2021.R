# This script repackages the Krapp dataset, and creates an annual and monthly set
# of variables. It generates both a "full" dataset with the ice sheets, and a "land"
# dataset with land only (which is the default for pastclim)

# it can be simply run with something like
# nohup Rscript "~/git/pastclim/data-raw/to_update/repackage_krapp2020 rewrite.R" > repackage_krapp2020.log 2>&1 & 
# nohup Rscript "repackage_krapp2020 rewrite.R" > repackage_krapp2020.log 2>&1 & 


# ideally set up a conda environment before running this script
# conda create --name krapp_repackage
# conda activate krapp_repackage
# conda install -c conda-forge mamba
# mamba install -c conda-forge cdo

library(reticulate)
use_condaenv("beyer_repackage", required= FALSE)

# TO UPDATE MANUALLY
file_version <- "1.4.0"
# working directory where the final files will be stored
wkdir <- "/media/andrea/Elements/pastclim/"

# everything below here should work automatically
library(ClimateOperators)
library(ncdf4)

setwd(wkdir)

# names of directory with original files
download_dir <- file.path(wkdir,"original_files")
if (!dir.exists("./repackaged")){
  dir.create("./repackaged")
}
if (!dir.exists("./repackaged")){
  dir.create("./temp")
}
# create landmask
cdo("select,name=biome ./original_files/biome4output_800ka.nc krapp_biome.nc")
cdo ("-O -expr,'biome = ((biome < 28)) ? biome : -1' krapp_biome.nc krapp_biome2.nc")
cdo ("-O -expr,'biome = ((biome >= 0)) ? 1 : 0' krapp_biome2.nc krapp_land_only.nc")
file.remove("krapp_biome.nc", "krapp_biome2.nc")

# now process each file
for (file_id in list.files(download_dir,full.names = TRUE)){
  this_file <- basename(file_id)
  var1 <- strsplit(this_file,"_")[[1]][1]
  if (var1!="biome4output"){
    if (var1 %in% c("bio13","bio14")){ # divide by 12
      file_id_temp <- file.path("./temp",this_file)
      cdo(paste0("-z zip_5 -b F32 -divc,12. ",file_id," ",file_id_temp))
      file_id <- file_id_temp
    } else if (var1 %in% c("bio16","bio17","bio18","bio19")) # divide by 4
      file_id_temp <- file.path("./temp",this_file)
    cdo(paste0("-z zip_5 -b F32 -divc,4. ",file_id," ",file_id_temp))
    file_id <- file_id_temp
    }
    new_file <- file.path("./repackaged", paste0("Krapp2021_",var1,"_v",file_version,".nc"))

    cdo(paste0("-z zip_9 div ",file_id," krapp_land_only.nc ",new_file))
    
    # bio12 (annual -> annual)-> no conversion (use as is)
    # bio13 (annual -> monthly) -> /12
    # bio14 (annual -> monthly) -> /12
    # bio16 (annual -> quarterly) -> /4
    # bio17 (annual -> quarterly) -> /4
    # bio18 (annual -> quarterly) -> /4
    # bio19 (annual -> quarterly) -> /4
    
    
    
  } else {
    ##TODO this has not been implemented yet!!!!
    #new_file <- file.path("./repackaged/", paste0(var1,"_biome_v",file_version,".nc"))
    #ncks(paste0("-C -O -x -v pco2,npp,LAI ", file_id, " ", new_file))
    
  }
}

for (file_id in list.files("./repackaged", full.names=TRUE)){
  ncatted (paste0("-a author,global,d,, -a history,global,d,, -a description,global,d,, -a command_line,global,d,, -h ",file_id))
ncatted (paste0("-a created_by,global,c,c,'Andrea Manica' -a pastclim_version,global,c,c,'",file_version,"' ",file_id))
ncatted (paste0("-a link,global,a,c,'https://github.com/EvolEcolGroup/pastclim' -a description,global,a,c,'Data from Krapp et al 2021, with icesheets and internal seas removed, to be used by the R library pastclim' -a history,global,d,, -a history_of_appended_files,global,d,, -h ",file_id))
ncatted (paste0("-a units,time,m,c,'years since present' -h ",file_id))
ncatted (paste0("-a command_line,global,c,c,'./inst/rawdata_scripts/repackage_krapp2021.R' -h ",file_id))
}