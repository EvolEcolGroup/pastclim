# CHELSA present
var_names <- c(paste0("bio",sprintf("%02d", 1:19)),
          paste0("temp_",sprintf("%02d", 1:12)),
          paste0("prec_",sprintf("%02d", 1:12)))
version <- "1.0.0"
vsi <- ""  ## change to "_vsi" for virtual datasets
file_names<-paste0("CHELSA_2.1_0.5m_",var_names,"_v",version,vsi,".vrt")
write.csv(file_names, "chelsa_file_names.csv")