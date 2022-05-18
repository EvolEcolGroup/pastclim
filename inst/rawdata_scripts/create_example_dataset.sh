## create example file
cdo select,name=BIO1,BIO10,BIO12,biome Beyer2020_all_vars_v1.0.0.nc example_climate_all_time.nc
ncks -O -d time,51,71,5 example_climate_all_time.nc example_climate.nc
rm example_climate_all_time.nc
ncatted -O -a description,global,m,c,"Sample dataset to be used in pastclim, a subset of Beyer2020" -h example_climate.nc
ncatted -a command_line,global,c,c,"./inst/rawdata_scripts/created_example_dataset.sh" -h example_climate.nc
