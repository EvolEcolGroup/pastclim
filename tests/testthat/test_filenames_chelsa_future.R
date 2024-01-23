# test that the files names generated for chelsa present do point to a valid file

test_that("filenames_chelsa_present are correct", {
  skip_if_offline()
  datasets <- c("GFDL-ESM4","IPSL-CM6A-LR", "MPI-ESM1-2-HR","MRI-ESM2-0","UKESM1-0-LL")
  scenarios <- c("ssp126","ssp370","ssp585")
  # annual variables
  variables <- c(paste0("bio",sprintf("%02d", 1:19)))
  
  target_datasets <- paste("CHELSA_2.1", datasets,
        sample(scenarios, length(datasets),replace = TRUE),
        "0.5m", sep="_")
  for (i in seq_len(length(target_datasets))){
    bio_files <- filenames_chelsa_future(dataset = target_datasets[i], 
                                         bio_var = sample(variables, 1))
    expect_true(url_is_valid(bio_files[sample(1:3,1)]))
  }
  # monthly variables
  variables <- c(paste0("temperature",sprintf("%02d", 1:12)),
                 paste0("precipitation",sprintf("%02d", 1:12)))
  
  for (i in seq_len(length(target_datasets))){
    bio_files <- filenames_chelsa_future(dataset = target_datasets[i], 
                                         bio_var = sample(variables, 1))
    expect_true(url_is_valid(bio_files[sample(1:3,1)]))
  }  
  
  
}
)