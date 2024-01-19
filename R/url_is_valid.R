#' Test whether a URL is valid
#'
#' This function check that a URL points to a real file
#' @param url the url to test
#' @param verbose whether the status code should be outputted as a message
#' @returns boolean on whether the file exists
#'
#' @keywords internal
url_is_valid <- function(url, verbose = FALSE) {
    HTTP_STATUS_OK <- 200
    hd <- httr::HEAD(url)
    status <- hd$all_headers[[1]]$status
    if (verbose){
      message("status is ",status)
    }
    return(exists = status == HTTP_STATUS_OK)
}



