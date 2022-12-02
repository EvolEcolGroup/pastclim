#' Generate pretty variable labels for plotting
#'
#' Generate pretty labels (in the form of an \code{expression}) that can be used
#' for plotting
#'
#' @param x either a character vector with the names of the variables, or a 
#' \code{SpatRaster} generated with \code{region_slice}
#' @param dataset string defining dataset to be downloaded (a list of possible
#' values can be obtained with \code{get_available_datasets}). This function
#' will not work on custom datasets.
#' @param with_units boolean defining whether the label should include units
#' @param abbreviated boolean defining whether the label should use abbreviations
#' for the variable
#' @returns a \code{expression} that can be used as a label in plots
#'
#' @export
#' @examples
#' var_labels("bio01", dataset = "Example")
#' 
#' # set the data_path for this example to run on CRAN
#' # users don't need to run this line
#' set_data_path_for_CRAN()
#' 
#' # for a SpatRaster
#' climate_20k <- region_slice(
#' time_bp = -20000,
#' bio_variables = c("bio01", "bio10", "bio12"),
#' dataset = "Example"
#' )
#' terra::plot(climate_20k, main = var_labels(climate_20k, dataset = "Example"))
#' terra::plot(climate_20k, main = var_labels(climate_20k, dataset = "Example",
#'                    abbreviated = TRUE))


var_labels <- function(x, dataset, with_units=TRUE,
                       abbreviated = FALSE){
  if (is.null(dataset) | !(dataset %in% get_available_datasets())){
    stop("dataset should be one of ", 
         paste(get_available_datasets(), collapse=", "))
  }
  if (inherits(x,"SpatRaster")){
    variables <- names(x)
  } else if (inherits(x,"character")) {
    variables <- x
  } else {
    stop ("x should be either a character vector or a SpatRaster")
  }
  
  # get variable details for this dataset
  sub_table <- getOption("pastclim.dataset_list")[getOption("pastclim.dataset_list")$dataset==dataset,]

  indeces <- match(variables, sub_table$variable)
  if (any(is.na(indeces))){
    stop (variables[which(is.na(indeces))]," does not exist in dataset ",dataset)
  }
  
  pretty_names <-c()
  for (i in indeces){
    if (!abbreviated){
      base_name <- sub_table$long_name[i]
    } else {
      base_name <- sub_table$abbreviated_name[i]
    }
    if (sub_table$units[i]!="" & with_units){
      this_name <- paste('"',base_name,' ("',sub_table$units_exp[i],'")"', sep="")
    } else {
      this_name <- paste('"',base_name,'"', sep="")
    }
    pretty_names <- c(pretty_names,this_name)
  }
  return(parse(text = pretty_names))
}
