# create topographic variables for Beyer2020

#### Reformat the netcdf file (in bash)
# bring variables together: copy altitude into rugosity file
ncks -A -v altitude altitude.nc rugosity.nc
# remove crs
ncks -C -O -x -v crs rugosity.nc topography_1.nc
# add units for time and other variables
ncatted -O -a units,time,m,c,"years since present" -a units,altitude,c,c,"meters" -a units,rugosity,c,c,"standard deviation (meters)" topography_1.nc topography_2.nc
ncatted -O -a long_name,altitude,c,c,"mean altitude from ETOPO 1 minute map" -a long_name,rugosity,c,c,"rugosity from ETOPO 1 minute map" topography_2.nc topography_3.nc

# remove crs grid mapping
ncatted -a grid_mapping,rugosity,d,,  -a grid_mapping,altitude,d,, topography_3.nc topography_4.nc
# invert latitudes
cdo invertlat topography_4.nc topography_5.nc
# compress variables
nccopy -d9 topography_5.nc topography.nc
rm topography_*
cp topography.nc Beyer2020_topography_v1.0.0.nc
# remove unnecessary fields
ncatted -a history,global,d,, -a history_of_appended_files,global,d,, -a created_by,global,d,, -a date,global,d,, -h Beyer2020_topography_v1.0.0.nc 
ncatted -a created_by,global,c,c,'Andrea Manica' -a pastclim_version,global,c,c,'1.0.0' -a link,global,a,c,'https://github.com/EvolEcolGroup/pastclim' -a description,global,a,c,'Topographic varibles computed for the Beyer et al 2020, with icesheets and internal seas removed, to be used by the R library pastclim' -a history,global,d,, -a history_of_appended_files,global,d,, -h Beyer2020_topography_v1.0.0.nc
ncatted -a command_line,global,c,c,"./inst/rawdata_scripts/extract_topography_for_beyer2020_part1.R ./inst/rawdata_scripts/extract_topography_for_beyer2020_part2.sh" -h Beyer2020_topography_v1.0.0.nc
