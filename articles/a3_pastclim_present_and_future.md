# present and future

Whilst `pastclim` is mostly designed to handle palaeoclimate time
series, it can also be used to manipulate present reconstructions and
future projections. Currently, it covers the WorldClim and the CHELSA
datasets, but it could easily be adapted to use other sources.

## Present reconstructions

### WorldClim

Present-day reconstructions for WorldClim v2.1 are based on the mean for
the period 1970-2000, and are available at multiple resolutions of 10
arc-minutes, 5 arc-minutes, 2.5 arc-minute and 0.5 arc-minutes. The
resolution of interest can be obtained by changing the ending of the
dataset name *WorldClim_2.1_RESm*, e.g. *WorldClim_2.1_10m* or
*WorldClim_2.1_5m*. In `pastclim`, the datasets are given a date of 1985
CE (the mid-point of the period of interest). There are 19 “bioclimatic”
variables, as well as monthly estimates for minimum, mean, and maximum
temperature, and precipitation.

So, the annual variables for the 10m arc-minutes dataset are:

``` r

library(pastclim)
#> Loading required package: terra
#> terra 1.9.38
get_vars_for_dataset("WorldClim_2.1_10m")
#>  [1] "bio01"    "bio02"    "bio03"    "bio04"    "bio05"    "bio06"   
#>  [7] "bio07"    "bio08"    "bio09"    "bio10"    "bio11"    "bio12"   
#> [13] "bio13"    "bio14"    "bio15"    "bio16"    "bio17"    "bio18"   
#> [19] "bio19"    "altitude"
```

And the monthly variables

``` r

get_vars_for_dataset("WorldClim_2.1_10m", monthly = TRUE, annual = FALSE)
#>  [1] "temperature_01"     "temperature_02"     "temperature_03"    
#>  [4] "temperature_04"     "temperature_05"     "temperature_06"    
#>  [7] "temperature_07"     "temperature_08"     "temperature_09"    
#> [10] "temperature_10"     "temperature_11"     "temperature_12"    
#> [13] "precipitation_01"   "precipitation_02"   "precipitation_03"  
#> [16] "precipitation_04"   "precipitation_05"   "precipitation_06"  
#> [19] "precipitation_07"   "precipitation_08"   "precipitation_09"  
#> [22] "precipitation_10"   "precipitation_11"   "precipitation_12"  
#> [25] "temperature_min_01" "temperature_min_02" "temperature_min_03"
#> [28] "temperature_min_04" "temperature_min_05" "temperature_min_06"
#> [31] "temperature_min_07" "temperature_min_08" "temperature_min_09"
#> [34] "temperature_min_10" "temperature_min_11" "temperature_min_12"
#> [37] "temperature_max_01" "temperature_max_02" "temperature_max_03"
#> [40] "temperature_max_04" "temperature_max_05" "temperature_max_06"
#> [43] "temperature_max_07" "temperature_max_08" "temperature_max_09"
#> [46] "temperature_max_10" "temperature_max_11" "temperature_max_12"
```

We can manipulate data in the usual way. We start by downloading the
dataset:

``` r

download_dataset(
  dataset = "WorldClim_2.1_10m",
  bio_variables = c("bio01", "bio02", "altitude")
)
```

We can then use `region_slice` to extract the data as a `SpatRaster`:

``` r

climate_present <- region_slice(
  time_ce = 1985,
  bio_variables = c("bio01", "bio02", "altitude"),
  dataset = "WorldClim_2.1_10m"
)
```

### CHELSA

Present-day reconstructions for CHELSA v2.1 are based on the mean for
the period 1981-2000, and are available at the high resolution of 0.5
arc-minutes. *CHELSA_2.1_0.5m*. In `pastclim`, the datasets are given a
date of 1990 CE (the mid-point of the period of interest). There are 19
“bioclimatic” variables, as well as monthly estimates for minimum, mean,
and maximum temperature, and precipitation.

So, the annual variables for the CHELSA dataset are:

``` r

library(pastclim)
get_vars_for_dataset("CHELSA_2.1_0.5m")
#>  [1] "bio01" "bio02" "bio03" "bio04" "bio05" "bio06" "bio07" "bio08" "bio09"
#> [10] "bio10" "bio11" "bio12" "bio13" "bio14" "bio15" "bio16" "bio17" "bio18"
#> [19] "bio19" "npp"
```

And the monthly variables

