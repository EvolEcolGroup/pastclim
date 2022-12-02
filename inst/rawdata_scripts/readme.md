This files provides an overivew of the scripts used to generate the data used in pastclim. All R scripts assume that you are in the root directory of the package.

NOTE: these scripts were used with terra <1.6-41, which changed the way time
is coded. Make sure that you check the scripts before running, as they might not
function as expected.

## scripts to package the climate data

1. `create_internal_seas_raster.R` generates a mask for internal seas (Caspian and Black sea) which are not removed in some reconstructions. We use a fix outline over time, as there are no good reconstructions through time of their depth levels. Based on `shapefiles_internal_seas.zip` This is used when editing the `beyer2020` dataset.

2. `repackage_beyer2020.sh` script to repackage the `beyer2020` data for use in `pastclim` (it needs the internal sea file created by 1.). This script calls
`repackage_beyer2020_split_annual_monthly.R`, which splits the annual and monthly
variables into two separate files.

3. `create_example_dataset.sh` script to create an example dataset by subsetting `beyer2020` (it needs the file created by 2.).

4. `extract_topography_for_beyer2020_part1.R` and `extract_topography_for_beyer2020_part2.sh` create the topography variables for `beyer2020`. The `R` script generates a rugosity and altitude file, and the `bash` file combines them and formats them nicely.

5. `repackage_krapp2021.sh` script to repackage the `krapp2021` data for use in `pastclim`.

6. `extract_topography_for_krapp2021_part1.R` and `extract_topography_for_krapp2021_part2.sh` create the topography variables for `krapp2021`. Due to a bug in `terra` which does not clean temp files fully, `extract_topography_for_krapp2021_part1.R` has to be run repeatedly until all time steps have been processed. The system might have to be restarted after a while to avoid running out of space on the hdd.

## scripts to create internal variables for pastclim

1. `create_getOption("pastclim.dataset_list").R` is a script to update the internal dataframe which stores the link between variable names and file names and locations. It is based on `variable_table.csv`.

2. `creat_mis_boundaries.R` create internal dataset of mis boundaries.

3. `create_region_extent.R` create internal dataset of regional extents.

4. `create_region_outlines.R` create outlines for regions


## helpful scripts

1. `verify_completeness_of_variables.R` this script is used to check that all
variables have the same extent (same number of missing values).


