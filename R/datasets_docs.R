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
#' IMPORTANT: If you use this dataset, make sure to cite the original publication:
#'
#' Beyer, R.M.,
#' Krapp, M. & Manica, A. High-resolution terrestrial climate, bioclimate and
#' vegetation for the last 120,000 years. Sci Data 7, 236 (2020).
#' \doi{10.1038/s41597-020-0552-1}
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
#' \doi{10.6084/m9.figshare.19723405.v1}
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
#' IMPORTANT: If you use this dataset, make sure to cite the original publication:
#'
#' Krapp, M., Beyer, R.M., Edmundson, S.L. et al. A statistics-based
#' reconstruction of high-resolution global terrestrial climate for the last
#' 800,000 years. Sci Data 8, 228 (2021).
#' \doi{10.1038/s41597-021-01009-3}
#'
#' The version included in `pastclim` has the ice sheets masked.
#'
#' Note that, for bio15, we use the corrected version, which follows
#' \url{https://pubs.usgs.gov/ds/691/ds691.pdf}
#'
#' Changelog
#'
#' v1.4.0 Change units to match WorldClim. Fix variable duplication found
#' on earlier versions of the dataset. \url{https://zenodo.org/records/8415273}
#'
#' v1.1.0 Added monthly variables. Files can be downloaded from:
#' \url{https://zenodo.org/record/7065055}
#'
#' v1.0.0 Remove ice sheets and use correct formula for bio15.
#' Files can be downloaded from:
#' \doi{10.6084/m9.figshare.19733680.v1}
#'
#' @name Krapp2021
NULL
#> NULL

#' Documentation for the WorldClim datasets
#'
#' WorldClim version 2.1 is a database of high spatial resolution global weather and
#' climate data, covering both the present and future projections. 
#' 
#' IMPORTANT: If you use this
#' dataset, make sure to cite the original publication:
#'
#' Fick, S.E. and R.J. Hijmans, 2017. WorldClim 2: new 1km spatial resolution
#' climate surfaces for global land areas. International Journal of Climatology 37 (12): 4302-4315.
#' \doi{10.1002/joc.5086}
#'
#' **Present-day reconstructions** are based on the mean for the period 1970-2000,
#' and are available at multiple resolutions of
#' 10 arc-minutes, 5 arc-minutes, 2.5 arc-minute and 0.5 arc-minutes. The resolution
#' of interest can be obtained by changing the ending of the dataset name
#' *WorldClim_2.1_RESm*, e.g. *WorldClim_2.1_10m* or *WorldClim_2.1_5m*
#' (currently, only 10m and 5m are currently available in `pastclim`). In `pastclim`, the datasets are given
#' a date of 1985 CE (the mid-point of the period of interest). There are 19 “bioclimatic” variables, as well as monthly
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
#' *WorldClim_2.1_ACCESS-CM2_ssp245_10m* and *WorldClim_2.1_MRI-ESM2-0_ssp370_5m*.
#' Four combination (namely *FIO-ESM-2-0_ssp370*, *GFDL-ESM4_ssp245*, 
#' *GFDL-ESM4_ssp585*, and *HadGEM3-GC31-LL_ssp370*) are NOT available.
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


#' Documentation for the Barreto et al 2023 dataset
#'
#' Spatio-temporal series of monthly temperature and precipitation and 17
#' derived bioclimatic variables covering the last 5 Ma (Pliocene–Pleistocene),
#' at intervals of 1,000 years, and a spatial resolution of 1
#' arc-degrees (see Barreto et al., 2023 for details).
#'
#' PALEO-PGEM-Series is downscaled to 1 × 1 arc-degrees spatial resolution from the
#' outputs of the PALEO-PGEM emulator (Holden et al., 2019), which emulates
#' reasonable and extensively validated global estimates of monthly temperature
#' and precipitation for the Plio-Pleistocene every 1 kyr at a spatial
#' resolution of ~5 × 5 arc-degrees (Holden et al., 2016, 2019).
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
#' IMPORTANT: If you use this dataset, make sure to cite the original publications:
#'
#'  Barreto, E., Holden, P. B., Edwards, N. R., & Rangel, T. F. (2023).
#'  PALEO-PGEM-Series: A spatial time series of the global climate over the
#'   last 5 million years (Plio-Pleistocene). Global Ecology and
#'    Biogeography, 32, 1034-1045,
#'    \doi{10.1111/geb.13683}
#'
#' Holden, P. B., Edwards, N. R., Rangel, T. F., Pereira, E. B., Tran, G. T.,
#'  and Wilkinson, R. D. (2019): PALEO-PGEM v1.0: a statistical emulator of
#'   Pliocene–Pleistocene climate, Geosci. Model Dev., 12, 5137–5155,
#'    \doi{10.5194/gmd-12-5137-2019}.
#'
#' @name Barreto2023
NULL
#> NULL