``` r

get_vars_for_dataset("CHELSA_2.1_0.5m", monthly = TRUE, annual = FALSE)
#>  [1] "temperature_01"     "temperature_02"     "temperature_03"    
#>  [4] "temperature_04"     "temperature_05"     "temperature_06"    
#>  [7] "temperature_07"     "temperature_08"     "temperature_09"    
#> [10] "temperature_10"     "temperature_11"     "temperature_12"    
#> [13] "precipitation_01"   "precipitation_02"   "precipitation_03"  
#> [16] "precipitation_04"   "precipitation_05"   "precipitation_06"  
#> [19] "precipitation_07"   "precipitation_08"   "precipitation_09"  
#> [22] "precipitation_10"   "precipitation_11"   "precipitation_12"  
#> [25] "temperature_max_01" "temperature_max_02" "temperature_max_03"
#> [28] "temperature_max_04" "temperature_max_05" "temperature_max_06"
#> [31] "temperature_max_07" "temperature_max_08" "temperature_max_09"
#> [34] "temperature_max_10" "temperature_max_11" "temperature_max_12"
#> [37] "temperature_min_01" "temperature_min_02" "temperature_min_03"
#> [40] "temperature_min_04" "temperature_min_05" "temperature_min_06"
#> [43] "temperature_min_07" "temperature_min_08" "temperature_min_09"
#> [46] "temperature_min_10" "temperature_min_11" "temperature_min_12"
```

We can manipulate data in the usual way. We start by downloading the
dataset:

``` r

download_dataset(
  dataset = "CHELSA_2.1_0.5m",
  bio_variables = c("bio01", "bio02")
)
```

We can then use `region_slice` to extract the data as a `SpatRaster`:

``` r

climate_present <- region_slice(
  time_ce = 1990,
  bio_variables = c("bio01", "bio02"),
  dataset = "CHELSA_2.1_0.5m"
)
```

The datasets for each variable are very large due to the high
resolution. Besides downloading the data, it is also possible to use a
virtual raster, leaving the files on the server, and only downloading
the pixels that are needed. We can achieve that by using the dataset
*CHELSA_2.1_0.5_vsi*.

We still need to download the dataset first, but rather than downloading
all the files, this sets up the virtual raster (and so it is very
fast!):

``` r

download_dataset(
  dataset = "CHELSA_2.1_0.5m_vsi",
  bio_variables = c("bio12", "temperature_01")
)
```

Once downloaded, we can use it as any other dataset:

``` r

climate_present <- region_slice(
  time_ce = 1990,
  bio_variables = c("bio12", "temperature_01"),
  dataset = "CHELSA_2.1_0.5m_vsi"
)
```

This is ideal if you just need to extract climate for a number of
locations, and do not need to get the full map.

## Future projections

### WorldClim

Future projections are based on the models in CMIP6, downscaled and
de-biased using WorldClim 2.1 for the present as a baseline. Monthly
values of minimum temperature, maximum temperature, and precipitation,
as well as 19 bioclimatic variables were processed for 23 global climate
models (GCMs), and for four Shared Socio-economic Pathways (SSPs): 126,
245, 370 and 585. Model and SSP can be chosen by changing the ending of
the dataset name *WorldClim_2.1_GCM_SSP_RESm*.

A complete list of available combinations can be obtained with:

