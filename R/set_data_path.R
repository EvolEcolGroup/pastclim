#' Set the data path where climate reconstructions will be stored
#'
#' This function sets the path where climate reconstructions will be stored.
#' This
#' information is stored in a file names "pastclim_data.txt", which is found
#' in the directory returned by `tools::R_user_dir("pastclim","config")` (i.e.
#' the default configuration directory for the package as set in R >= 4.0).
#'
#' @param path_to_nc the path to the file that contains the downloaded
#' reconstructions. If left unset, the default location returned by
#' `tools::R_user_dir("pastclim","data")` will be used
#' @param ask boolean on whether the user should be asked to confirm their
#' choices
#' @param write_config boolean on whether the path should be saved in a config
#' file
#' @param copy_example boolean on whether the example dataset should be saved
#' in the data_path
#' @param on_CRAN boolean; users should NOT need this parameters. It is used to set up a
#' data path in the temporary directory for examples and tests
#' to run on CRAN.
#' @return TRUE if the path was set correctly
#'
#' @export

set_data_path <- function(path_to_nc = NULL, ask = TRUE, write_config = TRUE,
                          copy_example = TRUE, on_CRAN = FALSE) {
  # set up options that we will need for running on CRAN
  if (on_CRAN) {
    # set up data path for this test
    path_to_nc <- file.path(tempdir(), "pastclim_data")
    # clear it if it exists
    unlink(path_to_nc, recursive = TRUE)
    # set data path
    ask <- FALSE
    write_config <- FALSE
    copy_example <- TRUE
  }

  if (is.null(path_to_nc)) {
    data_dir <- tools::R_user_dir("pastclim", "data")
  } else {
    data_dir <- normalizePath(path_to_nc, mustWork = FALSE)
  }
  if (ask) { # if we ask the user
    message_to_user <- paste0(
      "The data_path will be set to ",
      data_dir, ".\n"
    )
    if (copy_example) {
      message_to_user <- paste0(
        message_to_user,
        "A copy of the Example dataset will be copied there.\n"
      )
    }

    if (write_config) {
      message_to_user <- paste0(
        message_to_user,
        "This path will be saved by pastclim for future use.\n"
      )
    } else {
      message_to_user <- paste0(
        message_to_user,
        "You have chosen not to save the path for future use.\n",
        "You will have to reset the path when R is restarted.\n"
      )
    }
    message_to_user <- paste0(message_to_user, "Proceed?")
    user_choice <- utils::menu(c("Yes", "No"), title = message_to_user)
  } else { # else, if we don't ask, answer yes
    user_choice <- 1
  }

  # if the user said yes
  if (user_choice == 1) {
    # if the data directory does not exist, attempt to make it
    if (!dir.exists(data_dir)) {
      dir.create(data_dir, recursive = TRUE)
      # do we need to check successful dir creation, or does it raise an error?
    }
    # if requested, write the path in a config file for future use
    if (write_config) {
      # if we don't have a config directory, create one
      if (!dir.exists(tools::R_user_dir("pastclim", "config"))) {
        dir.create(tools::R_user_dir("pastclim", "config"), recursive = TRUE)
      }
      utils::write.table(data_dir,
        row.names = FALSE,
        col.names = FALSE,
        file = file.path(
          tools::R_user_dir("pastclim", "config"),
          "pastclim_data.txt"
        )
      )
    }
  } else { # if the user said no
    message("Aborted: the data path was not set.")
    return(FALSE)
  }
  # update option
  options(pastclim.data_path = data_dir)
  # if requested, copy the example dataset in it
  if (copy_example) {
    copy_example_data()
  }
  return(TRUE)
}


#' Internal function to copy the example dataset when a new data path is set
#'
#' Copy example dataset
#'
#' @returns TRUE if the data were copied successfully
#'
#' @keywords internal

copy_example_data <- function() {
  example_filename <- unique(getOption("pastclim.dataset_list")$file_name[getOption("pastclim.dataset_list")$dataset == "Example"])
  if (!file.exists(file.path(get_data_path(), example_filename))) {
    file.copy(
      from = system.file(file.path("/extdata", example_filename),
        package = "pastclim"
      ),
      to = file.path(get_data_path(), example_filename)
    )
  }
  return(TRUE)
}
