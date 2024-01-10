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

## Modern chelsa with virtual dataset
chelsa_present_bio_url <- paste0("/vsicurl/https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/climatologies/1981-2010/bio/CHELSA_bio",1:19,"_1981-2010_V.2.1.tif")
chelsa_present_time <- paste(rep(0,length(chelsa_present_bio_url)),collapse=",")
vrt_path <- vrt(chelsa_present_bio_url,"chelsa_vsicurl.vrt",options="-separate", overwrite=TRUE, return_filename=TRUE)

# add metadata
x<- xml2::read_xml(vrt_path)
# add a child with times
xml_add_child(x,"Time",chelsa_present_time)
# add band description
band_nodes <- xml2::xml_find_all(x, xpath="VRTRasterBand")
for (i_node in seq_len(length(band_nodes))){
  xml_add_child(band_nodes[i_node],"Description",paste0("bio",i_node))
}
xml2::write_xml(x, vrt_path)
###
# And now read it in terra
foo<-rast(vrt_path)
# add time dimension
x<- xml2::read_xml(vrt_path)
time_node <- xml2::xml_find_all(x, xpath="Time")
pastclim::time_bp(foo) <- as.numeric(strsplit(xml_text(time_node),",")[[1]])
coords<-data.frame(longitude = c(5, -4, 27, -6, -24), latitude = c(7, 44, 36, 56, 31))
extract(foo,coords)