``` r

list_available_datasets()[grepl("WorldClim_2.1", list_available_datasets())]
#>   [1] "WorldClim_2.1_0.5m"                       
#>   [2] "WorldClim_2.1_10m"                        
#>   [3] "WorldClim_2.1_2.5m"                       
#>   [4] "WorldClim_2.1_5m"                         
#>   [5] "WorldClim_2.1_ACCESS-CM2_ssp126_0.5m"     
#>   [6] "WorldClim_2.1_ACCESS-CM2_ssp126_10m"      
#>   [7] "WorldClim_2.1_ACCESS-CM2_ssp126_2.5m"     
#>   [8] "WorldClim_2.1_ACCESS-CM2_ssp126_5m"       
#>   [9] "WorldClim_2.1_ACCESS-CM2_ssp245_0.5m"     
#>  [10] "WorldClim_2.1_ACCESS-CM2_ssp245_10m"      
#>  [11] "WorldClim_2.1_ACCESS-CM2_ssp245_2.5m"     
#>  [12] "WorldClim_2.1_ACCESS-CM2_ssp245_5m"       
#>  [13] "WorldClim_2.1_ACCESS-CM2_ssp370_0.5m"     
#>  [14] "WorldClim_2.1_ACCESS-CM2_ssp370_10m"      
#>  [15] "WorldClim_2.1_ACCESS-CM2_ssp370_2.5m"     
#>  [16] "WorldClim_2.1_ACCESS-CM2_ssp370_5m"       
#>  [17] "WorldClim_2.1_ACCESS-CM2_ssp585_0.5m"     
#>  [18] "WorldClim_2.1_ACCESS-CM2_ssp585_10m"      
#>  [19] "WorldClim_2.1_ACCESS-CM2_ssp585_2.5m"     
#>  [20] "WorldClim_2.1_ACCESS-CM2_ssp585_5m"       
#>  [21] "WorldClim_2.1_BCC-CSM2-MR_ssp126_0.5m"    
#>  [22] "WorldClim_2.1_BCC-CSM2-MR_ssp126_10m"     
#>  [23] "WorldClim_2.1_BCC-CSM2-MR_ssp126_2.5m"    
#>  [24] "WorldClim_2.1_BCC-CSM2-MR_ssp126_5m"      
#>  [25] "WorldClim_2.1_BCC-CSM2-MR_ssp245_0.5m"    
#>  [26] "WorldClim_2.1_BCC-CSM2-MR_ssp245_10m"     
#>  [27] "WorldClim_2.1_BCC-CSM2-MR_ssp245_2.5m"    
#>  [28] "WorldClim_2.1_BCC-CSM2-MR_ssp245_5m"      
#>  [29] "WorldClim_2.1_BCC-CSM2-MR_ssp370_0.5m"    
#>  [30] "WorldClim_2.1_BCC-CSM2-MR_ssp370_10m"     
#>  [31] "WorldClim_2.1_BCC-CSM2-MR_ssp370_2.5m"    
#>  [32] "WorldClim_2.1_BCC-CSM2-MR_ssp370_5m"      
#>  [33] "WorldClim_2.1_BCC-CSM2-MR_ssp585_0.5m"    
#>  [34] "WorldClim_2.1_BCC-CSM2-MR_ssp585_10m"     
#>  [35] "WorldClim_2.1_BCC-CSM2-MR_ssp585_2.5m"    
#>  [36] "WorldClim_2.1_BCC-CSM2-MR_ssp585_5m"      
#>  [37] "WorldClim_2.1_CMCC-ESM2_ssp126_0.5m"      
#>  [38] "WorldClim_2.1_CMCC-ESM2_ssp126_10m"       
#>  [39] "WorldClim_2.1_CMCC-ESM2_ssp126_2.5m"      
#>  [40] "WorldClim_2.1_CMCC-ESM2_ssp126_5m"        
#>  [41] "WorldClim_2.1_CMCC-ESM2_ssp245_0.5m"      
#>  [42] "WorldClim_2.1_CMCC-ESM2_ssp245_10m"       
#>  [43] "WorldClim_2.1_CMCC-ESM2_ssp245_2.5m"      
#>  [44] "WorldClim_2.1_CMCC-ESM2_ssp245_5m"        
#>  [45] "WorldClim_2.1_CMCC-ESM2_ssp370_0.5m"      
#>  [46] "WorldClim_2.1_CMCC-ESM2_ssp370_10m"       
#>  [47] "WorldClim_2.1_CMCC-ESM2_ssp370_2.5m"      
#>  [48] "WorldClim_2.1_CMCC-ESM2_ssp370_5m"        
#>  [49] "WorldClim_2.1_CMCC-ESM2_ssp585_0.5m"      
#>  [50] "WorldClim_2.1_CMCC-ESM2_ssp585_10m"       
#>  [51] "WorldClim_2.1_CMCC-ESM2_ssp585_2.5m"      
#>  [52] "WorldClim_2.1_CMCC-ESM2_ssp585_5m"        
#>  [53] "WorldClim_2.1_EC-Earth3-Veg_ssp126_0.5m"  
#>  [54] "WorldClim_2.1_EC-Earth3-Veg_ssp126_10m"   
#>  [55] "WorldClim_2.1_EC-Earth3-Veg_ssp126_2.5m"  
#>  [56] "WorldClim_2.1_EC-Earth3-Veg_ssp126_5m"    
#>  [57] "WorldClim_2.1_EC-Earth3-Veg_ssp245_0.5m"  
#>  [58] "WorldClim_2.1_EC-Earth3-Veg_ssp245_10m"   
#>  [59] "WorldClim_2.1_EC-Earth3-Veg_ssp245_2.5m"  
#>  [60] "WorldClim_2.1_EC-Earth3-Veg_ssp245_5m"    
#>  [61] "WorldClim_2.1_EC-Earth3-Veg_ssp370_0.5m"  
#>  [62] "WorldClim_2.1_EC-Earth3-Veg_ssp370_10m"   
#>  [63] "WorldClim_2.1_EC-Earth3-Veg_ssp370_2.5m"  
#>  [64] "WorldClim_2.1_EC-Earth3-Veg_ssp370_5m"    
#>  [65] "WorldClim_2.1_EC-Earth3-Veg_ssp585_0.5m"  
#>  [66] "WorldClim_2.1_EC-Earth3-Veg_ssp585_10m"   
#>  [67] "WorldClim_2.1_EC-Earth3-Veg_ssp585_2.5m"  
#>  [68] "WorldClim_2.1_EC-Earth3-Veg_ssp585_5m"    
#>  [69] "WorldClim_2.1_FIO-ESM-2-0_ssp126_0.5m"    
#>  [70] "WorldClim_2.1_FIO-ESM-2-0_ssp126_10m"     
#>  [71] "WorldClim_2.1_FIO-ESM-2-0_ssp126_2.5m"    
#>  [72] "WorldClim_2.1_FIO-ESM-2-0_ssp126_5m"      
#>  [73] "WorldClim_2.1_FIO-ESM-2-0_ssp245_0.5m"    
#>  [74] "WorldClim_2.1_FIO-ESM-2-0_ssp245_10m"     
#>  [75] "WorldClim_2.1_FIO-ESM-2-0_ssp245_2.5m"    
#>  [76] "WorldClim_2.1_FIO-ESM-2-0_ssp245_5m"      
#>  [77] "WorldClim_2.1_FIO-ESM-2-0_ssp585_0.5m"    
#>  [78] "WorldClim_2.1_FIO-ESM-2-0_ssp585_10m"     
#>  [79] "WorldClim_2.1_FIO-ESM-2-0_ssp585_2.5m"    
#>  [80] "WorldClim_2.1_FIO-ESM-2-0_ssp585_5m"      
#>  [81] "WorldClim_2.1_GFDL-ESM4_ssp126_0.5m"      
#>  [82] "WorldClim_2.1_GFDL-ESM4_ssp126_10m"       
#>  [83] "WorldClim_2.1_GFDL-ESM4_ssp126_2.5m"      
#>  [84] "WorldClim_2.1_GFDL-ESM4_ssp126_5m"        
#>  [85] "WorldClim_2.1_GFDL-ESM4_ssp370_0.5m"      
#>  [86] "WorldClim_2.1_GFDL-ESM4_ssp370_10m"       
#>  [87] "WorldClim_2.1_GFDL-ESM4_ssp370_2.5m"      
#>  [88] "WorldClim_2.1_GFDL-ESM4_ssp370_5m"        
#>  [89] "WorldClim_2.1_GISS-E2-1-G_ssp126_0.5m"    
#>  [90] "WorldClim_2.1_GISS-E2-1-G_ssp126_10m"     
#>  [91] "WorldClim_2.1_GISS-E2-1-G_ssp126_2.5m"    
#>  [92] "WorldClim_2.1_GISS-E2-1-G_ssp126_5m"      
#>  [93] "WorldClim_2.1_GISS-E2-1-G_ssp245_0.5m"    
#>  [94] "WorldClim_2.1_GISS-E2-1-G_ssp245_10m"     
#>  [95] "WorldClim_2.1_GISS-E2-1-G_ssp245_2.5m"    
#>  [96] "WorldClim_2.1_GISS-E2-1-G_ssp245_5m"      
#>  [97] "WorldClim_2.1_GISS-E2-1-G_ssp370_0.5m"    
#>  [98] "WorldClim_2.1_GISS-E2-1-G_ssp370_10m"     
#>  [99] "WorldClim_2.1_GISS-E2-1-G_ssp370_2.5m"    
#> [100] "WorldClim_2.1_GISS-E2-1-G_ssp370_5m"      
#> [101] "WorldClim_2.1_GISS-E2-1-G_ssp585_0.5m"    
#> [102] "WorldClim_2.1_GISS-E2-1-G_ssp585_10m"     
#> [103] "WorldClim_2.1_GISS-E2-1-G_ssp585_2.5m"    
#> [104] "WorldClim_2.1_GISS-E2-1-G_ssp585_5m"      
#> [105] "WorldClim_2.1_HadGEM3-GC31-LL_ssp126_0.5m"
#> [106] "WorldClim_2.1_HadGEM3-GC31-LL_ssp126_10m" 
#> [107] "WorldClim_2.1_HadGEM3-GC31-LL_ssp126_2.5m"
#> [108] "WorldClim_2.1_HadGEM3-GC31-LL_ssp126_5m"  
#> [109] "WorldClim_2.1_HadGEM3-GC31-LL_ssp245_0.5m"
#> [110] "WorldClim_2.1_HadGEM3-GC31-LL_ssp245_10m" 
#> [111] "WorldClim_2.1_HadGEM3-GC31-LL_ssp245_2.5m"
#> [112] "WorldClim_2.1_HadGEM3-GC31-LL_ssp245_5m"  
#> [113] "WorldClim_2.1_HadGEM3-GC31-LL_ssp585_0.5m"
#> [114] "WorldClim_2.1_HadGEM3-GC31-LL_ssp585_10m" 
#> [115] "WorldClim_2.1_HadGEM3-GC31-LL_ssp585_2.5m"
#> [116] "WorldClim_2.1_HadGEM3-GC31-LL_ssp585_5m"  
#> [117] "WorldClim_2.1_INM-CM5-0_ssp126_0.5m"      
#> [118] "WorldClim_2.1_INM-CM5-0_ssp126_10m"       
#> [119] "WorldClim_2.1_INM-CM5-0_ssp126_2.5m"      
#> [120] "WorldClim_2.1_INM-CM5-0_ssp126_5m"        
#> [121] "WorldClim_2.1_INM-CM5-0_ssp245_0.5m"      
#> [122] "WorldClim_2.1_INM-CM5-0_ssp245_10m"       
#> [123] "WorldClim_2.1_INM-CM5-0_ssp245_2.5m"      
#> [124] "WorldClim_2.1_INM-CM5-0_ssp245_5m"        
#> [125] "WorldClim_2.1_INM-CM5-0_ssp370_0.5m"      
#> [126] "WorldClim_2.1_INM-CM5-0_ssp370_10m"       
#> [127] "WorldClim_2.1_INM-CM5-0_ssp370_2.5m"      
#> [128] "WorldClim_2.1_INM-CM5-0_ssp370_5m"        
#> [129] "WorldClim_2.1_INM-CM5-0_ssp585_0.5m"      
#> [130] "WorldClim_2.1_INM-CM5-0_ssp585_10m"       
#> [131] "WorldClim_2.1_INM-CM5-0_ssp585_2.5m"      
#> [132] "WorldClim_2.1_INM-CM5-0_ssp585_5m"        
#> [133] "WorldClim_2.1_IPSL-CM6A-LR_ssp126_0.5m"   
#> [134] "WorldClim_2.1_IPSL-CM6A-LR_ssp126_10m"    
#> [135] "WorldClim_2.1_IPSL-CM6A-LR_ssp126_2.5m"   
#> [136] "WorldClim_2.1_IPSL-CM6A-LR_ssp126_5m"     
#> [137] "WorldClim_2.1_IPSL-CM6A-LR_ssp245_0.5m"   
#> [138] "WorldClim_2.1_IPSL-CM6A-LR_ssp245_10m"    
#> [139] "WorldClim_2.1_IPSL-CM6A-LR_ssp245_2.5m"   
#> [140] "WorldClim_2.1_IPSL-CM6A-LR_ssp245_5m"     
#> [141] "WorldClim_2.1_IPSL-CM6A-LR_ssp370_0.5m"   
#> [142] "WorldClim_2.1_IPSL-CM6A-LR_ssp370_10m"    
#> [143] "WorldClim_2.1_IPSL-CM6A-LR_ssp370_2.5m"   
#> [144] "WorldClim_2.1_IPSL-CM6A-LR_ssp370_5m"     
#> [145] "WorldClim_2.1_IPSL-CM6A-LR_ssp585_0.5m"   
#> [146] "WorldClim_2.1_IPSL-CM6A-LR_ssp585_10m"    
#> [147] "WorldClim_2.1_IPSL-CM6A-LR_ssp585_2.5m"   
#> [148] "WorldClim_2.1_IPSL-CM6A-LR_ssp585_5m"     
#> [149] "WorldClim_2.1_MIROC6_ssp126_0.5m"         
#> [150] "WorldClim_2.1_MIROC6_ssp126_10m"          
#> [151] "WorldClim_2.1_MIROC6_ssp126_2.5m"         
#> [152] "WorldClim_2.1_MIROC6_ssp126_5m"           
#> [153] "WorldClim_2.1_MIROC6_ssp245_0.5m"         
#> [154] "WorldClim_2.1_MIROC6_ssp245_10m"          
#> [155] "WorldClim_2.1_MIROC6_ssp245_2.5m"         
#> [156] "WorldClim_2.1_MIROC6_ssp245_5m"           
#> [157] "WorldClim_2.1_MIROC6_ssp370_0.5m"         
#> [158] "WorldClim_2.1_MIROC6_ssp370_10m"          
#> [159] "WorldClim_2.1_MIROC6_ssp370_2.5m"         
#> [160] "WorldClim_2.1_MIROC6_ssp370_5m"           
#> [161] "WorldClim_2.1_MIROC6_ssp585_0.5m"         
#> [162] "WorldClim_2.1_MIROC6_ssp585_10m"          
#> [163] "WorldClim_2.1_MIROC6_ssp585_2.5m"         
#> [164] "WorldClim_2.1_MIROC6_ssp585_5m"           
#> [165] "WorldClim_2.1_MPI-ESM1-2-HR_ssp126_0.5m"  
#> [166] "WorldClim_2.1_MPI-ESM1-2-HR_ssp126_10m"   
#> [167] "WorldClim_2.1_MPI-ESM1-2-HR_ssp126_2.5m"  
#> [168] "WorldClim_2.1_MPI-ESM1-2-HR_ssp126_5m"    
#> [169] "WorldClim_2.1_MPI-ESM1-2-HR_ssp245_0.5m"  
#> [170] "WorldClim_2.1_MPI-ESM1-2-HR_ssp245_10m"   
#> [171] "WorldClim_2.1_MPI-ESM1-2-HR_ssp245_2.5m"  
#> [172] "WorldClim_2.1_MPI-ESM1-2-HR_ssp245_5m"    
#> [173] "WorldClim_2.1_MPI-ESM1-2-HR_ssp370_0.5m"  
#> [174] "WorldClim_2.1_MPI-ESM1-2-HR_ssp370_10m"   
#> [175] "WorldClim_2.1_MPI-ESM1-2-HR_ssp370_2.5m"  
#> [176] "WorldClim_2.1_MPI-ESM1-2-HR_ssp370_5m"    
#> [177] "WorldClim_2.1_MPI-ESM1-2-HR_ssp585_0.5m"  
#> [178] "WorldClim_2.1_MPI-ESM1-2-HR_ssp585_10m"   
#> [179] "WorldClim_2.1_MPI-ESM1-2-HR_ssp585_2.5m"  
#> [180] "WorldClim_2.1_MPI-ESM1-2-HR_ssp585_5m"    
#> [181] "WorldClim_2.1_MRI-ESM2-0_ssp126_0.5m"     
#> [182] "WorldClim_2.1_MRI-ESM2-0_ssp126_10m"      
#> [183] "WorldClim_2.1_MRI-ESM2-0_ssp126_2.5m"     
#> [184] "WorldClim_2.1_MRI-ESM2-0_ssp126_5m"       
#> [185] "WorldClim_2.1_MRI-ESM2-0_ssp245_0.5m"     
#> [186] "WorldClim_2.1_MRI-ESM2-0_ssp245_10m"      
#> [187] "WorldClim_2.1_MRI-ESM2-0_ssp245_2.5m"     
#> [188] "WorldClim_2.1_MRI-ESM2-0_ssp245_5m"       
#> [189] "WorldClim_2.1_MRI-ESM2-0_ssp370_0.5m"     
#> [190] "WorldClim_2.1_MRI-ESM2-0_ssp370_10m"      
#> [191] "WorldClim_2.1_MRI-ESM2-0_ssp370_2.5m"     
#> [192] "WorldClim_2.1_MRI-ESM2-0_ssp370_5m"       
#> [193] "WorldClim_2.1_MRI-ESM2-0_ssp585_0.5m"     
#> [194] "WorldClim_2.1_MRI-ESM2-0_ssp585_10m"      
#> [195] "WorldClim_2.1_MRI-ESM2-0_ssp585_2.5m"     
#> [196] "WorldClim_2.1_MRI-ESM2-0_ssp585_5m"       
#> [197] "WorldClim_2.1_UKESM1-0-LL_ssp126_0.5m"    
#> [198] "WorldClim_2.1_UKESM1-0-LL_ssp126_10m"     
#> [199] "WorldClim_2.1_UKESM1-0-LL_ssp126_2.5m"    
#> [200] "WorldClim_2.1_UKESM1-0-LL_ssp126_5m"      
#> [201] "WorldClim_2.1_UKESM1-0-LL_ssp245_0.5m"    
#> [202] "WorldClim_2.1_UKESM1-0-LL_ssp245_10m"     
#> [203] "WorldClim_2.1_UKESM1-0-LL_ssp245_2.5m"    
#> [204] "WorldClim_2.1_UKESM1-0-LL_ssp245_5m"      
#> [205] "WorldClim_2.1_UKESM1-0-LL_ssp370_0.5m"    
#> [206] "WorldClim_2.1_UKESM1-0-LL_ssp370_10m"     
#> [207] "WorldClim_2.1_UKESM1-0-LL_ssp370_2.5m"    
#> [208] "WorldClim_2.1_UKESM1-0-LL_ssp370_5m"      
#> [209] "WorldClim_2.1_UKESM1-0-LL_ssp585_0.5m"    
#> [210] "WorldClim_2.1_UKESM1-0-LL_ssp585_10m"     
#> [211] "WorldClim_2.1_UKESM1-0-LL_ssp585_2.5m"    
#> [212] "WorldClim_2.1_UKESM1-0-LL_ssp585_5m"
```

