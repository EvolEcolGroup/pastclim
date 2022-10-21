## create example file
cdo select,name=BIO1,BIO10,BIO12,biome Beyer2020_all_vars_v1.0.0.nc example_climate_all_time.nc
ncks -O -d time,51,71,5 example_climate_all_time.nc example_climate.nc
rm example_climate_all_time.nc
ncatted -O -a description,global,m,c,"Sample dataset to be used in pastclim, a subset of Beyer2020" -h example_climate.nc
ncatted -a command_line,global,c,c,"./inst/rawdata_scripts/created_example_dataset.sh" -h example_climate.nc

# create small example file
cdo("gridboxmean,2,2 example_climate.nc example_climate_small.nc")
cdo("gridboxmax,2,2 example_climate.nc example_climate_small2.nc")
cdo("select,name=BIO1,BIO10,BIO12 example_climate_small.nc example_climate_small3.nc")
cdo("select,name=biome example_climate_small2.nc example_climate_small4.nc")
cdo("-z zip_9 merge example_climate_small3.nc example_climate_small4.nc example_climate_small5.nc")