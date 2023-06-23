#' Documentation for the Example dataset
#'
#' This dataset is a subset of Beyer2020, used for the vignette of pastclim.
#' Do not use this dataset for any real work, as it might not reflect the most
#' up-to-date version of Beyer2020.
#'
#' @name Example
NULL
#> NULL

#' Documentation for the Beyer2020 dataset
#'
#' This dataset covers the last 120k years, at intervals of 1/2 k years, and a 
#' resolution of 0.5 degrees in latitude and longitude.
#' 
#' If you use this dataset, make sure to cite the original publication:
#'
#' Beyer, R.M.,
#' Krapp, M. & Manica, A. High-resolution terrestrial climate, bioclimate and
#' vegetation for the last 120,000 years. Sci Data 7, 236 (2020).
#' \doi{doi.org/10.1038/s41597-020-0552-1}
#'
#' The version included in `pastclim` has the ice sheets masked, as well as
#' internal seas (Black and Caspian Sea) removed. The latter are based on:
#'
#' \url{https://www.marineregions.org/gazetteer.php?p=details&id=4278}
#'
#' \url{https://www.marineregions.org/gazetteer.php?p=details&id=4282}
#'
#' As there is no reconstruction of their depth through time, modern outlines
#' were used for all time steps.
#'
#' Also, for bio15, the coefficient of variation was computed after adding one
#' to monthly estimates, and it was multiplied by 100 following
#' \url{https://pubs.usgs.gov/ds/691/ds691.pdf}
#'
#' Changelog
#' 
#' v1.1.0 Added monthly variables. Files can be downloaded from: 
#' \url{https://zenodo.org/deposit/7062281}
#' 
#' v1.0.0 Remove ice sheets and internal seas, and use correct formula for bio15.
#' Files can be downloaded from: 
#' \doi{doi.org/10.6084/m9.figshare.19723405.v1}
#'
#'
#' @name Beyer2020
NULL
#> NULL

#' Documentation for the Krapp2021 dataset
#'
#' This dataset covers the last 800k years, at intervals of 1k years, and a 
#' resolution of 0.5 degrees in latitude and longitude.
#'
#' If you use this dataset, make sure to cite the original publication:
#'
#' Krapp, M., Beyer, R.M., Edmundson, S.L. et al. A statistics-based
#' reconstruction of high-resolution global terrestrial climate for the last
#' 800,000 years. Sci Data 8, 228 (2021).
#' \doi{doi.org/10.1038/s41597-021-01009-3}
#'
#' The version included in `pastclim` has the ice sheets masked.
#'
#' Note that, for bio15, we use the corrected version, which follows
#' \url{https://pubs.usgs.gov/ds/691/ds691.pdf}
#'
#' Changelog
#' 
#' v1.1.0 Added monthly variables. Files can be downloaded from:
#' \url{https://zenodo.org/record/7065055}
#' 
#' v1.0.0 Remove ice sheets and use correct formula for bio15. 
#' Files can be downloaded from:
#' \doi{doi.org/10.6084/m9.figshare.19733680.v1}
#'
#' @name Krapp2021
NULL
#> NULL

#' Documentation for the WorldClim datasets
#'
#' The WorldClim version 2.1 climate datasets are based on a mean 1970-2000,
#' and were released in January 2020. In `pastclim`, the datasets are given
#' a date of 1985 CE (the mid-point of the period of interest), corresponding to
#' a time_bp of 35.
#' 
#' If you use this dataset, make sure to cite the original publication:
#'
#' Fick, S.E. and R.J. Hijmans, 2017. WorldClim 2: new 1km spatial resolution 
#' climate surfaces for global land areas. International Journal of Climatology 37 (12): 4302-4315. 
#' \doi{doi.org/10.1002/joc.5086}
#' 
#' There are monthly climate data for minimum, mean, and maximum temperature, precipitation,
#' and 19 “bioclimatic” variables.
#' 
#' There are multiple resolutions of
#' 10 arc-minutes, 5 arc-minutes, 2.5 arc-minute and 0.5 arc-minutes. The resolution
#' of interest can be obtained by changing the ending of the dataset name 
#' "WorldClim_2.1_RESm", e.g. WorldClim_2.1_10m or WorldClim_2.1_5m
#' Currently, only 10m and 5m are available on `pastclim`.
#'
#' @name WorldClim_2.1
NULL
#> NULL

#' Documentation for the WorldClim dataset at 10 arc-minute resolution
#'
#' @rdname WorldClim_2.1
#' @name WorldClim_2.1_10m
NULL
#> NULL

#' Documentation for the WorldClim dataset at 5 arc-minute resolution
#'
#' @rdname WorldClim_2.1
#' @name WorldClim_2.1_5m
NULL
#> NULL

