library("pastclim")
library("tidysdm")
date <- seq(-600000,-620000,-4000)
tic("start")
climate <- region_series(time_bp=date,
                        bio_variables=c("bio05","bio06"),
                        dataset="Krapp2021",
                        crop=region_outline$Europe)
toc()


tic("start")
date <- -600000
climate <- region_slice(time_bp=date,
                         bio_variables=c("bio05","bio06"),
                         dataset="Krapp2021",
                         crop=region_outline$Europe)
toc()
