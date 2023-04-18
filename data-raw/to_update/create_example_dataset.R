setwd(tempdir())
library(ClimateOperators)
library(pastclim)

this_file <- pastclim:::get_file_for_dataset("bio01", "Beyer2020")$file_name
this_file <- file.path(get_data_path(), this_file)


## subset to a few variables and time steps
cdo (paste0("select,name=bio01,bio10,bio12,biome ",this_file," example_climate_all_time.nc"))
ncks ("-O -d time,51,71,5 example_climate_all_time.nc example_climate_subset.nc")
ncatted ('-O -a description,global,m,c,"Sample dataset to be used in pastclim, a subset of Beyer2020" -h example_climate_subset.nc')
ncatted ('-a command_line,global,c,c,"./inst/rawdata_scripts/created_example_dataset.sh" -h example_climate_subset.nc')

# now upscale the bio variables
cdo("select,name=bio01,bio10,bio12 example_climate_subset.nc example_climate_bio.nc")
cdo("gridboxmean,2,2 example_climate_bio.nc example_climate_bio_mean.nc")
# upscale the biomes (we need to make sure that the ice and ocean masks match the observations)
cdo("select,name=biome example_climate_subset.nc example_climate_biome.nc")
# this mask is correct for the ocean mask
cdo("gridboxmax,2,2 example_climate_biome.nc example_climate_biome_max.nc")
# this mask is correct for the ice mask
cdo("gridboxmin,2,2 example_climate_biome.nc example_climate_biome_min.nc")
# create an ice mask with the correct ice
cdo ("-O -expr,'biome = ((biome < 28)) ? biome : -1' example_climate_biome_min.nc ice1.nc")
cdo ("-O -expr,'biome = ((biome >= 28)) ? 1 : 0' ice1.nc ice2.nc")
# create mask of ice that is too large
cdo ("-O -expr,'biome = ((biome < 29)) ? biome : -1' example_climate_biome_max.nc land1.nc")
cdo ("-O -expr,'biome = ((biome >= 0)) ? 1 : 0' land1.nc land2.nc")

cdo ("add ice2.nc ice_big2.nc ice_to_remove.nc")



cdo("select,name=bio01,bio10,bio12 example_climate_mean.nc example_climate_small3.nc")

cdo("gridboxmin,2,2 example_climate_subset.nc example_climate_small5.nc")


cdo("-z zip_9 merge example_climate_small3.nc example_climate_small4.nc example_climate_small5.nc")
