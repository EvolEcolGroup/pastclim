#' Check that we have a valid pair of coordinate names
#'
#' This internal function checks that coords (as passed to functions) is a valid
#' set of names, or, if NULL, that we have standard variable names in data
#'
#' @param data a data.frame containing the locations.
#' @param coords a vector of length two giving the names of the "x" and "y"
#' coordinates, of points is a data.frame and does not use standard names.
#' @return A vector of length 2 with the valid names, in the correct order
#' @keywords internal

check_coords_names <- function(data, coords) {
  if (is.null(coords)) {
    valid_names <- list(
      c("x", "y"), c("longitude", "latitude"), c("lon", "lat"),
      c("X", "Y")
    )
  } else {
    valid_names <- list(coords)
  }
  # internal function to check that both x and y names are present
  check_pair <- function(valid_names, var_names) {
    all(!is.na(match(valid_names, var_names)))
  }
  # find if we have any pair
  valid_pair <- which(unlist(lapply(valid_names, check_pair, names(data))))
  if (length(valid_pair) != 1) {
    stop("There are no recognised coordinate columns, set their names with 'coords'")
  }

  return(valid_names[[valid_pair]])
}
