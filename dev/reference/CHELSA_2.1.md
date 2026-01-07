# Documentation for *CHELSA 2.1*

*CHELSA* version 2.1 is a database of high spatial resolution global
weather and climate data, covering both the present and future
projections.

## Details

IMPORTANT: If you use this dataset, make sure to cite the original
publication for the *CHELSA* dataset:

Karger, D.N., Conrad, O., Böhner, J., Kawohl, T., Kreft, H., Soria-Auza,
R.W., Zimmermann, N.E., Linder, P., Kessler, M. (2017) Climatologies at
high resolution for the Earth land surface areas. Scientific Data. 4
170122.
[doi:10.1038/sdata.2017.122](https://doi.org/10.1038/sdata.2017.122)

**Present-day reconstructions** are based on the mean for the period
1981-2000 and are available at at the high resolution of 0.5 arc-minutes
(*CHELSA_2.1_0.5m*). In `pastclim`, the datasets are given a date of
1990 CE (the mid-point of the period of interest). There are 19
“bioclimatic” variables, as well as monthly estimates for mean
temperature, and precipitation. The dataset is very large, as it
includes estimates for the oceans as well as the land masses. An
alternative to downloading the very large files is to use virtual
rasters, which allow the data to remain on the server, with only the
pixels required for a given operation being downloaded. Virtual rasters
can be used by choosing (*CHELSA_2.1_0.5m_vsi*)

**Future projections** are based on the models in CMIP6, downscaled and
de-biased using the CHELSA algorithm 2.1. Monthly values of mean
temperature, and total precipitation, as well as 19 bioclimatic
variables were processed for 5 global climate models (GCMs), and for
three Shared Socio-economic Pathways (SSPs): 126, 370 and 585. Model and
SSP can be chosen by changing the ending of the dataset name
*CHELSA_2.1_GCM_SSP_RESm*.

Available values for GCM are: "GFDL-ESM4", "IPSL-CM6A-LR",
"MPI-ESM1-2-HR", "MRI-ESM2-0", and "UKESM1-0-LL". For SSP, use:
"ssp126", "ssp370", and "ssp585". RES is currently limited to "0.5m".
Example dataset names are *CHELSA_2.1_GFDL-ESM4_ssp126_0.5m* and
*CHELSA_2.1_UKESM1-0-LL_ssp370_0.5m*

As for present reconstructions, an alternative to downloading the very
large files is to use virtual rasters. Simply append "\_vis" to the name
of the dataset of interest (*CHELSA_2.1_GFDL-ESM4_ssp126_0.5m_vsi*).

The dataset are averages over 30 year periods (2011-2040, 2041-2070,
2071-2100). In `pastclim`, the midpoints of the periods (2025, 2055,
2075) are used as the time stamps. All 3 periods are automatically
downloaded for each combination of GCM model and SSP, and are selected
as usual by defining the time in functions such as
[`region_slice()`](https://evolecolgroup.github.io/pastclim/dev/reference/region_slice.md).
