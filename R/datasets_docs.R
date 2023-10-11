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
#' The units of several variables have been changed to match what is used
#' in WorldClim.
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
#' v1.4.0 Change units to match WorldClim. Fix variable duplication found
#' on earlier versions of the dataset.
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
#' WorldClim version 2.1 is a database of high spatial resolution global weather and
#' climate data, covering both the present and future projections. If you use this
#' dataset, make sure to cite the original publication:
#'
#' Fick, S.E. and R.J. Hijmans, 2017. WorldClim 2: new 1km spatial resolution
#' climate surfaces for global land areas. International Journal of Climatology 37 (12): 4302-4315.
#' \doi{doi.org/10.1002/joc.5086}
#'
#' **Present-day reconstructions** are based on the mean for the period 1970-2000,
#' and are available at multiple resolutions of
#' 10 arc-minutes, 5 arc-minutes, 2.5 arc-minute and 0.5 arc-minutes. The resolution
#' of interest can be obtained by changing the ending of the dataset name
#' *WorldClim_2.1_RESm*, e.g. *WorldClim_2.1_10m* or *WorldClim_2.1_5m*
#' (currently, only 10m and 5m are currently available in `pastclim`). In `pastclim`, the datasets are given
#' a date of 1985 CE (the mid-point of the period of interest), corresponding to
#' a time_bp of 35. There are 19 “bioclimatic” variables, as well as monthly
#' estimates for minimum, mean, and maximum temperature, and precipitation.
#'
#' **Future projections** are based on the models in CMIP6, downscaled and de-biased
#' using WorldClim 2.1 for the present as a baseline. Monthly values of minimum
#' temperature, maximum temperature, and precipitation, as well as 19 bioclimatic
#' variables were processed for
#' 23 global climate models (GCMs), and for four
#' Shared Socio-economic Pathways (SSPs): 126, 245, 370 and 585. Model and
#' SSP can be chosen by changing the ending of the dataset name
#' *WorldClim_2.1_GCM_SSP_RESm*.
#'
#' Available values for GCM are: "ACCESS-CM2",
#' "BCC-CSM2-MR", "CMCC-ESM2", "EC-Earth3-Veg", "FIO-ESM-2-0",
#' "GFDL-ESM4", "GISS-E2-1-G", "HadGEM3-GC31-LL", "INM-CM5-0", "IPSL-CM6A-LR",
#' "MIROC6", "MPI-ESM1-2-HR", "MRI-ESM2-0", and "UKESM1-0-LL". For SSP, use: "ssp126",
#' "ssp245",	"ssp370",	and "ssp585". RES takes the same values as for present reconstructions
#' (i.e. "10m", "5m", "2.5m", and "0.5m"). Example dataset names are
#' *WorldClim_2.1_ACCESS-CM2_ssp245_10m* and *WorldClim_2.1_MRI-ESM2-0_ssp370_5m*
#'
#' The dataset are averages over 20 year
#' periods (2021-2040, 2041-2060, 2061-2080, 2081-2100).
#' In `pastclim`, the midpoints of the periods (2030, 2050, 2070, 2090) are used as the time stamps. All 4 periods
#' are automatically downloaded for each combination of GCM model and SSP, and are selected
#' as usual by defining the time in functions such as [region_slice()].
#'
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

#' Documentation for the Barreto et al 2023 dataset
#'
#' Spatio-temporal series of monthly temperature and precipitation and 17
#' derived bioclimatic variables covering the last 5 Ma (Pliocene–Pleistocene),
#' at intervals of 1,000 years, and a spatial resolution of 1
#' degrees (see Barreto et al., 2023 for details).
#'
#' PALEO-PGEM-Series is downscaled to 1° × 1° spatial resolution from the
#' outputs of the PALEO-PGEM emulator (Holden et al., 2019), which emulates
#' reasonable and extensively validated global estimates of monthly temperature
#' and precipitation for the Plio-Pleistocene every 1 kyr at a spatial
#' resolution of ~5° × 5° (Holden et al., 2016, 2019).
#'
#' PALEO-PGEM-Series includes the mean and the standard deviation (i.e.,
#' standard error) of the emulated climate over 10 stochastic GCM emulations
#' to accommodate aspects of model uncertainty. This allows users to estimate
#' the robustness of their results in the face of the stochastic aspects of
#' the emulations. For more details, see Section 2.4 in Barreto et al. (2023).
#'
#' Note that this is a very large dataset, with 5001 time slices. It takes
#' approximately 1 minute to set up each variable when creating a region_slice or
#' region_series. However, once the object has been created, other operations tend
#' to be much faster (especially if you subset the dataset to a small number
#' of time steps of interest).
#'
#' If you use this dataset, make sure to cite the original publications:
#'
#'  Barreto, E., Holden, P. B., Edwards, N. R., & Rangel, T. F. (2023).
#'  PALEO-PGEM-Series: A spatial time series of the global climate over the
#'   last 5 million years (Plio-Pleistocene). Global Ecology and
#'    Biogeography, 00, 1– 12.
#'    \doi{doi.org/10.1111/geb.13683}
#'
#' Holden, P. B., Edwards, N. R., Rangel, T. F., Pereira, E. B., Tran, G. T.,
#'  and Wilkinson, R. D. (2019): PALEO-PGEM v1.0: a statistical emulator of
#'   Pliocene–Pleistocene climate, Geosci. Model Dev., 12, 5137–5155,
#'    \doi{doi.org/10.5194/gmd-12-5137-2019}.
#'
#' @name Barreto2023
NULL
#> NULL
