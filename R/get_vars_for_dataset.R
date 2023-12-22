#' Get a list of variables for a given dataset.
#'
#' This function lists the variables available for a given dataset. Note that
#' the spelling and use of capitals in names might differ from the original
#' publications, as `pastclim` harmonises the names of variables across
#' different reconstructions.
#'
#' @param dataset string defining dataset to be downloaded (a list of possible
#' values can be obtained with [list_available_datasets()]).
#' @param path_to_nc the path to the custom nc file containing the palaeoclimate
#' reconstructions. If a custom nc file is given, 'details', 'annual' and 'monthly'
#' are ignored
#' @param details boolean determining whether the output should include information
#' including long names of variables and their units.
#' @param annual boolean to show annual variables
#' @param monthly boolean to show monthly variables
#' @returns a vector of variable names
#'
#' @export

get_vars_for_dataset <- function(dataset, path_to_nc = NULL, details = FALSE,
                                 annual = TRUE, monthly = FALSE) {
  if (dataset != "custom") {
    if (!is.null(path_to_nc)) {
      stop("path_to_nc should only be set for 'custom' dataset")
    }
    check_available_dataset(dataset)
    variable_info <- getOption("pastclim.dataset_list")[getOption("pastclim.dataset_list")$dataset == dataset, ]
    # select variable types
    # if (!all(monthly, annual)){
    #   variable_info <- variable_info[variable_info$monthly==monthly,]
    # }
    if (!monthly) {
      variable_info <- variable_info[variable_info$monthly == FALSE, ]
    }
    if (!annual) {
      variable_info <- variable_info[variable_info$monthly != FALSE, ]
    }
    if (!details) {
      return(variable_info$variable)
    } else {
      return(variable_info[, c("variable", "long_name", "units")])
    }
  } else {
    if (is.null(path_to_nc)) {
      stop("path_to_nc should be set for 'custom' dataset")
    }
    nc_in <- ncdf4::nc_open(path_to_nc)
    if (!details) {
      vars <- names(nc_in$var)
      ncdf4::nc_close(nc_in)
      return(names(nc_in$var))
    } else {
      get_detail <- function(x, attrib) {
        return(x[[attrib]])
      }
      vars_details <- data.frame(
        variable = names(nc_in$var),
        long_name = unlist(lapply(nc_in$var, get_detail, "longname")),
        units = unlist(lapply(nc_in$var, get_detail, "units"))
      )
      rownames(vars_details) <- NULL
      return(vars_details)
    }
  }
}

#' Check if var is available for this dataset.
#'
#' Internal getter function
#'
#' @param variable a vector of names of the variables of interest
#' @param dataset dataset of interest
#' @returns TRUE if var is available
#' @keywords internal

check_available_variable <- function(variable, dataset) {
  # check that the variable is available for this dataset
  if (!all(variable %in% get_vars_for_dataset(dataset, monthly = TRUE))) {
    missing_variables <- variable[!variable %in% get_vars_for_dataset(dataset,
      annual = TRUE,
      monthly = TRUE
    )]
    stop(
      paste(missing_variables, collapse = ", "), " not available for ", dataset,
      "; available variables are ",
      paste(get_vars_for_dataset(dataset, monthly = TRUE), collapse = ", ")
    )
  } else {
    return(TRUE)
  }
}

#' Get a the varname for this variable
#'
#' Internal function to get the varname for this variable
#'
#' @param variable string defining the variable name
#' @param dataset string defining dataset to be downloaded
#' @returns the name of the variable
#' @keywords internal

get_varname <- function(variable, dataset) {
  return(getOption("pastclim.dataset_list")$ncvar[getOption("pastclim.dataset_list")$variable == variable &
    getOption("pastclim.dataset_list")$dataset == dataset])
}
