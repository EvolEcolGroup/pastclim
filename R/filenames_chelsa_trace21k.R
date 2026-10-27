#' Generate file names to download the chelsa trace 21k
#'
#' This function creates a vector of paths needed to download the CHELSA
#' trace21k
#' @param dataset the name of the dataset of interest (currently unused)
#' @param bio_var the variable of interest
#' @returns a vector of times, one per band
#'
#' @keywords internal

filenames_chelsa_trace21k <- function(dataset, bio_var) {
  
  years <- seq(20, -200, by = -1)
  
  # helper to format year following the chelsa trace21k naming convention
  format_trace21k_year <- function(x) {
    vapply(
      x,
      function(y) {
        if (y < 0) {
          sprintf("-%03d", abs(y))
        } else {
          sprintf("%04d", y)
        }
      },
      FUN.VALUE = character(1)
    )
  }
  
  # format the years for the file names
  yr_fmt <- format_trace21k_year(seq(20, -200, by = -1))
  
  # based on the variable, get the original var prefix and name for chelsa
  if (grepl("^bio", bio_var)) {
    
    root <- paste0(
      "https://os.zhdk.cloud.switch.ch/",
      "chelsa01/chelsa_trace21k/global/bioclim/",
      bio_var
    )
    
    return(
      file.path(
        root,
        sprintf(
          "CHELSA_TraCE21k_%s_%s_V.1.0.tif",
          bio_var,
          format_trace21k_year(years)
        )
      )
    )
  } else if (grepl("temperature_min", bio_var)) {
    var_prefix <- "tasmin"
    var_index <- paste0(
      var_prefix, "_",
      as.numeric(substr(bio_var, nchar(bio_var) - 1, nchar(bio_var)))
    )
  } else if (grepl("temperature_max", bio_var)) {
    var_prefix <- "tasmax"
    var_index <- paste0(
      var_prefix, "_",
      as.numeric(substr(bio_var, nchar(bio_var) - 1, nchar(bio_var)))
    )
  } else if (grepl("precipitation", bio_var)) {
    var_prefix <- "pr"
    var_index <- paste0(
      var_prefix, "_",
      as.numeric(substr(bio_var, nchar(bio_var) - 1, nchar(bio_var)))
    )
  }
  # create file names for a given variable
  chelsa_trace_root <- "https://os.zhdk.cloud.switch.ch/chelsav1/chelsa_trace"
  file.path(
    chelsa_trace_root, var_prefix,
    paste0(
      "CHELSA_TraCE21k_", var_index, "_", yr_id, "_V",
      version, ".tif"
    )
  )
}
