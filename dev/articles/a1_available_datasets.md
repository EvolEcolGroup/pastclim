# available datasets

## Overview of datasets available in `pastclim`

A number of datasets are available in pastclim. It is possible to use
custom datasets as long as they are properly formatted (look at the
article on how to format custom datasets if you are interested). It is
possible to get a list of all available datasets with:

``` r

library(pastclim)
#> Loading required package: terra
#> terra 1.9.34
```

``` r

get_available_datasets()
#> Barreto2023, Beyer2020, CHELSA_trace21k_1.0_0.5m_vsi, Example, HYDE_3.3_baseline, Krapp2021, paleoclim_1.0_10m, paleoclim_1.0_2.5m, paleoclim_1.0_5m
#> for present day reconstructions, use "WorldClim_2.1_RESm" or "CHELSA_2.4_RESm" where RES is an available resolution.
#> for future predictions, use "WorldClim_2.1_GCM_SSP_RESm" or "CHELSA_2.1_GCM_SSP_RESm", where GCM is the GCM model, SSP is the Shared Socio-economic Pathways scenario.
#> use help("WorldClim_2.1") or help("CHELSA_2.1") for a list of available options
```

A more comprehensive list can be obtained with:

``` r

list_available_datasets()
#>   [1] "Barreto2023"                              
#>   [2] "Beyer2020"                                
#>   [3] "CHELSA_2.1_0.5m"                          
#>   [4] "CHELSA_2.1_0.5m_vsi"                      
#>   [5] "CHELSA_2.1_GFDL-ESM4_ssp126_0.5m"         
#>   [6] "CHELSA_2.1_GFDL-ESM4_ssp126_0.5m_vsi"     
#>   [7] "CHELSA_2.1_GFDL-ESM4_ssp370_0.5m"         
#>   [8] "CHELSA_2.1_GFDL-ESM4_ssp370_0.5m_vsi"     
#>   [9] "CHELSA_2.1_GFDL-ESM4_ssp585_0.5m"         
#>  [10] "CHELSA_2.1_GFDL-ESM4_ssp585_0.5m_vsi"     
#>  [11] "CHELSA_2.1_IPSL-CM6A-LR_ssp126_0.5m"      
#>  [12] "CHELSA_2.1_IPSL-CM6A-LR_ssp126_0.5m_vsi"  
#>  [13] "CHELSA_2.1_IPSL-CM6A-LR_ssp370_0.5m"      
#>  [14] "CHELSA_2.1_IPSL-CM6A-LR_ssp370_0.5m_vsi"  
#>  [15] "CHELSA_2.1_IPSL-CM6A-LR_ssp585_0.5m"      
#>  [16] "CHELSA_2.1_IPSL-CM6A-LR_ssp585_0.5m_vsi"  
#>  [17] "CHELSA_2.1_MPI-ESM1-2-HR_ssp126_0.5m"     
#>  [18] "CHELSA_2.1_MPI-ESM1-2-HR_ssp126_0.5m_vsi" 
#>  [19] "CHELSA_2.1_MPI-ESM1-2-HR_ssp370_0.5m"     
#>  [20] "CHELSA_2.1_MPI-ESM1-2-HR_ssp370_0.5m_vsi" 
#>  [21] "CHELSA_2.1_MPI-ESM1-2-HR_ssp585_0.5m"     
#>  [22] "CHELSA_2.1_MPI-ESM1-2-HR_ssp585_0.5m_vsi" 
#>  [23] "CHELSA_2.1_MRI-ESM2-0_ssp126_0.5m"        
#>  [24] "CHELSA_2.1_MRI-ESM2-0_ssp126_0.5m_vsi"    
#>  [25] "CHELSA_2.1_MRI-ESM2-0_ssp370_0.5m"        
#>  [26] "CHELSA_2.1_MRI-ESM2-0_ssp370_0.5m_vsi"    
#>  [27] "CHELSA_2.1_MRI-ESM2-0_ssp585_0.5m"        
#>  [28] "CHELSA_2.1_MRI-ESM2-0_ssp585_0.5m_vsi"    
#>  [29] "CHELSA_2.1_UKESM1-0-LL_ssp126_0.5m"       
#>  [30] "CHELSA_2.1_UKESM1-0-LL_ssp126_0.5m_vsi"   
#>  [31] "CHELSA_2.1_UKESM1-0-LL_ssp370_0.5m"       
#>  [32] "CHELSA_2.1_UKESM1-0-LL_ssp370_0.5m_vsi"   
#>  [33] "CHELSA_2.1_UKESM1-0-LL_ssp585_0.5m"       
#>  [34] "CHELSA_2.1_UKESM1-0-LL_ssp585_0.5m_vsi"   
#>  [35] "CHELSA_trace21k_1.0_0.5m_vsi"             
#>  [36] "Example"                                  
#>  [37] "HYDE_3.3_baseline"                        
#>  [38] "Krapp2021"                                
#>  [39] "paleoclim_1.0_10m"                        
#>  [40] "paleoclim_1.0_2.5m"                       
#>  [41] "paleoclim_1.0_5m"                         
#>  [42] "WorldClim_2.1_0.5m"                       
#>  [43] "WorldClim_2.1_10m"                        
#>  [44] "WorldClim_2.1_2.5m"                       
#>  [45] "WorldClim_2.1_5m"                         
#>  [46] "WorldClim_2.1_ACCESS-CM2_ssp126_0.5m"     
#>  [47] "WorldClim_2.1_ACCESS-CM2_ssp126_10m"      
#>  [48] "WorldClim_2.1_ACCESS-CM2_ssp126_2.5m"     
#>  [49] "WorldClim_2.1_ACCESS-CM2_ssp126_5m"       
#>  [50] "WorldClim_2.1_ACCESS-CM2_ssp245_0.5m"     
#>  [51] "WorldClim_2.1_ACCESS-CM2_ssp245_10m"      
#>  [52] "WorldClim_2.1_ACCESS-CM2_ssp245_2.5m"     
#>  [53] "WorldClim_2.1_ACCESS-CM2_ssp245_5m"       
#>  [54] "WorldClim_2.1_ACCESS-CM2_ssp370_0.5m"     
#>  [55] "WorldClim_2.1_ACCESS-CM2_ssp370_10m"      
#>  [56] "WorldClim_2.1_ACCESS-CM2_ssp370_2.5m"     
#>  [57] "WorldClim_2.1_ACCESS-CM2_ssp370_5m"       
#>  [58] "WorldClim_2.1_ACCESS-CM2_ssp585_0.5m"     
#>  [59] "WorldClim_2.1_ACCESS-CM2_ssp585_10m"      
#>  [60] "WorldClim_2.1_ACCESS-CM2_ssp585_2.5m"     
#>  [61] "WorldClim_2.1_ACCESS-CM2_ssp585_5m"       
#>  [62] "WorldClim_2.1_BCC-CSM2-MR_ssp126_0.5m"    
#>  [63] "WorldClim_2.1_BCC-CSM2-MR_ssp126_10m"     
#>  [64] "WorldClim_2.1_BCC-CSM2-MR_ssp126_2.5m"    
#>  [65] "WorldClim_2.1_BCC-CSM2-MR_ssp126_5m"      
#>  [66] "WorldClim_2.1_BCC-CSM2-MR_ssp245_0.5m"    
#>  [67] "WorldClim_2.1_BCC-CSM2-MR_ssp245_10m"     
#>  [68] "WorldClim_2.1_BCC-CSM2-MR_ssp245_2.5m"    
#>  [69] "WorldClim_2.1_BCC-CSM2-MR_ssp245_5m"      
#>  [70] "WorldClim_2.1_BCC-CSM2-MR_ssp370_0.5m"    
#>  [71] "WorldClim_2.1_BCC-CSM2-MR_ssp370_10m"     
#>  [72] "WorldClim_2.1_BCC-CSM2-MR_ssp370_2.5m"    
#>  [73] "WorldClim_2.1_BCC-CSM2-MR_ssp370_5m"      
#>  [74] "WorldClim_2.1_BCC-CSM2-MR_ssp585_0.5m"    
#>  [75] "WorldClim_2.1_BCC-CSM2-MR_ssp585_10m"     
#>  [76] "WorldClim_2.1_BCC-CSM2-MR_ssp585_2.5m"    
#>  [77] "WorldClim_2.1_BCC-CSM2-MR_ssp585_5m"      
#>  [78] "WorldClim_2.1_CMCC-ESM2_ssp126_0.5m"      
#>  [79] "WorldClim_2.1_CMCC-ESM2_ssp126_10m"       
#>  [80] "WorldClim_2.1_CMCC-ESM2_ssp126_2.5m"      
#>  [81] "WorldClim_2.1_CMCC-ESM2_ssp126_5m"        
#>  [82] "WorldClim_2.1_CMCC-ESM2_ssp245_0.5m"      
#>  [83] "WorldClim_2.1_CMCC-ESM2_ssp245_10m"       
#>  [84] "WorldClim_2.1_CMCC-ESM2_ssp245_2.5m"      
#>  [85] "WorldClim_2.1_CMCC-ESM2_ssp245_5m"        
#>  [86] "WorldClim_2.1_CMCC-ESM2_ssp370_0.5m"      
#>  [87] "WorldClim_2.1_CMCC-ESM2_ssp370_10m"       
#>  [88] "WorldClim_2.1_CMCC-ESM2_ssp370_2.5m"      
#>  [89] "WorldClim_2.1_CMCC-ESM2_ssp370_5m"        
#>  [90] "WorldClim_2.1_CMCC-ESM2_ssp585_0.5m"      
#>  [91] "WorldClim_2.1_CMCC-ESM2_ssp585_10m"       
#>  [92] "WorldClim_2.1_CMCC-ESM2_ssp585_2.5m"      
#>  [93] "WorldClim_2.1_CMCC-ESM2_ssp585_5m"        
#>  [94] "WorldClim_2.1_EC-Earth3-Veg_ssp126_0.5m"  
#>  [95] "WorldClim_2.1_EC-Earth3-Veg_ssp126_10m"   
#>  [96] "WorldClim_2.1_EC-Earth3-Veg_ssp126_2.5m"  
#>  [97] "WorldClim_2.1_EC-Earth3-Veg_ssp126_5m"    
#>  [98] "WorldClim_2.1_EC-Earth3-Veg_ssp245_0.5m"  
#>  [99] "WorldClim_2.1_EC-Earth3-Veg_ssp245_10m"   
#> [100] "WorldClim_2.1_EC-Earth3-Veg_ssp245_2.5m"  
#> [101] "WorldClim_2.1_EC-Earth3-Veg_ssp245_5m"    
#> [102] "WorldClim_2.1_EC-Earth3-Veg_ssp370_0.5m"  
#> [103] "WorldClim_2.1_EC-Earth3-Veg_ssp370_10m"   
#> [104] "WorldClim_2.1_EC-Earth3-Veg_ssp370_2.5m"  
#> [105] "WorldClim_2.1_EC-Earth3-Veg_ssp370_5m"    
#> [106] "WorldClim_2.1_EC-Earth3-Veg_ssp585_0.5m"  
#> [107] "WorldClim_2.1_EC-Earth3-Veg_ssp585_10m"   
#> [108] "WorldClim_2.1_EC-Earth3-Veg_ssp585_2.5m"  
#> [109] "WorldClim_2.1_EC-Earth3-Veg_ssp585_5m"    
#> [110] "WorldClim_2.1_FIO-ESM-2-0_ssp126_0.5m"    
#> [111] "WorldClim_2.1_FIO-ESM-2-0_ssp126_10m"     
#> [112] "WorldClim_2.1_FIO-ESM-2-0_ssp126_2.5m"    
#> [113] "WorldClim_2.1_FIO-ESM-2-0_ssp126_5m"      
#> [114] "WorldClim_2.1_FIO-ESM-2-0_ssp245_0.5m"    
#> [115] "WorldClim_2.1_FIO-ESM-2-0_ssp245_10m"     
#> [116] "WorldClim_2.1_FIO-ESM-2-0_ssp245_2.5m"    
#> [117] "WorldClim_2.1_FIO-ESM-2-0_ssp245_5m"      
#> [118] "WorldClim_2.1_FIO-ESM-2-0_ssp585_0.5m"    
#> [119] "WorldClim_2.1_FIO-ESM-2-0_ssp585_10m"     
#> [120] "WorldClim_2.1_FIO-ESM-2-0_ssp585_2.5m"    
#> [121] "WorldClim_2.1_FIO-ESM-2-0_ssp585_5m"      
#> [122] "WorldClim_2.1_GFDL-ESM4_ssp126_0.5m"      
#> [123] "WorldClim_2.1_GFDL-ESM4_ssp126_10m"       
#> [124] "WorldClim_2.1_GFDL-ESM4_ssp126_2.5m"      
#> [125] "WorldClim_2.1_GFDL-ESM4_ssp126_5m"        
#> [126] "WorldClim_2.1_GFDL-ESM4_ssp370_0.5m"      
#> [127] "WorldClim_2.1_GFDL-ESM4_ssp370_10m"       
#> [128] "WorldClim_2.1_GFDL-ESM4_ssp370_2.5m"      
#> [129] "WorldClim_2.1_GFDL-ESM4_ssp370_5m"        
#> [130] "WorldClim_2.1_GISS-E2-1-G_ssp126_0.5m"    
#> [131] "WorldClim_2.1_GISS-E2-1-G_ssp126_10m"     
#> [132] "WorldClim_2.1_GISS-E2-1-G_ssp126_2.5m"    
#> [133] "WorldClim_2.1_GISS-E2-1-G_ssp126_5m"      
#> [134] "WorldClim_2.1_GISS-E2-1-G_ssp245_0.5m"    
#> [135] "WorldClim_2.1_GISS-E2-1-G_ssp245_10m"     
#> [136] "WorldClim_2.1_GISS-E2-1-G_ssp245_2.5m"    
#> [137] "WorldClim_2.1_GISS-E2-1-G_ssp245_5m"      
#> [138] "WorldClim_2.1_GISS-E2-1-G_ssp370_0.5m"    
#> [139] "WorldClim_2.1_GISS-E2-1-G_ssp370_10m"     
#> [140] "WorldClim_2.1_GISS-E2-1-G_ssp370_2.5m"    
#> [141] "WorldClim_2.1_GISS-E2-1-G_ssp370_5m"      
#> [142] "WorldClim_2.1_GISS-E2-1-G_ssp585_0.5m"    
#> [143] "WorldClim_2.1_GISS-E2-1-G_ssp585_10m"     
#> [144] "WorldClim_2.1_GISS-E2-1-G_ssp585_2.5m"    
#> [145] "WorldClim_2.1_GISS-E2-1-G_ssp585_5m"      
#> [146] "WorldClim_2.1_HadGEM3-GC31-LL_ssp126_0.5m"
#> [147] "WorldClim_2.1_HadGEM3-GC31-LL_ssp126_10m" 
#> [148] "WorldClim_2.1_HadGEM3-GC31-LL_ssp126_2.5m"
#> [149] "WorldClim_2.1_HadGEM3-GC31-LL_ssp126_5m"  
#> [150] "WorldClim_2.1_HadGEM3-GC31-LL_ssp245_0.5m"
#> [151] "WorldClim_2.1_HadGEM3-GC31-LL_ssp245_10m" 
#> [152] "WorldClim_2.1_HadGEM3-GC31-LL_ssp245_2.5m"
#> [153] "WorldClim_2.1_HadGEM3-GC31-LL_ssp245_5m"  
#> [154] "WorldClim_2.1_HadGEM3-GC31-LL_ssp585_0.5m"
#> [155] "WorldClim_2.1_HadGEM3-GC31-LL_ssp585_10m" 
#> [156] "WorldClim_2.1_HadGEM3-GC31-LL_ssp585_2.5m"
#> [157] "WorldClim_2.1_HadGEM3-GC31-LL_ssp585_5m"  
#> [158] "WorldClim_2.1_INM-CM5-0_ssp126_0.5m"      
#> [159] "WorldClim_2.1_INM-CM5-0_ssp126_10m"       
#> [160] "WorldClim_2.1_INM-CM5-0_ssp126_2.5m"      
#> [161] "WorldClim_2.1_INM-CM5-0_ssp126_5m"        
#> [162] "WorldClim_2.1_INM-CM5-0_ssp245_0.5m"      
#> [163] "WorldClim_2.1_INM-CM5-0_ssp245_10m"       
#> [164] "WorldClim_2.1_INM-CM5-0_ssp245_2.5m"      
#> [165] "WorldClim_2.1_INM-CM5-0_ssp245_5m"        
#> [166] "WorldClim_2.1_INM-CM5-0_ssp370_0.5m"      
#> [167] "WorldClim_2.1_INM-CM5-0_ssp370_10m"       
#> [168] "WorldClim_2.1_INM-CM5-0_ssp370_2.5m"      
#> [169] "WorldClim_2.1_INM-CM5-0_ssp370_5m"        
#> [170] "WorldClim_2.1_INM-CM5-0_ssp585_0.5m"      
#> [171] "WorldClim_2.1_INM-CM5-0_ssp585_10m"       
#> [172] "WorldClim_2.1_INM-CM5-0_ssp585_2.5m"      
#> [173] "WorldClim_2.1_INM-CM5-0_ssp585_5m"        
#> [174] "WorldClim_2.1_IPSL-CM6A-LR_ssp126_0.5m"   
#> [175] "WorldClim_2.1_IPSL-CM6A-LR_ssp126_10m"    
#> [176] "WorldClim_2.1_IPSL-CM6A-LR_ssp126_2.5m"   
#> [177] "WorldClim_2.1_IPSL-CM6A-LR_ssp126_5m"     
#> [178] "WorldClim_2.1_IPSL-CM6A-LR_ssp245_0.5m"   
#> [179] "WorldClim_2.1_IPSL-CM6A-LR_ssp245_10m"    
#> [180] "WorldClim_2.1_IPSL-CM6A-LR_ssp245_2.5m"   
#> [181] "WorldClim_2.1_IPSL-CM6A-LR_ssp245_5m"     
#> [182] "WorldClim_2.1_IPSL-CM6A-LR_ssp370_0.5m"   
#> [183] "WorldClim_2.1_IPSL-CM6A-LR_ssp370_10m"    
#> [184] "WorldClim_2.1_IPSL-CM6A-LR_ssp370_2.5m"   
#> [185] "WorldClim_2.1_IPSL-CM6A-LR_ssp370_5m"     
#> [186] "WorldClim_2.1_IPSL-CM6A-LR_ssp585_0.5m"   
#> [187] "WorldClim_2.1_IPSL-CM6A-LR_ssp585_10m"    
#> [188] "WorldClim_2.1_IPSL-CM6A-LR_ssp585_2.5m"   
#> [189] "WorldClim_2.1_IPSL-CM6A-LR_ssp585_5m"     
#> [190] "WorldClim_2.1_MIROC6_ssp126_0.5m"         
#> [191] "WorldClim_2.1_MIROC6_ssp126_10m"          
#> [192] "WorldClim_2.1_MIROC6_ssp126_2.5m"         
#> [193] "WorldClim_2.1_MIROC6_ssp126_5m"           
#> [194] "WorldClim_2.1_MIROC6_ssp245_0.5m"         
#> [195] "WorldClim_2.1_MIROC6_ssp245_10m"          
#> [196] "WorldClim_2.1_MIROC6_ssp245_2.5m"         
#> [197] "WorldClim_2.1_MIROC6_ssp245_5m"           
#> [198] "WorldClim_2.1_MIROC6_ssp370_0.5m"         
#> [199] "WorldClim_2.1_MIROC6_ssp370_10m"          
#> [200] "WorldClim_2.1_MIROC6_ssp370_2.5m"         
#> [201] "WorldClim_2.1_MIROC6_ssp370_5m"           
#> [202] "WorldClim_2.1_MIROC6_ssp585_0.5m"         
#> [203] "WorldClim_2.1_MIROC6_ssp585_10m"          
#> [204] "WorldClim_2.1_MIROC6_ssp585_2.5m"         
#> [205] "WorldClim_2.1_MIROC6_ssp585_5m"           
#> [206] "WorldClim_2.1_MPI-ESM1-2-HR_ssp126_0.5m"  
#> [207] "WorldClim_2.1_MPI-ESM1-2-HR_ssp126_10m"   
#> [208] "WorldClim_2.1_MPI-ESM1-2-HR_ssp126_2.5m"  
#> [209] "WorldClim_2.1_MPI-ESM1-2-HR_ssp126_5m"    
#> [210] "WorldClim_2.1_MPI-ESM1-2-HR_ssp245_0.5m"  
#> [211] "WorldClim_2.1_MPI-ESM1-2-HR_ssp245_10m"   
#> [212] "WorldClim_2.1_MPI-ESM1-2-HR_ssp245_2.5m"  
#> [213] "WorldClim_2.1_MPI-ESM1-2-HR_ssp245_5m"    
#> [214] "WorldClim_2.1_MPI-ESM1-2-HR_ssp370_0.5m"  
#> [215] "WorldClim_2.1_MPI-ESM1-2-HR_ssp370_10m"   
#> [216] "WorldClim_2.1_MPI-ESM1-2-HR_ssp370_2.5m"  
#> [217] "WorldClim_2.1_MPI-ESM1-2-HR_ssp370_5m"    
#> [218] "WorldClim_2.1_MPI-ESM1-2-HR_ssp585_0.5m"  
#> [219] "WorldClim_2.1_MPI-ESM1-2-HR_ssp585_10m"   
#> [220] "WorldClim_2.1_MPI-ESM1-2-HR_ssp585_2.5m"  
#> [221] "WorldClim_2.1_MPI-ESM1-2-HR_ssp585_5m"    
#> [222] "WorldClim_2.1_MRI-ESM2-0_ssp126_0.5m"     
#> [223] "WorldClim_2.1_MRI-ESM2-0_ssp126_10m"      
#> [224] "WorldClim_2.1_MRI-ESM2-0_ssp126_2.5m"     
#> [225] "WorldClim_2.1_MRI-ESM2-0_ssp126_5m"       
#> [226] "WorldClim_2.1_MRI-ESM2-0_ssp245_0.5m"     
#> [227] "WorldClim_2.1_MRI-ESM2-0_ssp245_10m"      
#> [228] "WorldClim_2.1_MRI-ESM2-0_ssp245_2.5m"     
#> [229] "WorldClim_2.1_MRI-ESM2-0_ssp245_5m"       
#> [230] "WorldClim_2.1_MRI-ESM2-0_ssp370_0.5m"     
#> [231] "WorldClim_2.1_MRI-ESM2-0_ssp370_10m"      
#> [232] "WorldClim_2.1_MRI-ESM2-0_ssp370_2.5m"     
#> [233] "WorldClim_2.1_MRI-ESM2-0_ssp370_5m"       
#> [234] "WorldClim_2.1_MRI-ESM2-0_ssp585_0.5m"     
#> [235] "WorldClim_2.1_MRI-ESM2-0_ssp585_10m"      
#> [236] "WorldClim_2.1_MRI-ESM2-0_ssp585_2.5m"     
#> [237] "WorldClim_2.1_MRI-ESM2-0_ssp585_5m"       
#> [238] "WorldClim_2.1_UKESM1-0-LL_ssp126_0.5m"    
#> [239] "WorldClim_2.1_UKESM1-0-LL_ssp126_10m"     
#> [240] "WorldClim_2.1_UKESM1-0-LL_ssp126_2.5m"    
#> [241] "WorldClim_2.1_UKESM1-0-LL_ssp126_5m"      
#> [242] "WorldClim_2.1_UKESM1-0-LL_ssp245_0.5m"    
#> [243] "WorldClim_2.1_UKESM1-0-LL_ssp245_10m"     
#> [244] "WorldClim_2.1_UKESM1-0-LL_ssp245_2.5m"    
#> [245] "WorldClim_2.1_UKESM1-0-LL_ssp245_5m"      
#> [246] "WorldClim_2.1_UKESM1-0-LL_ssp370_0.5m"    
#> [247] "WorldClim_2.1_UKESM1-0-LL_ssp370_10m"     
#> [248] "WorldClim_2.1_UKESM1-0-LL_ssp370_2.5m"    
#> [249] "WorldClim_2.1_UKESM1-0-LL_ssp370_5m"      
#> [250] "WorldClim_2.1_UKESM1-0-LL_ssp585_0.5m"    
#> [251] "WorldClim_2.1_UKESM1-0-LL_ssp585_10m"     
#> [252] "WorldClim_2.1_UKESM1-0-LL_ssp585_2.5m"    
#> [253] "WorldClim_2.1_UKESM1-0-LL_ssp585_5m"
```

