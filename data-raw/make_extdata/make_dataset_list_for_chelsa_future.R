# start this script from this directory
chelsa_template <- read.csv("../data_files/chelsa_future_template.csv")
gcm <- c(
  "GFDL-ESM4","IPSL-CM6A-LR", "MPI-ESM1-2-HR","MRI-ESM2-0","UKESM1-0-LL"
)
scenarios <- c("ssp126","ssp370","ssp585")

resolutions <- c(0.5) # add 2.5 and 0.5
library(dplyr)
library(stringr)
chelsa_future <- chelsa_template[0, ]
for (i_gcm in gcm) {
  for (i_scenario in scenarios) {
    for (i_res in resolutions) {
      chelsa_this <- chelsa_template %>%
        mutate(
          dataset = str_replace(dataset, "XXX", i_gcm),
          file_name = str_replace(file_name, "XXX", i_gcm)
        ) %>%
        mutate(
          dataset = str_replace(dataset, "YYY", i_scenario),
          file_name = str_replace(file_name, "YYY", i_scenario)
        )
      #%>%
      #  mutate(
      #    dataset = str_replace(dataset, "ZZZ", as.character(i_res)),
      #    file_name = str_replace(file_name, "ZZZ", as.character(i_res))
      #  )
      chelsa_future <- chelsa_future %>% bind_rows(chelsa_this)
    }
  }
}
write.csv(chelsa_future, "../data_files/chelsa_future_list.csv",
  row.names = FALSE, na = ""
)
