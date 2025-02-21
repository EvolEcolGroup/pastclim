# start this script from this directory
wc_template <-
  read.csv("../data_files/worldclim_future_template.csv")
gcm <- c(
  "ACCESS-CM2",
  "BCC-CSM2-MR",
  "CMCC-ESM2",
  "EC-Earth3-Veg",
  "FIO-ESM-2-0",
  "GFDL-ESM4",
  "GISS-E2-1-G",
  "HadGEM3-GC31-LL",
  "INM-CM5-0",
  "IPSL-CM6A-LR",
  "MIROC6",
  "MPI-ESM1-2-HR",
  "MRI-ESM2-0",
  "UKESM1-0-LL"
)
scenarios <- c("ssp126", "ssp245", "ssp370", "ssp585")
dates_df <- data.frame(
  orig = c("2021-2040", "2041-2060", "2061-2080", "2081-2100"),
  time_bp = (c(2030, 2050, 2070, 2090) - 1950)
)
resolutions <- c(10, 5, 2.5, 0.5) # add 2.5 and 0.5
library(dplyr)
library(stringr)
wc_future <- wc_template[0, ]
for (i_gcm in gcm) {
  for (i_scenario in scenarios) {
    # skip for the model scenarios that don't exist
    if (!any(
      (i_gcm == "FIO-ESM-2-0" & i_scenario == "ssp370"),
      (i_gcm == "GFDL-ESM4" & i_scenario == "ssp245"),
      (i_gcm == "GFDL-ESM4" & i_scenario == "ssp585"),
      (i_gcm == "HadGEM3-GC31-LL" & i_scenario == "ssp370")
    )) {
      for (i_res in resolutions) {
        wc_this <- wc_template %>%
          mutate(
            dataset = str_replace(dataset, "XXX", i_gcm),
            file_name = str_replace(file_name, "XXX", i_gcm)
          ) %>%
          mutate(
            dataset = str_replace(dataset, "YYY", i_scenario),
            file_name = str_replace(file_name, "YYY", i_scenario)
          ) %>%
          mutate(
            dataset = str_replace(dataset, "ZZZ", as.character(i_res)),
            file_name = str_replace(file_name, "ZZZ", as.character(i_res))
          )
        wc_future <- wc_future %>% bind_rows(wc_this)
      }
    }
  }
}
write.csv(
  wc_future,
  "../data_files/worldclim_future_list.csv",
  row.names = FALSE,
  na = ""
)
