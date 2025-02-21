#' Test whether a URL is valid
#'
#' This function check that a URL points to a real file
#' @param url the url to test
#' @param verbose whether the status code should be outputted as a message
#' @returns boolean on whether the file exists
#'
#' @keywords internal
url_is_valid <- function(url, verbose = FALSE) {
  if (requireNamespace("httr", quietly = TRUE)) {
    HTTP_STATUS_OK <- 200
    HTTP_STATUS_REDIRECT_SUCCESS <- 302
    hd <- httr::HEAD(url, httr::timeout(30))
    status <- hd$all_headers[[1]]$status
    if (verbose) {
      message("status is ", status)
    }
    return(status %in% c(HTTP_STATUS_OK, HTTP_STATUS_REDIRECT_SUCCESS))
  } else {
    stop(
      "to use this function, first install package 'httr' with\n",
      "install.packages('httr')"
    )
  }
}
