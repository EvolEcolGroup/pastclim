#monthly_vars <- c(paste0("temperature_",sprintf("%02d", 1:12)),
#paste0("precipitation_",sprintf("%02d", 1:12)))
#pastclim:::download_dataset(dataset = "Krapp2021",bio_variables = monthly_vars)

setwd("~/Downloads/data/processed/")

krapp_new <- terra::rast(dir("./"))


krapp_temp <- pastclim::region_slice(time_bp = 0,
                                        dataset = "Krapp2021",
                                        bio_variables = paste0("temperature_",sprintf("%02d", 1:12)))
krapp_temp <- krapp_temp - 273.15

krapp_prec <- pastclim::region_slice(time_bp = 0,
                                     dataset = "Krapp2021",
                                     bio_variables = paste0("precipitation_",sprintf("%02d", 1:12)))
krapp_biovar <- pastclim::bioclim_vars(prec = krapp_prec, tavg = krapp_temp)

krapp_pastclim_biovar <- pastclim::region_slice(time_bp = 0,
                                              dataset = "Krapp2021",
                                              bio_variables = names(krapp_biovar))


cor_all<-vector()
for (i in names(krapp_biovar)){
  cor_all[i]<- cor.test(as.matrix(krapp_biovar[[i]]), 
           as.matrix(krapp_new[[i]]))$estimate
  
}
cor_all


# bio07, bio15

# bio12, bio13, bio14,bio16,bio17,bio18,bio19

# bio12 should not be divided by 12 (it should be the sum)
# bio13, bio14, bio16, bio17,bio18,and bio19 are divided by 12

# find discrepancies
#bio05
krapp_pastclim_biovar$bio10[101,150]
krapp_biovar$bio10[101,150]

krapp_temp[100,150]

# check that monhtly temperature make sense
this_temp<-ncdf4::nc_open("bio19_800ka.nc")
sep_temp<-ncdf4::ncvar_get(nc=this_temp,varid = "bio19")
sep_temp[,,800]->foo
foo[foo>10^10]<-NA
image(foo)
foo<-foo[,ncol(foo):1]
foo<-terra::rast(t(foo))
plot(foo)
foo[101,150]



#bio15 is seasonality. In Mario's formula, the +1 is only applied to the sum, but not the 

this_prec <- unlist(krapp_prec[101,150])
100*sd(this_prec)/((sum(this_prec)+1)/12)



## Unit issues
# bio04 in Krapp not multiplied by 100 (but maybe somethign else)
# bio12 in Krapp is the mean of the precipitation (not the total annual precipitation)
# bio16 and bio17 is the sum of the precipitation in that quarter, not the monthly mean

## inconsistencies
# bio05, bio06, bio07 are different as they are based on monthly temperatures using the pastclim function,
# but on monthly temperatures when using the downscaling functions. Depsite bio05 and bio06 being well correlated,
# bio07 (their difference) is not. However, bio05 and bio06 are less extreme than the monthly average, which does not make sense. 

#bio15

## Variable duplication
# bio08 is copy of bio10, 
# bio09 is copy of bio 11
# bio18 is a copy of bio16
# bio19 is a copy of bio17

cor.test(as.matrix(krapp_pastclim_biovar$bio16), 
         as.matrix(krapp_pastclim_biovar$bio18))$estimate