For each dataset, you can get detailed information using the help
function:

``` r

help("Example")
```

    #> Documentation for the Example dataset
    #> 
    #> Description:
    #> 
    #>      This dataset is a subset of Beyer2020, used for the vignette of
    #>      pastclim. Do not use this dataset for any real work, as it might
    #>      not reflect the most up-to-date version of Beyer2020.

Here we provide the full documentation for each dataset (sorted in
alphabetical order):

    #> Documentation for the Barreto et al 2023 dataset
    #> 
    #> Description:
    #> 
    #>      Spatio-temporal series of monthly temperature and precipitation
    #>      and 17 derived bioclimatic variables covering the last 5 Ma
    #>      (Pliocene<e2><80><93>Pleistocene), at intervals of 1,000 years, and a spatial
    #>      resolution of 1 arc-degrees (see Barreto et al., 2023 for
    #>      details).
    #> 
    #> Details:
    #> 
    #>      PALEO-PGEM-Series is downscaled to 1 <c3><97> 1 arc-degrees spatial
    #>      resolution from the outputs of the PALEO-PGEM emulator (Holden et
    #>      al., 2019), which emulates reasonable and extensively validated
    #>      global estimates of monthly temperature and precipitation for the
    #>      Plio-Pleistocene every 1 kyr at a spatial resolution of ~5 <c3><97> 5
    #>      arc-degrees (Holden et al., 2016, 2019).
    #> 
    #>      PALEO-PGEM-Series includes the mean and the standard deviation
    #>      (i.e., standard error) of the emulated climate over 10 stochastic
    #>      GCM emulations to accommodate aspects of model uncertainty. This
    #>      allows users to estimate the robustness of their results in the
    #>      face of the stochastic aspects of the emulations. For more
    #>      details, see Section 2.4 in Barreto et al. (2023).
    #> 
    #>      Note that this is a very large dataset, with 5001 time slices. It
    #>      takes approximately 1 minute to set up each variable when creating
    #>      a region_slice or region_series. However, once the object has been
    #>      created, other operations tend to be much faster (especially if
    #>      you subset the dataset to a small number of time steps of
    #>      interest).
    #> 
    #>      IMPORTANT: If you use this dataset, make sure to cite the original
    #>      publications:
    #> 
    #>      Barreto, E., Holden, P. B., Edwards, N. R., & Rangel, T. F.
    #>      (2023). PALEO-PGEM-Series: A spatial time series of the global
    #>      climate over the last 5 million years (Plio-Pleistocene). Global
    #>      Ecology and Biogeography, 32, 1034-1045, doi:10.1111/geb.13683
    #>      <https://doi.org/10.1111/geb.13683>
    #> 
    #>      Holden, P. B., Edwards, N. R., Rangel, T. F., Pereira, E. B.,
    #>      Tran, G. T., and Wilkinson, R. D. (2019): PALEO-PGEM v1.0: a
    #>      statistical emulator of Pliocene<e2><80><93>Pleistocene climate, Geosci.
    #>      Model Dev., 12, 5137<e2><80><93>5155, doi:10.5194/gmd-12-5137-2019
    #>      <https://doi.org/10.5194/gmd-12-5137-2019>.
    #> 
    #> 
    #> #######################################################
    #> Documentation for the Beyer2020 dataset
    #> 
    #> Description:
    #> 
    #>      This dataset covers the last 120k years, at intervals of 1/2 k
    #>      years, and a resolution of 0.5 degrees in latitude and longitude.
    #> 
    #> Details:
    #> 
    #>      IMPORTANT: If you use this dataset, make sure to cite the original
    #>      publication:
    #> 
    #>      Beyer, R.M., Krapp, M. & Manica, A. High-resolution terrestrial
    #>      climate, bioclimate and vegetation for the last 120,000 years. Sci
    #>      Data 7, 236 (2020). doi:10.1038/s41597-020-0552-1
    #>      <https://doi.org/10.1038/s41597-020-0552-1>
    #> 
    #>      The version included in 'pastclim' has the ice sheets masked, as
    #>      well as internal seas (Black and Caspian Sea) removed. The latter
    #>      are based on:
    #> 
    #>      <https://www.marineregions.org/gazetteer.php?p=details&id=4278>
    #> 
    #>      <https://www.marineregions.org/gazetteer.php?p=details&id=4282>
    #> 
    #>      As there is no reconstruction of their depth through time, modern
    #>      outlines were used for all time steps.
    #> 
    #>      Also, for bio15, the coefficient of variation was computed after
    #>      adding one to monthly estimates, and it was multiplied by 100
    #>      following <https://pubs.usgs.gov/ds/691/ds691.pdf>
    #> 
    #>      Changelog
    #> 
    #>      v1.1.0 Added monthly variables. Files can be downloaded from:
    #>      <https://zenodo.org/deposit/7062281>
    #> 
    #>      v1.0.0 Remove ice sheets and internal seas, and use correct
    #>      formula for bio15. Files can be downloaded from:
    #>      doi:10.6084/m9.figshare.19723405.v1
    #>      <https://doi.org/10.6084/m9.figshare.19723405.v1>
    #> 
    #> 
    #> #######################################################
    #> Documentation for _CHELSA 2.1_
    #> 
    #> Description:
    #> 
    #>      _CHELSA_ version 2.1 is a database of high spatial resolution
    #>      global weather and climate data, covering both the present and
    #>      future projections.
    #> 
    #> Details:
    #> 
    #>      IMPORTANT: If you use this dataset, make sure to cite the original
    #>      publication for the _CHELSA_ dataset:
    #> 
    #>      Karger, D.N., Conrad, O., B<c3><b6>hner, J., Kawohl, T., Kreft, H.,
    #>      Soria-Auza, R.W., Zimmermann, N.E., Linder, P., Kessler, M. (2017)
    #>      Climatologies at high resolution for the Earth land surface areas.
    #>      Scientific Data. 4 170122. doi:10.1038/sdata.2017.122
    #>      <https://doi.org/10.1038/sdata.2017.122>
    #> 
    #>      *Present-day reconstructions* are based on the mean for the period
    #>      1981-2000 and are available at at the high resolution of 0.5
    #>      arc-minutes (_CHELSA_2.1_0.5m_). In 'pastclim', the datasets are
    #>      given a date of 1990 CE (the mid-point of the period of interest).
    #>      There are 19 <e2><80><9c>bioclimatic<e2><80><9d> variables, as well as monthly estimates
    #>      for mean temperature, and precipitation. The dataset is very
    #>      large, as it includes estimates for the oceans as well as the land
    #>      masses. An alternative to downloading the very large files is to
    #>      use virtual rasters, which allow the data to remain on the server,
    #>      with only the pixels required for a given operation being
    #>      downloaded. Virtual rasters can be used by choosing
    #>      (_CHELSA_2.1_0.5m_vsi_)
    #> 
    #>      *Future projections* are based on the models in CMIP6, downscaled
    #>      and de-biased using the CHELSA algorithm 2.1. Monthly values of
    #>      mean temperature, and total precipitation, as well as 19
    #>      bioclimatic variables were processed for 5 global climate models
    #>      (GCMs), and for three Shared Socio-economic Pathways (SSPs): 126,
    #>      370 and 585. Model and SSP can be chosen by changing the ending of
    #>      the dataset name _CHELSA_2.1_GCM_SSP_RESm_.
    #> 
    #>      Available values for GCM are: "GFDL-ESM4", "IPSL-CM6A-LR",
    #>      "MPI-ESM1-2-HR", "MRI-ESM2-0", and "UKESM1-0-LL". For SSP, use:
    #>      "ssp126", "ssp370", and "ssp585". RES is currently limited to
    #>      "0.5m". Example dataset names are
    #>      _CHELSA_2.1_GFDL-ESM4_ssp126_0.5m_ and
    #>      _CHELSA_2.1_UKESM1-0-LL_ssp370_0.5m_
    #> 
    #>      As for present reconstructions, an alternative to downloading the
    #>      very large files is to use virtual rasters. Simply append "_vis"
    #>      to the name of the dataset of interest
    #>      (_CHELSA_2.1_GFDL-ESM4_ssp126_0.5m_vsi_).
    #> 
    #>      The dataset are averages over 30 year periods (2011-2040,
    #>      2041-2070, 2071-2100). In 'pastclim', the midpoints of the periods
    #>      (2025, 2055, 2075) are used as the time stamps. All 3 periods are
    #>      automatically downloaded for each combination of GCM model and
    #>      SSP, and are selected as usual by defining the time in functions
    #>      such as 'region_slice()'.
    #> 
    #> 
    #> #######################################################
    #> Documentation for _CHELSA-TracCE21k_
    #> 
    #> Description:
    #> 
    #>      CHELSA-TraCE21k data provides monthly climate data for temperature
    #>      and precipitation at 30 arc-sec spatial resolution in 100-year
    #>      time steps for the last 21,000 years. Palaeo-orography at high
    #>      spatial resolution and at each time step is created by combining
    #>      high resolution information on glacial cover from current and Last
    #>      Glacial Maximum (LGM) glacier databases with the interpolation of
    #>      a dynamic ice sheet model (ICE6G) and a coupling to mean annual
    #>      temperatures from CCSM3-TraCE21k. Based on the reconstructed
    #>      palaeo-orography, mean annual temperature and precipitation was
    #>      downscaled using the CHELSA V1.2 algorithm.
    #> 
    #> Details:
    #> 
    #>      More details on the dataset are available on its dedicated
    #>      website.
    #> 
    #>      An alternative to downloading very large files is to use virtual
    #>      rasters. Simply append "_vis" to the name of the dataset of
    #>      interest (_CHELSA_trace21k_1.0_0.5m_vsi_). This is the recommended
    #>      approach, and it is currently the only available version of the
    #>      dataset.
    #> 
    #>      IMPORTANT: If you use this dataset, make sure to cite the original
    #>      publication:
    #> 
    #>      Karger, D.N., Nobis, M.P., Normand, S., Graham, C.H., Zimmermann,
    #>      N. (2023) CHELSA-TraCE21k <e2><80><93> High resolution (1 km) downscaled
    #>      transient temperature and precipitation data since the Last
    #>      Glacial Maximum. Climate of the Past. doi:10.5194/cp-2021-30
    #>      <https://doi.org/10.5194/cp-2021-30>
    #> 
    #> Note:
    #> 
    #>      There is a missing time slice at -1300 years BP for
    #>      'temperature_min_07' and 'temperature_max_07' on the CHELSA
    #>      server. That timestep is replaced with -1200 years BP in
    #>      'pastclim' for those two variables.
    #> 
    #> 
    #> #######################################################
    #> Documentation for the Example dataset
    #> 
    #> Description:
    #> 
    #>      This dataset is a subset of Beyer2020, used for the vignette of
    #>      pastclim. Do not use this dataset for any real work, as it might
    #>      not reflect the most up-to-date version of Beyer2020.
    #> 
    #> 
    #> #######################################################
    #> Documentation for _HYDE 3.3_ dataset
    #> 
    #> Description:
    #> 
    #>      This database presents an update and expansion of the History
    #>      Database of the Global Environment (HYDE, v 3.3) and replaces
    #>      former HYDE 3.2 version from 2017. HYDE is and internally
    #>      consistent combination of updated historical population estimates
    #>      and land use. Categories include cropland, with a new distinction
    #>      into irrigated and rain fed crops (other than rice) and irrigated
    #>      and rain fed rice. Also grazing lands are provided, divided into
    #>      more intensively used pasture, converted rangeland and
    #>      non-converted natural (less intensively used) rangeland.
    #>      Population is represented by maps of total, urban, rural
    #>      population and population density as well as built-up area.
    #> 
    #> Details:
    #> 
    #>      The period covered is 10 000 BCE to 2023 CE. Spatial resolution is
    #>      5 arc minutes (approx. 85 km2 at the equator). The full _HYDE 3.3_
    #>      release contains: a Baseline estimate scenario, a Lower estimate
    #>      scenario and an Upper estimate scenario. Currently only the
    #>      baseline scenario is available in 'pastclim'
    #> 
    #>      More details on the dataset are available on its dedicated
    #>      website.
    #> 
    #>      IMPORTANT: If you use this dataset, make sure to cite the original
    #>      publication for the HYDE 3.2 (there is no current publication for
    #>      3.3):
    #> 
    #>      Klein Goldewijk, K., Beusen, A., Doelman, J., and Stehfest, E.:
    #>      Anthropogenic land-use estimates for the Holocene; HYDE 3.2, Earth
    #>      Syst. Sci. Data, 9, 927-953, 2017. doi:10.5194/essd-9-927-2017
    #>      <https://doi.org/10.5194/essd-9-927-2017>
    #> 
    #> 
    #> #######################################################
    #> Documentation for the Krapp2021 dataset
    #> 
    #> Description:
    #> 
    #>      This dataset covers the last 800k years, at intervals of 1k years,
    #>      and a resolution of 0.5 degrees in latitude and longitude.
    #> 
    #> Details:
    #> 
    #>      The units of several variables have been changed to match what is
    #>      used in WorldClim.
    #> 
    #>      IMPORTANT: If you use this dataset, make sure to cite the original
    #>      publication:
    #> 
    #>      Krapp, M., Beyer, R.M., Edmundson, S.L. et al. A statistics-based
    #>      reconstruction of high-resolution global terrestrial climate for
    #>      the last 800,000 years. Sci Data 8, 228 (2021).
    #>      doi:10.1038/s41597-021-01009-3
    #>      <https://doi.org/10.1038/s41597-021-01009-3>
    #> 
    #>      The version included in 'pastclim' has the ice sheets masked.
    #> 
    #>      Note that, for bio15, we use the corrected version, which follows
    #>      <https://pubs.usgs.gov/ds/691/ds691.pdf>
    #> 
    #>      Changelog
    #> 
    #>      v1.4.0 Change units to match WorldClim. Fix variable duplication
    #>      found on earlier versions of the dataset.
    #>      <https://zenodo.org/records/8415273>
    #> 
    #>      v1.1.0 Added monthly variables. Files can be downloaded from:
    #>      <https://zenodo.org/record/7065055>
    #> 
    #>      v1.0.0 Remove ice sheets and use correct formula for bio15. Files
    #>      can be downloaded from: doi:10.6084/m9.figshare.19733680.v1
    #>      <https://doi.org/10.6084/m9.figshare.19733680.v1>
    #> 
    #> 
    #> #######################################################
    #> Documentation for _Paleoclim_
    #> 
    #> Description:
    #> 
    #>      _Paleoclim_ is a set of high resolution paleoclimate
    #>      reconstructions, mostly based on the CESM model, downscaled with
    #>      the CHELSA dataset to 3 different spatial resolutions:
    #>      'paleoclim_1.0_2.5m' at 2.5 arc-minutes (~5 km),
    #>      'paleoclim_1.0_5m' at 5 arc-minutes (~10 km), and
    #>      'paleoclim_1.0_10m' 10 arc-minutes (~20 km). All 19 biovariables
    #>      are available. There are only a limited number of time slices
    #>      available for this dataset; furthermore, currently only time
    #>      slices from present to 130ka are available in 'pastclim'.
    #> 
    #> Details:
    #> 
    #>      More details on the dataset are available on its dedicated
    #>      website.
    #> 
    #>      IMPORTANT: If you use this dataset, make sure to cite the original
    #>      publication:
    #> 
    #>      Brown, Hill, Dolan, Carnaval, Haywood (2018) PaleoClim, high
    #>      spatial resolution paleoclimate surfaces for global land areas.
    #>      Nature <e2><80><93> Scientific Data. 5:180254
    #> 
    #> 
    #> #######################################################
    #> Documentation for the WorldClim datasets
    #> 
    #> Description:
    #> 
    #>      WorldClim version 2.1 is a database of high spatial resolution
    #>      global weather and climate data, covering both the present and
    #>      future projections.
    #> 
    #> Details:
    #> 
    #>      IMPORTANT: If you use this dataset, make sure to cite the original
    #>      publication:
    #> 
    #>      Fick, S.E. and R.J. Hijmans, 2017. WorldClim 2: new 1km spatial
    #>      resolution climate surfaces for global land areas. International
    #>      Journal of Climatology 37 (12): 4302-4315. doi:10.1002/joc.5086
    #>      <https://doi.org/10.1002/joc.5086>
    #> 
    #>      *Present-day reconstructions* are based on the mean for the period
    #>      1970-2000, and are available at multiple resolutions of 10
    #>      arc-minutes, 5 arc-minutes, 2.5 arc-minute and 0.5 arc-minutes.
    #>      The resolution of interest can be obtained by changing the ending
    #>      of the dataset name _WorldClim_2.1_RESm_, e.g. _WorldClim_2.1_10m_
    #>      or _WorldClim_2.1_5m_ (currently, only 10m and 5m are currently
    #>      available in 'pastclim'). In 'pastclim', the datasets are given a
    #>      date of 1985 CE (the mid-point of the period of interest). There
    #>      are 19 <e2><80><9c>bioclimatic<e2><80><9d> variables, as well as monthly estimates for
    #>      minimum, mean, and maximum temperature, and precipitation.
    #> 
    #>      *Future projections* are based on the models in CMIP6, downscaled
    #>      and de-biased using WorldClim 2.1 for the present as a baseline.
    #>      Monthly values of minimum temperature, maximum temperature, and
    #>      precipitation, as well as 19 bioclimatic variables were processed
    #>      for 23 global climate models (GCMs), and for four Shared
    #>      Socio-economic Pathways (SSPs): 126, 245, 370 and 585. Model and
    #>      SSP can be chosen by changing the ending of the dataset name
    #>      _WorldClim_2.1_GCM_SSP_RESm_.
    #> 
    #>      Available values for GCM are: "ACCESS-CM2", "BCC-CSM2-MR",
    #>      "CMCC-ESM2", "EC-Earth3-Veg", "FIO-ESM-2-0", "GFDL-ESM4",
    #>      "GISS-E2-1-G", "HadGEM3-GC31-LL", "INM-CM5-0", "IPSL-CM6A-LR",
    #>      "MIROC6", "MPI-ESM1-2-HR", "MRI-ESM2-0", and "UKESM1-0-LL". For
    #>      SSP, use: "ssp126", "ssp245", "ssp370", and "ssp585". RES takes
    #>      the same values as for present reconstructions (i.e. "10m", "5m",
    #>      "2.5m", and "0.5m"). Example dataset names are
    #>      _WorldClim_2.1_ACCESS-CM2_ssp245_10m_ and
    #>      _WorldClim_2.1_MRI-ESM2-0_ssp370_5m_. Four combination (namely
    #>      _FIO-ESM-2-0_ssp370_, _GFDL-ESM4_ssp245_, _GFDL-ESM4_ssp585_, and
    #>      _HadGEM3-GC31-LL_ssp370_) are NOT available.
    #> 
    #>      The dataset are averages over 20 year periods (2021-2040,
    #>      2041-2060, 2061-2080, 2081-2100). In 'pastclim', the midpoints of
    #>      the periods (2030, 2050, 2070, 2090) are used as the time stamps.
    #>      All 4 periods are automatically downloaded for each combination of
    #>      GCM model and SSP, and are selected as usual by defining the time
    #>      in functions such as 'region_slice()'.
    #> 
    #> 
    #> #######################################################
