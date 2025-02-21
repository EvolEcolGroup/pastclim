filenames_chelsa_trace21k <- function(dataset, bio_var, version = NULL) {
  if (dataset == "CHELSA_trace21k_1.0") {
    version <- "1.0"
  }

  yr_id <- seq(0, -200, by = -1)

  # based on the variable, get the original var prefix and name for chelsa
  if (any("bio" %in% substr(bio_var, 1, 3))) {
    var_prefix <- "bio"

    var_index <- paste0(
      var_prefix,
      sprintf(
        "%02d",
        as.numeric(substr(bio_var, nchar(bio_var) - 1, nchar(bio_var)))
      )
    )
  } else if (any("tem" %in% substr(bio_var, 1, 3))) {
    var_prefix <- "tas"
    var_index <- paste0(
      var_prefix, "_",
      sprintf(
        "%02d",
        as.numeric(substr(bio_var, nchar(bio_var) - 1, nchar(bio_var)))
      )
    )
  } else if (any("pre" %in% substr(bio_var, 1, 3))) {
    var_prefix <- "pr"
    var_index <- paste0(
      var_prefix, "_",
      sprintf(
        "%02d",
        as.numeric(substr(bio_var, nchar(bio_var) - 1, nchar(bio_var)))
      )
    )
  }
  # create file names for a given variable
  chelsa_trace_root <- "https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V1/chelsa_trace"
  file.path(chelsa_trace_root, var_prefix, paste0("CHELSA_TraCE21k_", var_index, "_", yr_id, "_V", version, ".tif"))
}


########################
# testing the file names are correct

foo <- filenames_chelsa_trace21k(dataset = "CHELSA_trace21k_v1.0", bio_var = "bio01")
# check that a file exists
urlFileExist <- function(url) {
  HTTP_STATUS_OK <- 200
  hd <- httr::HEAD(url)
  status <- hd$all_headers[[1]]$status
  list(exists = status == HTTP_STATUS_OK, status = status)
}
urlFileExist(foo[1])
# if we have several (but not too many), we could use
foo_exist <- lapply(foo, urlFileExist)

# terra::describe(foo[1])
