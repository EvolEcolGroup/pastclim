#' Clean the data path 
#'
#' This function deletes old reconstructions that have been superseded in the
#' data_path. It assumes that the only files in data_path are part of `pastclim`
#' (i.e. there are no custom datasets stored in that directory).
#'
#' @param ask boolean on whether the user should be asked before deleting
#' @returns TRUE if files are deleted successfully
#' @export

clean_data_path <- function(ask=TRUE) {
  if (is.null(get_data_path(silent=TRUE))){
    message("The data path has not been set yet; use set_data_path() first!")
    return(FALSE)
  }
  files_now <- list.files(get_data_path())
  # remove some exceptions (we should check if the dataset list is still
  # current or whether it has become obsolete)
  files_now <- files_now[!files_now %in% c("pastclim_dataset_list.csv")]
  # keep worldclim datasets
  files_now <- files_now[!substr(files_now,1,2)=="wc"]
  # keep etopo datasets
  files_now <- files_now[!substr(files_now,1,5)=="etopo"]
  # keep chelsa datasets
  files_now <- files_now[!substr(files_now,1,6)=="chelsa"]
  
  
  possible_files <- unique(getOption("pastclim.dataset_list")$file_name)
  files_to_remove <- files_now[!files_now %in% possible_files]
  if (length(files_to_remove)>0){
    if (ask){
      this_answer <- utils::menu(choices = c("yes","no"),
                title = paste("The following files are obsolete:\n",
                                   paste(files_to_remove,collapse = ", "),
                                   "\n Do you want to delete them?"))
    } else { # default to delete if we are not asking
      this_answer <- 1
    }
    if (this_answer==1){
      file.remove(file.path(get_data_path(),files_to_remove))
    }
  } else {
    message("Everything is up-to-date; no files need removing.")
  }
  return(TRUE)
}
