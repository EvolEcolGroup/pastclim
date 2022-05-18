# repackage the Krapp2021 dataset
# 
# first download the nc files into the directory `/temp_files/krapp/original_files`
# then run this shell script from `/temp_files/krapp`

cd ./inst/rawdata_scripts/temp_files/krapp

original_dir=./original_files
repackaged_dir=./rm_ice

for filepath in "$repackaged_dir"/*
do
echo "$filepath"
ncatted -a author,global,d,, -a history,global,d,, -a description,global,d,, -a command_line,global,d,, -h $filepath
ncatted -a created_by,global,c,c,'Andrea Manica' -a pastclim_version,global,c,c,'1.0.0' -a link,global,a,c,'https://github.com/EvolEcolGroup/pastclim' -a description,global,a,c,'Data from Krapp et al 2021, with icesheets and internal seas removed, to be used by the R library pastclim' -a history,global,d,, -a history_of_appended_files,global,d,, -h $filepath
ncatted -a units,time,m,c,"years since present" -h $filepath
ncatted -a command_line,global,c,c,"./inst/rawdata_scripts/repackage_krapp2021.sh" -h $filepath
done