So, if we are interested in the the HadGEM3-GC31-LL model, with ssp set
to 245 and at 10 arc-minutes, we can get the available variables:

``` r

get_vars_for_dataset(dataset = "WorldClim_2.1_HadGEM3-GC31-LL_ssp245_10m")
#>  [1] "bio01" "bio02" "bio03" "bio04" "bio05" "bio06" "bio07" "bio08" "bio09"
#> [10] "bio10" "bio11" "bio12" "bio13" "bio14" "bio15" "bio16" "bio17" "bio18"
#> [19] "bio19"
```

We can now download “bio01” and “bio02” for that dataset with:

``` r

download_dataset(
  dataset = "WorldClim_2.1_HadGEM3-GC31-LL_ssp245_10m",
  bio_variables = c("bio01", "bio02")
)
```

The datasets are averages over 20 year periods (2021-2040, 2041-2060,
2061-2080, 2081-2100). In `pastclim`, the midpoints of the periods
(2030, 2050, 2070, 2090) are used as the time stamps. All 4 periods are
automatically downloaded for each combination of GCM model and SSP, and
can be selected as usual by defining the time in `region_slice`.

``` r

future_slice <- region_slice(
  time_ce = 2030,
  dataset = "WorldClim_2.1_HadGEM3-GC31-LL_ssp245_10m",
  bio_variables = c("bio01", "bio02")
)
```

