# repackage the Krapp2021 dataset
# 
# first download the nc files into the directory `/temp_files/krapp/original_files`
# then run this shell script from the git root

### Check if the krapp directory exists ###
if [ ! -d "./inst/rawdata_scripts/temp_files/krapp/original_files" ] 
then
    echo "Directory ./inst/rawdata_scripts/temp_files/krapp/original_files DOES NOT exists." 
    exit 9999 # die with error code 9999
fi

# create an output directory if it is needed
mkdir -p ./inst/rawdata_scripts/temp_files/krapp/repackaged
cd ./inst/rawdata_scripts/temp_files/krapp

# create landmask
cdo select,name=biome ./original_files/biome4output_800ka.nc krapp_biome.nc
cdo -O -expr,'biome = ((biome < 28)) ? biome : -1' krapp_biome.nc krapp_biome2.nc
cdo -O -expr,'biome = ((biome >= 0)) ? 1 : 0' krapp_biome2.nc krapp_land_only.nc
rm krapp_biome.nc krapp_biome2.nc

original_dir=./original_files
repackaged_dir=./repackaged
version="1.0.0"
prefix="Krapp2021"
biome="biome_output"

for filepath in "$original_dir"/*
do
  echo "$filepath"
  orig_filename=$(basename $filepath)
  IFS=_ read var1 str2  <<< "$orig_filename"
  if [ "$var1" != biome4output ]
  then
    filename="./repackaged/${prefix}_${var1}_v${version}.nc"
    echo "$filename"
    cdo -z zip_9 div $filepath krapp_land_only.nc $filename
  else
    # biome4 needs further editing (remove pCO2)
    # first extract the biomes
    filename="./repackaged/${prefix}_biome_v${version}.nc"
    ncks -C -O -x -v pco2,npp,LAI $filepath $filename
    # now process the npp
    filename="./repackaged/${prefix}_npp_v${version}.nc"
    # crop the icesheets for npp
    ncks -C -O -x -v pco2,biome,LAI $filepath npp_800ka.nc
    cdo -z zip_9 div npp_800ka.nc krapp_land_only.nc $filename
    rm npp_800ka.nc
    # and now LAI
    filename="./repackaged/${prefix}_lai_v${version}.nc"
    # crop the icesheets for npp
    ncks -C -O -x -v pco2,biome,npp $filepath lai_800ka.nc
    ncrename -v LAI,lai lai_800ka.nc
    cdo -z zip_9 div lai_800ka.nc krapp_land_only.nc $filename
    rm lai_800ka.nc
    
fi
done

for filename in "$repackaged_dir"/*
do
echo "$filename"
ncatted -a author,global,d,, -a history,global,d,, -a description,global,d,, -a command_line,global,d,, -h $filename
ncatted -a created_by,global,c,c,'Andrea Manica' -a pastclim_version,global,c,c,'1.2.3' -a link,global,a,c,'https://github.com/EvolEcolGroup/pastclim' -a description,global,a,c,'Data from Krapp et al 2021, with icesheets and internal seas removed, to be used by the R library pastclim' -a history,global,d,, -a history_of_appended_files,global,d,, -h $filename
ncatted -a units,time,m,c,"years since present" -h $filename
ncatted -a command_line,global,c,c,"./inst/rawdata_scripts/repackage_krapp2021.sh" -h $filename
done
