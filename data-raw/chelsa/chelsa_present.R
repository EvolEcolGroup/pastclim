curl::curl_download(url = "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/5km/CHELSA_pr_1981-2010_V.2.1.nc",
                    destfile = "../../project_temp/chelsa/CHELSA_pr_2.5min.nc")
foo<-rast ("../../project_temp/chelsa/CHELSA_pr_5min.nc",lyrs="pr_1")

download_chelsa_present <- function(annual=TRUE, monthly = FALSE){
  vars_prefix <- NULL
  if (annual){
    vars_prefix <- c(vars_prefix, "bio")
  }
  if (monthly){
    vars_prefix <- c(vars_prefix, "pr", "tas")
  }
  for (i_var in vars_prefix){
    if (i_var=="bio"){
      indices <- 1:19
    } else {
      indices <- 1:12
    }
    download_url <- paste0("/vsicurl/https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/",
    i_var,"/CHELSA_",i_var,indices,"_1981-2010_V.2.1.tif")
    time_vector <- paste(rep(0,length(chelsa_present_bio_url)),collapse=",")
    vrt_path <- vrt(chelsa_present_bio_url,"chelsa_vsicurl.vrt",options="-separate", overwrite=TRUE, return_filename=TRUE)
    
    
    
  }

  
}