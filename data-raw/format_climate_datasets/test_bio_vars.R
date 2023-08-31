monthly_vars <- c(paste0("temperature_",sprintf("%02d", 1:12)),
paste0("precipitation_",sprintf("%02d", 1:12)))

pastclim:::download_dataset(dataset = "Krapp2021",bio_variables = monthly_vars)

krapp_present <- pastclim::region_slice(time_bp = 0,
                                        dataset = "Krapp2021",
                                        bio_variables = monthly_vars)
