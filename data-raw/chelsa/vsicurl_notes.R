foo2 <- terra::rast("/vsicurl/https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V1/chelsa_trace/bio/CHELSA_TraCE21k_bio01_-101_V1.0.tif ")
e <- ext(-5, 5, -5, 5)
foo2 <- crop(foo2,e)
foo3<-aggregate(foo2,50)

# use orog to mask ocean
# do we have ice as well?

tiff_url <- c ("/vsicurl/https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V1/chelsa_trace/bio/CHELSA_TraCE21k_bio01_-101_V1.0.tif",
   "/vsicurl/https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V1/chelsa_trace/bio/CHELSA_TraCE21k_bio01_-102_V1.0.tif", 
   "/vsicurl/https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V1/chelsa_trace/bio/CHELSA_TraCE21k_bio01_-103_V1.0.tif")
foo2<-terra::rast(tiff_url)
coords<-data.frame(longitude = c(5, -4, 27, -6, -24), latitude = c(7, 44, 36, 56, 31))
extract(foo2,coords)


library(terra)
# build a vrt file in this way, which can then be served
foo<-vrt(tiff_url,"local_vrt.vrt",options="-separate", overwrite=TRUE)
time(foo,tstep="years")<-c(-1000,0,1000)
coords<-data.frame(longitude = c(5, -4, 27, -6, -24), latitude = c(7, 44, 36, 56, 31))
extract(foo,coords)
e <- ext(-5, 5, -5, 5)
foo <- crop(foo,e)
foo3<-aggregate(foo,50)
plot(foo)

##
# cloud optimised geotiff (not available for bio variables yet)
describe("/vsicurl/https://os.zhdk.cloud.switch.ch/chelsa01/chelsa_trace21k/global/centennial/pr/CHELSA_TraCE21k_pr_01_-200_V.1.0.tif")
describe("/vsicurl/https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V1/chelsa_trace/bio/CHELSA_TraCE21k_bio01_-101_V1.0.tif")

