curl::curl_download(url = "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/5km/CHELSA_pr_1981-2010_V.2.1.nc",
                    destfile = "../../project_temp/chelsa/CHELSA_pr_2.5min.nc")
foo<-rast ("../../project_temp/chelsa/CHELSA_pr_5min.nc",lyrs="pr_1")