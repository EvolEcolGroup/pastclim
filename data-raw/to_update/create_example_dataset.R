# This script generates the example dataset, extracting data from Beyer2020 for
# only a few time steps, and upscaling to 1 degree to reduce the file size

# TO UPDATE MANUALLY
file_version <- "1.3.0"

# everything else works automatically

# generate the file name based on the version name
file_name <- paste0("example_climate_v", file_version, ".nc")

setwd(tempdir())
library(ClimateOperators)
library(pastclim)

beyer_file <- pastclim:::get_var_meta("bio01", "Beyer2020")$file_name
beyer_file <- file.path(get_data_path(), this_file)

## subset to a few variables and time steps
cdo(paste0("select,name=bio01,bio10,bio12,biome ", beyer_file, " ex_all_time.nc"))
ncks("-O -d time,51,71,5 ex_all_time.nc ex_subset.nc")
ncatted('-O -a description,global,m,c,"Sample dataset to be used in pastclim, a subset of Beyer2020" -h ex_subset.nc')

# now upscale the bio variables
cdo("select,name=bio01,bio10,bio12 ex_subset.nc ex_bio.nc")
cdo("gridboxmean,2,2 ex_bio.nc ex_bio_mean.nc")
# upscale the biomes (we need to make sure that the ice and ocean masks match the observations)
cdo("select,name=biome ex_subset.nc ex_biome.nc")
# this mask is correct for the ocean mask
cdo("gridboxmax,2,2 ex_biome.nc ex_biome_max.nc")
# this mask is correct for the ice mask
cdo("gridboxmin,2,2 ex_biome.nc ex_biome_min.nc")
# create an ice mask with the correct ice
cdo("-O -expr,'biome = ((biome < 28)) ? 0 : -1' ex_biome_min.nc ice1.nc")
# create mask of ice that is too large
cdo("-O -expr,'biome = ((biome == 28)) ? 1 : 0' ex_biome_max.nc ice_big.nc")
# get the difference
cdo("-O add ice1.nc ice_big.nc ice_to_remove.nc")
cdo("-O chname,biome,to_remove ice_to_remove.nc ice_to_remove_rename.nc")
cdo("-O merge ex_biome_max.nc ice_to_remove_rename.nc ex_biome_temp.nc")
cdo("-O -expr,'biome = ((to_remove == 1)) ? 27 : biome' ex_biome_temp.nc ex_biome_correct.nc")
# extract the new biome
cdo("select,name=biome ex_biome_correct.nc ex_biome_only.nc")
# copy all attributes (which were lost) to the file
attr_src <- ncdf4::nc_open("ex_all_time.nc")
attr_dest <- ncdf4::nc_open("ex_biome_only.nc", write = TRUE)
ncdf4.helpers::nc.copy.atts(attr_src, "biome", attr_dest, "biome",
  exception.list = c("_FillValue")
)
ncdf4::nc_close(attr_src)
ncdf4::nc_close(attr_dest)

# change the names (we use it to test the ability to convert names if needed)
cdo("-O chname,bio01,BIO1,bio10,BIO10,bio12,BIO12", "ex_bio_mean.nc", "ex_bio_mean_rename.nc")

cdo("-O -z zip_9 merge ex_bio_mean_rename.nc ex_biome_only.nc", file_name)

ncatted('-a command_line,global,m,c,"./inst/rawdata_scripts/created_example_dataset.R" -h', file_name)
ncatted('-a history,global,m,c,"" -h', file_name)
ncatted(paste0('-a pastclim_version,global,m,c,"', file_version, '" -h'), file_name)
cdo("-O -z zip_9 merge ex_bio_mean.nc ex_biome_only.nc", "example_to_rename.nc")
file.copy(file_name, to = "~/git/pastclim/inst/extdata/", overwrite = TRUE)