#' Documentation for *HYDE 3.3* dataset
#'
#' This database presents an update and expansion of the History Database of
#' the Global Environment (HYDE, v 3.3) and replaces former HYDE 3.2
#' version from 2017. HYDE is and internally consistent combination of
#' updated historical population estimates and land use. Categories
#' include cropland, with a new distinction into irrigated and rain fed
#' crops (other than rice) and irrigated and rain fed rice. Also grazing
#' lands are provided, divided into more intensively used pasture,
#' converted rangeland and non-converted natural (less intensively used)
#' rangeland. Population is represented by maps of total, urban, rural
#' population and population density as well as built-up area.
#'
#' The period covered is 10 000 BCE to 2023 CE. Spatial resolution is
#' 5 arc minutes (approx. 85 km2 at the equator). The full *HYDE 3.3* release
#' contains: a Baseline estimate scenario, a Lower estimate scenario and an
#' Upper estimate scenario. Currently only the baseline scenario is available
#' in `pastclim`
#'
#' More details on the dataset are available on its 
#' dedicated \href{https://hyde-portal.geo.uu.nl/}{website}.
#' 
#' IMPORTANT: If you use this dataset, make sure to cite the original publication
#' for the HYDE 3.2 (there is no current publication for 3.3):
#'
#' Klein Goldewijk, K., Beusen, A., Doelman, J., and Stehfest, E.:
#' Anthropogenic land-use estimates for the Holocene; HYDE 3.2,
#' Earth Syst. Sci. Data, 9, 927-953, 2017. \doi{10.5194/essd-9-1-2017}
#'
#' @name HYDE_3.3_baseline
NULL
#> NULL

#' Documentation for *CHELSA 2.1*
#'
#' *CHELSA* version 2.1 is a database of high spatial resolution global weather and
#' climate data, covering both the present and future projections. 
#' 
#' IMPORTANT: If you use this dataset, make sure to cite the original publication
#' for the *CHELSA* dataset:
#'
#' Karger, D.N., Conrad, O., Böhner, J., Kawohl, T., Kreft, H., 
#' Soria-Auza, R.W., Zimmermann, N.E., Linder, P., Kessler, M. (2017) 
#' Climatologies at high resolution for the Earth land surface areas. 
#' Scientific Data. 4 170122. \doi{10.1038/sdata.2017.122}
#' 
#' #' **Present-day reconstructions** are based on the mean for the period 1981-2000
#' and are available at at the high resolution of 0.5 arc-minutes (*CHELSA_2.1_0.5m*).
#' In `pastclim`, the datasets are given
#' a date of 1985 CE (the mid-point of the period of interest). There are 19 “bioclimatic” variables, as well as monthly
#' estimates for mean temperature, and precipitation. The dataset is very large, as it
#' includes estimates for the oceans as well as the land masses. An alternative to
#' downloading the very large files is to use virtual rasters, which allow the
#' data to remain on the server, with only the pixels required for a given operation
#' being downloaded. Virtual rasters can be used by choosing (*CHELSA_2.1_0.5m_vsi*)
#'
#' **Future projections** are based on the models in CMIP6, downscaled and de-biased
#' using the CHELSA algorithm 2.1. Monthly values of mean temperature, 
#' and total precipitation, as well as 19 bioclimatic
#' variables were processed for
#' 5 global climate models (GCMs), and for three
#' Shared Socio-economic Pathways (SSPs): 126, 370 and 585. Model and
#' SSP can be chosen by changing the ending of the dataset name
#' *CHELSA_2.1_GCM_SSP_RESm*.
#'
#' Available values for GCM are: "GFDL-ESM4", "IPSL-CM6A-LR", "MPI-ESM1-2-HR",
#' "MRI-ESM2-0", and "UKESM1-0-LL". For SSP, use: "ssp126",
#' "ssp370",	and "ssp585". RES is currently limited to "0.5m". Example dataset names are
#' *CHELSA_2.1_GFDL-ESM4_ssp126_0.5m* and *CHELSA_2.1_UKESM1-0-LL_ssp370_0.5m*
#' 
#' As for present reconstructions, an alternative to
#' downloading the very large files is to use virtual rasters. Simply append
#' "_vis" to the name of the dataset of interest (*CHELSA_2.1_GFDL-ESM4_ssp126_0.5m_vsi*).
#'
#' The dataset are averages over 30 year
#' periods (2011-2040, 2041-2070, 2071-2100).
#' In `pastclim`, the midpoints of the periods (2025, 2055, 2075) are used as the time stamps. All 3 periods
#' are automatically downloaded for each combination of GCM model and SSP, and are selected
#' as usual by defining the time in functions such as [region_slice()].
#' 
#' @name CHELSA_2.1
NULL
#> NULL

#' Documentation for *Paleoclim*
#'
#' *Paleoclim* is a set of high resolution paleoclimate reconstructions, mostly
#' based on the CESM model, downscaled with the CHELSA dataset to 3  different 
#' spatial resolutions: `paleoclim_1.0_2.5m` at 2.5 arc-minutes (~5 km),
#'  `paleoclim_1.0_5m` at 5 arc-minutes (~10 km), 
#' and `paleoclim_1.0_10m` 10 arc-minutes (~20 km). All 19 biovariables are available.
#' There are only a limited number of time slices available for this dataset;
#' furthermore, currently only time slices from present to 130ka are available 
#' in `pastclim`.
#' 
#' More details on the dataset are available on its dedicated \href{http://www.paleoclim.org/}{website}.
#' 
#' IMPORTANT: If you use this dataset, make sure to cite the original publication:
#'
#' Brown, Hill, Dolan, Carnaval, Haywood (2018) PaleoClim, high spatial
#'  resolution paleoclimate surfaces for global land areas.  
#'  Nature – Scientific Data. 5:180254
#'
#' @name paleoclim_1.0
NULL
#> NULL

#' Documentation for the paleoclim dataset at 10 arc-minute resolution
#'
#' @rdname paleoclim_1.0
#' @name paleoclim_1.0_10m
NULL
#> NULL

#' Documentation for the paleoclim dataset at 5 arc-minute resolution
#'
#' @rdname paleoclim_1.0
#' @name paleoclim_1.0_5m
NULL
#> NULL

#' Documentation for the paleoclim dataset at 2.5 arc-minute resolution
#'
#' @rdname paleoclim_1.0
#' @name paleoclim_1.0_2.5m
NULL
#> NULL