Alternatively, it is possible to get the full time series of 4 slices
with:

``` r

future_series <- region_series(
  dataset = "WorldClim_2.1_HadGEM3-GC31-LL_ssp245_10m",
  bio_variables = c("bio01", "bio02")
)
```

It is possible to simply use
`get_time_ce_steps(dataset = "WorldClim_2.1_HadGEM3-GC31-LL_ssp245_10m")`
to get the available time points for that dataset.

Help for the WorldClim datasets (modern and future) can be accessed with
[`help("WorldClim_2.1")`](https://evolecolgroup.github.io/pastclim/reference/WorldClim_2.1.md)

### CHELSA

Future projections are based on the models in CMIP6, downscaled and
de-biased using CHELSA 2.1 for the present as a baseline. Monthly values
of mean temperature, and precipitation, as well as 19 bioclimatic
variables were processed for 5 global climate models (GCMs), and for
three Shared Socio-economic Pathways (SSPs): 126, 370 and 585. Model and
SSP can be chosen by changing the ending of the dataset name
*CHELSA_2.1_GCM_SSP_0.5m*.

A complete list of available combinations can be obtained with:

``` r

list_available_datasets()[grepl("CHELSA_2.1", list_available_datasets())]
#>  [1] "CHELSA_2.1_0.5m"                         
#>  [2] "CHELSA_2.1_0.5m_vsi"                     
#>  [3] "CHELSA_2.1_GFDL-ESM4_ssp126_0.5m"        
#>  [4] "CHELSA_2.1_GFDL-ESM4_ssp126_0.5m_vsi"    
#>  [5] "CHELSA_2.1_GFDL-ESM4_ssp370_0.5m"        
#>  [6] "CHELSA_2.1_GFDL-ESM4_ssp370_0.5m_vsi"    
#>  [7] "CHELSA_2.1_GFDL-ESM4_ssp585_0.5m"        
#>  [8] "CHELSA_2.1_GFDL-ESM4_ssp585_0.5m_vsi"    
#>  [9] "CHELSA_2.1_IPSL-CM6A-LR_ssp126_0.5m"     
#> [10] "CHELSA_2.1_IPSL-CM6A-LR_ssp126_0.5m_vsi" 
#> [11] "CHELSA_2.1_IPSL-CM6A-LR_ssp370_0.5m"     
#> [12] "CHELSA_2.1_IPSL-CM6A-LR_ssp370_0.5m_vsi" 
#> [13] "CHELSA_2.1_IPSL-CM6A-LR_ssp585_0.5m"     
#> [14] "CHELSA_2.1_IPSL-CM6A-LR_ssp585_0.5m_vsi" 
#> [15] "CHELSA_2.1_MPI-ESM1-2-HR_ssp126_0.5m"    
#> [16] "CHELSA_2.1_MPI-ESM1-2-HR_ssp126_0.5m_vsi"
#> [17] "CHELSA_2.1_MPI-ESM1-2-HR_ssp370_0.5m"    
#> [18] "CHELSA_2.1_MPI-ESM1-2-HR_ssp370_0.5m_vsi"
#> [19] "CHELSA_2.1_MPI-ESM1-2-HR_ssp585_0.5m"    
#> [20] "CHELSA_2.1_MPI-ESM1-2-HR_ssp585_0.5m_vsi"
#> [21] "CHELSA_2.1_MRI-ESM2-0_ssp126_0.5m"       
#> [22] "CHELSA_2.1_MRI-ESM2-0_ssp126_0.5m_vsi"   
#> [23] "CHELSA_2.1_MRI-ESM2-0_ssp370_0.5m"       
#> [24] "CHELSA_2.1_MRI-ESM2-0_ssp370_0.5m_vsi"   
#> [25] "CHELSA_2.1_MRI-ESM2-0_ssp585_0.5m"       
#> [26] "CHELSA_2.1_MRI-ESM2-0_ssp585_0.5m_vsi"   
#> [27] "CHELSA_2.1_UKESM1-0-LL_ssp126_0.5m"      
#> [28] "CHELSA_2.1_UKESM1-0-LL_ssp126_0.5m_vsi"  
#> [29] "CHELSA_2.1_UKESM1-0-LL_ssp370_0.5m"      
#> [30] "CHELSA_2.1_UKESM1-0-LL_ssp370_0.5m_vsi"  
#> [31] "CHELSA_2.1_UKESM1-0-LL_ssp585_0.5m"      
#> [32] "CHELSA_2.1_UKESM1-0-LL_ssp585_0.5m_vsi"
```

Note that there is a virtual option for each dataset. So, if we are
interested in the the GFDL-ESM4 model, with ssp set to 126 , we can get
the available variables:

``` r

get_vars_for_dataset(
  dataset = "CHELSA_2.1_UKESM1-0-LL_ssp585_0.5m",
  monthly = TRUE
)
#>  [1] "bio01"            "bio02"            "bio03"            "bio04"           
#>  [5] "bio05"            "bio06"            "bio07"            "bio08"           
#>  [9] "bio09"            "bio10"            "bio11"            "bio12"           
#> [13] "bio13"            "bio14"            "bio15"            "bio16"           
#> [17] "bio17"            "bio18"            "bio19"            "temperature_01"  
#> [21] "temperature_02"   "temperature_03"   "temperature_04"   "temperature_05"  
#> [25] "temperature_06"   "temperature_07"   "temperature_08"   "temperature_09"  
#> [29] "temperature_10"   "temperature_11"   "temperature_12"   "precipitation_01"
#> [33] "precipitation_02" "precipitation_03" "precipitation_04" "precipitation_05"
#> [37] "precipitation_06" "precipitation_07" "precipitation_08" "precipitation_09"
#> [41] "precipitation_10" "precipitation_11" "precipitation_12" "npp"
```

We can now download “bio01” and “bio02” for that dataset, using the
virtual version, with:

``` r

download_dataset(
  dataset = "CHELSA_2.1_UKESM1-0-LL_ssp585_0.5m_vsi",
  bio_variables = c("bio01", "bio02")
)
```

The datasets are averages over 30 year periods (2011-2040, 2041-2070,
2071-2100). In `pastclim`, the midpoints of the periods (2025, 2055,
2075) are used as the time stamps. All 3 periods are automatically
downloaded for a given combination of GCM model and SSP, and can be
selected as usual by defining the time in `region_slice`.

``` r

future_slice <- region_slice(
  time_ce = 2025,
  dataset = "CHELSA_2.1_UKESM1-0-LL_ssp585_0.5m_vsi",
  bio_variables = c("bio01", "bio02")
)
```

Alternatively, it is possible to get the full time series of 4 slices
with:

``` r

future_series <- region_series(
  dataset = "CHELSA_2.1_UKESM1-0-LL_ssp585_0.5m_vsi",
  bio_variables = c("bio01", "bio02")
)
```

It is possible to simply use
`get_time_ce_steps(dataset = "CHELSA_2.1_UKESM1-0-LL_ssp585_0.5m_vsi")`
to get the available time points for that dataset.

Help for the WorldClim datasets (modern and future) can be accessed with
[`help("CHELSA_2.1")`](https://evolecolgroup.github.io/pastclim/reference/CHELSA_2.1.md)
