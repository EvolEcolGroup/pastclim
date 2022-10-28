#!/bin/bash

# repackage the Beyer dataset
# 
# first download the two nc files into the directory `/temp_files/beyer`
# then create internal_seas.nc with `create_internal_seas_raster.R` 
# then run this shell script from `/temp_files/beyer`

## fix units
ncatted -a units,longitude,m,c,"degrees_east"  -a units,latitude,m,c,"degrees_north"  LateQuaternary_Environment_60k_Heinrich.nc LateQuaternary_Environment_u.nc
#ncatted -a units,longitude,m,c,"degrees_east"  -a units,latitude,m,c,"degrees_north"  LateQuaternary_MonthlyNPP.nc LateQuaternary_MonthlyNPP_u.nc

# create landmask
cdo select,name=biome LateQuaternary_Environment_u.nc beyer_biome.nc
cdo -O -expr,'biome = ((biome < 28)) ? biome : -1' beyer_biome.nc beyer_biome2.nc
cdo -O -expr,'biome = ((biome >= 0)) ? 1 : 0' beyer_biome2.nc beyer_land_only.nc
rm beyer_biome.nc beyer_biome2.nc

# crop the icesheets
cdo div LateQuaternary_Environment_u.nc beyer_land_only.nc LateQuaternary_Environment_no_ice.nc
ncks -A -v biome LateQuaternary_Environment_u.nc LateQuaternary_Environment_no_ice.nc
# crop icesheet for npp monthly data
#cdo div LateQuaternary_MonthlyNPP_u.nc beyer_land_only.nc LateQuaternary_MonthlyNPP_no_ice.nc
# copy over monthly npp data to main file
#ncks -A -v mo_npp LateQuaternary_MonthlyNPP_no_ice.nc LateQuaternary_Environment_no_ice.nc
# remove some temporary files
rm LateQuaternary_Environment_u.nc  beyer_land_only.nc
#rm LateQuaternary_MonthlyNPP_no_ice.nc LateQuaternary_MonthlyNPP_u.nc

# clean up the internal sea (it assumed we have internal_seas.nc)
ncatted -a units,time,m,c,"years since present" ../internal_seas.nc beyer_internal_seas2.nc
ncks -C -O -x -v crs beyer_internal_seas2.nc beyer_internal_seas3.nc
#ncks -C -O -x -v crs ../internal_seas.nc beyer_internal_seas3.nc

ncatted -a grid_mapping,internal_seas,d,, beyer_internal_seas3.nc beyer_internal_seas4.nc
cdo invertlat beyer_internal_seas4.nc beyer_internal_seas5.nc
# remove internal seas
cdo div LateQuaternary_Environment_no_ice.nc beyer_internal_seas5.nc LateQuaternary_Environment_no_internal_seas.nc
# clean up unnecessary files
rm beyer* LateQuaternary_Environment_no_ice.nc
# recompress it
nccopy -d9 LateQuaternary_Environment_no_internal_seas.nc Beyer2022h_all_vars.nc
rm LateQuaternary_Environment_no_internal_seas.nc
ncatted -a created_by,global,c,c,'Andrea Manica' -a pastclim_version,global,c,c,'1.0.0' -a link,global,a,c,'https://github.com/EvolEcolGroup/pastclim' -a description,global,a,c,'All variables from Beyer et al 2020, with icesheets and internal seas removed, to be used by the R library pastclim' -a history,global,d,, -a history_of_appended_files,global,d,, -h Beyer2022h_all_vars.nc Beyer2022h_all_vars_v1.0.0.nc
ncatted -a Contact,global,d,, -a Citation,global,d,, -a Title,global,d,, -h Beyer2022h_all_vars_v1.0.0.nc
ncatted -a command_line,global,c,c,"./inst/rawdata_scripts/repackage_beyer2022h.sh" -h Beyer2022h_all_vars_v1.0.0.nc

rm Beyer2022h_all_vars.nc

Rscript ../../repackage_beyer2022h_split_annual_monthly.R
