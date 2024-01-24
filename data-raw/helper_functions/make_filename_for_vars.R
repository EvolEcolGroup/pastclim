# CHELSA present
var_names <- c(paste0("bio",sprintf("%02d", 1:19)),
          paste0("temp_",sprintf("%02d", 1:12)),
          paste0("prec_",sprintf("%02d", 1:12)))
version <- "1.0.0"
vsi <- ""  ## change to "_vsi" for virtual datasets
file_names<-paste0("CHELSA_2.1_0.5m_",var_names,"_v",version,vsi,".vrt")
write.csv(file_names, "chelsa_file_names.csv")


# CHELSA trace21k
var_names <- c(paste0("bio",sprintf("%02d", 1:19)),
               paste0("temperature_min_",sprintf("%02d", 1:12)),
               paste0("temperature_max_",sprintf("%02d", 1:12)),
paste0("precipitation_",sprintf("%02d", 1:12)))
version <- "1.0.0"
vsi <- ""  ## change to "_vsi" for virtual datasets
file_names<-paste0("CHELSA_trace21k_1.0_0.5m_",var_names,"_v",version,vsi,".vrt")
write.csv(file_names, "chelsa_file_names.csv")


# WorldClim present
var_names <- c(paste0("bio",sprintf("%02d", 1:19)),
               "altitude",
               paste0("temperature_",sprintf("%02d", 1:12)),
               paste0("precipitation_",sprintf("%02d", 1:12)),
               paste0("temperature_min_",sprintf("%02d", 1:12)),
               paste0("temperature_max_",sprintf("%02d", 1:12)))
version <- "2.0.0"
vsi <- ""  ## change to "_vsi" for virtual datasets
file_names<-paste0("WorldClim_2.1_5m_",var_names,"_v",version,vsi,".vrt")
write.csv(file_names, "wc_current_file_names.csv")


# WorldClim future
var_names <- c(paste0("bio",sprintf("%02d", 1:19)),
               paste0("precipitation_",sprintf("%02d", 1:12)),
               paste0("temperature_min_",sprintf("%02d", 1:12)),
               paste0("temperature_max_",sprintf("%02d", 1:12)))
version <- "2.0.0"
vsi <- ""  ## change to "_vsi" for virtual datasets
file_names<-paste0("WorldClim_2.1_XXX_YYY_ZZZm_",var_names,"_v",version,vsi,".vrt")
write.csv(file_names, "wc_future_file_names.csv")
