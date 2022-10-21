.onLoad <- function(libname, pkgname) {
  op <- options()
  op.pastclim <- list(
    pastclim.data_path = get_data_path()
  )
  toset <- !(names(op.pastclim) %in% names(op))
  if (any(toset)) options(op.pastclim[toset])

  invisible()
}
